#& header
    $headers=@{}
    $headers.rd=$pwd

    function eo($o){
        $t=@{membertype='scriptmethod';force=$null;membername=$o[1];value=$o[2]};
        $o[0]|update-typedata @t
    }

    eo('string','pastelize',{param($s)
        $crc32=add-type "[DllImport(""ntdll.dll"")`n]public static extern uint RtlComputeCrc32(uint dwInitial, byte[] pData, int iLen);" -name _ -passthru
        $math=[math]
        function hslc($o){
            $h=$o[0];$s=$o[1];$l=$o[2];

            $h=[double]($h/360)

            if ($s -eq 0) {$r=$g=$b=$l} else {
                if ($l -lt 0.5){$q=$l*(1+$s)}else{$q=$l+$s-$l*$s}
                $p=2*$l-$q
                function n($o){
                    $p=$o[0];$q=$o[1];$t=$o[2];

                    if ($t -lt 0){$t+=1}
                    if ($t -gt 1){$t-=1}
                    if ($t -lt 1/6){return $p + ($q - $p) * 6 * $t}
                    if ($t -lt 1/2){return $q}
                    if ($t -lt 2/3){return $p + ($q - $p) * (2/3-$t) * 6}
                    return $p
                }

                $r=n($p,$q,($h+1/3))
                $g=n($p,$q,$h);
                $b=n($p,$q,($h-1/3))
            }


            $f=@()
            #$f='#'
            $f+=([byte]$math::round($r*255))#.tostring('x2')
            $f+=([byte]$math::round($g*255))#.tostring('x2')
            $f+=([byte]$math::round($b*255))#.tostring('x2')

            return $f
        }

        $utf8=[text.encoding]::utf8
        $t=if($s){$s}else{$this}
        $y=$utf8.getbytes($t)
        $hash=$crc32::rtlcomputecrc32(0,$y,$y.count)
        

        <#
        $u=hslc(@(
            $math::floor($hash/551%360);
            (0.85+(1.0-0.85)*($math::floor($hash/434%101)/100));
            #(0.65+(0.9-0.65)*($math::floor($hash/575%101)/100))
            (0.7+(0.9-0.7)*($math::floor($hash/575%101)/100))
        ))
        #>

        $u=hslc(@(
            $math::floor((($hash/62)*2859)%360);
            (0.85+(1.0-0.85)*($math::floor((($hash/11)*504)%101)/100));
            (0.7+(0.9-0.7)*($math::floor((($hash/19)*634)%101)/100))
        ))

        $e=[char]27

        #return $this.color("<$(hslh($f))>")
        return "$e[38;2;$($u[0]);$($u[1]);$($u[2])m$this$e[37m"
        #return hslh($f)
    })

    eo('string','color',{param($s)
        $e=[char]27;
        $s+=$this;
        $d=@{black='#1e1e1e';darkblue='#0037da';darkgreen='#13a10e';darkcyan='#3a96dd';darkred='#c50f1f';darkmagenta='#800080';darkyellow='#cc7703';
        gray='#cdd6f4';darkgray='#767676';blue='#3b78ff';green='#16c60c';cyan='#61d6d6';red='#e74856';magenta='#b4009e';yellow='#f9f1a5';white='#eeedf0';
        reset="$e[0m";};
        $z='(?<!\\)';$g=[regex]"(.+?)\s*($z\,\s*|$)";$v="$z\\(<|>|\\)"
        $t=([regex]"(?s)(?:$z<\s*(.+?)\s*>|^)?(.+?\n*)(?=$z<|$)").matches(($s-replace"$z\\n",("`n")))
        foreach($h in $t.getenumerator()){
            $l=$h.groups[2].value-replace"$v",'$1';$r=$g.matches($h.groups[1].value);$q=@();
            foreach($y in $r.getenumerator()){$q+=$y.groups[1].value-replace"$v",'$1'}
            if($q.length-eq0){$q+=''};$c,[array]$q=$q;if(!$q){$q=@()}

            if($d[$c]){$c=$d[$c]};

            if(($c[0]-eq'#')-and($q.length-eq0)){
                #$k=38;$p=37;if($c[7]-eq'!'){$k=47;$p=40}
                $u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[byte]"0x$r"};
                $l="$e[38;2;$($u[0]);$($u[1]);$($u[2])m$l$e[37m"
            }else{
                switch -regex ($c){
                    default {$l=$c+$l}
                    "^p$" {$l=$l.pastelize($q[0])}
                    "^#" {}
                }
            };
            $f+=$l
        }
        return $f
    })

    eo('string','lengthc',{
        $f=$this-replace'\x1b\[.+?m',''

        return $f.length
    })

    function w($s){
        $p=@{nonewline=$null};
        write-host @p $s.color()
    }

    function signature($s){#if(!($s-is[array])){$s=@($s)}
        #$f=(($t=($s|rvpa -relative))[2..($t.length-1)]-join'').pastelize() # .substring(2)
        $f=(($s|rvpa -relative)-replace'^.{2}',''-replace'(?<!\\)\\','\\').pastelize()
        return ("[$f] ")
    }

    #add-type -assemblyname 'web.extensions'
    class json{
        json(){}

        [hashtable]cparse($s){
            if((test-path $s)-eq$true){$s=(gc -raw -path $s)}
            return $this.parse($s-replace'(?m)(?<=^([^"]|"[^"]*")*)//.*'-replace'(?ms)/\*.*?\*/')
        }

        [hashtable]parse($s){
            if((test-path $s)-eq$true){$s=(gc -raw -path $s)}
            $h=@{};$f=@{};
            foreach($t in ($s|convertfrom-json).psobject.properties){
                $a=$t.name;$b=$t.value;
                $h[$a]=$f[$a]=$b;
            };

            $p=new-object web.script.serialization.javascriptserializer
            $p.maxjsonlength=$s.length
            $n=$p.deserialize($s,[hashtable])

            foreach($t in $h.getenumerator()) {
                $a=$t.name;$b=$t.value;
                if($b.length-eq$null){$f[$a]=$n[$a]};
            };

            return $f
        }

        [string]format($s){
            $indent = 0;
            return ($s -Split "`n" | % {
                if ($_ -match '[\}\]]\s*,?\s*$') {$indent--};
                $line = ('  ' * $indent) + $($_.TrimStart() -replace '":  (["{[])', '": $1' -replace ':  ', ': ');
                if ($_ -match '[\{\[]\s*$') {$indent++};
                $line
            }) -Join "`n"
        }

        [string]stringify($o){
            return ($this.format(($o|convertto-json)))
        }
    }
    $json=[json]::new()

#~/\!#*+-%=&?.


if(!($n=$myinvocation.mycommand.name)){$n='t'};($u=[console])::setwindowsize(($t=120),30);
$u::setbuffersize($t,4096);$u::title=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($mu=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<p,$n>て$n".color()}#*@ >.<


#$start=[diagnostics.stopwatch]::startnew()

# ?? temp srryy
#$env:computername='rz09-lily'
#$env:fps_browser_app_profile_string='Firefox Nightly'



#~
#/
#\

#!
##
#*
#+
#-
#%
#=
#&
#?
#.

#+@

#$t=(gc -raw '.\teic.txt').color();$t>teic.ascii
#cls

$sw=[diagnostics.stopwatch]::startnew()
#$sw.elapsed.totalmilliseconds

$f=(gc '.\teic.ascii')
$f+=''
for($i=0;$i-lt$f.length;$i++){$f[$i]+=' '*4}

$windows=(gp "hklm:\software\microsoft\windows nt\currentversion") #!@ i dont think this is right srry
$console=(gp "hkcu:\console")
#$bios=(gp "hklm:\hardware\description\system\bios")
$cpu=(gp "hklm:\hardware\description\system\centralprocessor\0").processornamestring
$browser=(gp "hkcu:\software\microsoft\windows\shell\associations\urlassociations\http\userchoice").progid-replace'(.+?)Url.+','$1'


#$gpus=(get-wmiobject 'win32_videocontroller') #|?{$_.property.dedicatedvideomemory -gt 0}
$t=(gci "hklm:\software\microsoft\directx")|gp|?{$_.dedicatedvideomemory -gt 0} #? different way to get gpus but might be weird srryy
$gpus=@();$foundgpus=@();
foreach($h in $t){
    if($foundgpus.contains($h.description)){continue}
    #$h
    $foundgpus+=$h.description
    $gpus+=$h
}

$os=(get-ciminstance 'win32_operatingsystem')

$cs=(get-ciminstance 'win32_computersystem')

$math=[math]


$gray="<#cccccc>";$tred="<#9a293e>"

$i=0;$pad='';
$f[$i++]+="<p>$env:username<white>@<p>$env:computername" #= username@computername
#$([char]0xf48b) 
$f[$i++]+="<#5c5f66>"+"-"*("$env:username@$env:computername").length #= --- seperator

$f[$i++]+=$tred+"os$gray`: "+$windows.productname+" "+$windows.displayversion+" x$([intptr]::size*8)" #= os:
# $bios.systemproductname
$f[$i++]+=$tred+"model$gray`: "+$cs.model #= model:


$t=(get-date) - $os.lastbootuptime
$tt=$tred+"uptime$gray`: "
if($t.days-gt0){$tt+="$($t.days)d "}
if($t.hours-gt0){$tt+="$($t.hours)h "}
if($t.minutes-gt0){$tt+="$($t.minutes)m "}



$f[$i++]+=$tt #= uptime:


$f[$i++]+=$tred+"browser$gray`: "+$browser #= browser:



$f[$i++]+=$tred+"font$gray`: "+$console.facename #= font:


#* previous powerline location srry


$f[$i++]+=$tred+"cpu$gray`: "+$cpu #= cpu:

$q=0
for($c=$gpus.length-1;$c-ge0;$c--){
    $p=$gpus[$c];$q++
    $f[$i++]+=$tred+"gpu $q$gray`: "+$p.description
}
$tt=''


$memory=@{
    tgb=($cs.totalphysicalmemory / 1gb);
    fgb=(($os.freephysicalmemory * 0x400) / 1gb)
}
$memory.ugb=($memory.tgb-$memory.fgb)


$t=(($memory.ugb/$memory.tgb)*100)
$c=if($t-gt90){'#ff8080'}else{'#c9a0dc'}
$f[$i++]+=$tred+"memory$gray`: "+$memory.ugb.tostring('#,0.00')+"gb / "+$memory.tgb.tostring('#,0.00')+"gb (<$c>"+$t.tostring('#,0')+"%$gray)" #= memory:

$dr=(gdr c)
#$dr|select *

$disk=@{
    ugb=($dr.used/1gb);
    fgb=($dr.free/1gb)
}
$disk.tgb=$disk.ugb+$disk.fgb

#$disk

$t=(($disk.ugb/$disk.tgb)*100)
$c=if($t-gt90){'#ff8080'}else{'#c9a0dc'}

$f[$i++]+=$tred+"disk$gray`: "+$disk.ugb.tostring('#,0.00')+"gb / "+$disk.tgb.tostring('#,0.00')+"gb (<$c>"+$t.tostring('#,0')+"%$gray)"    #= disk:


$ip=(test-connection -computername (hostname) -count 1).ipv4address.ipaddresstostring
#$ip=(ipconfig|findstr IPv4)-replace'.+\:\s'
$f[$i++]+=$tred+"ip$gray`: "+$ip


switch ($env:powerline_command) { #= powerline:
    'oh-my-posh'{
        $i++
        $f[$i++]+=$tred+"oh-my-posh$gray`:"
        $pad=' '*2
        $t=$env:posh_shell_version-replace'(.+?\..+?)\..+','$1'
        $f[$i++]+=$pad+$tred+"shell$gray`: <p,$env:posh_shell_version>$env:posh_shell $t" #? pastelize with $t or full version srry

        $theme=$json.cparse($env:posh_theme)

        if($theme.meta-ne$null){
            $t="<p>"+$theme.meta.name+" v"+$theme.meta.version
        } else {
            $t="<p>"+(ls $env:posh_theme).basename
        }

        $f[$i++]+=$pad+$tred+"theme$gray`: $t"
    }
}
$pad=''

$t=$f.color()
$sw.stop()
$i++
$t[$i++]+=($tred+"time$gray`: $($sw.elapsed.totalmilliseconds)").color() #= time:


#$t # % display

#$t>teifetchdump.ascii


#$sw.stop()
#$start.elapsed.totalmilliseconds-$sw.elapsed.totalmilliseconds
#$sw.elapsed.totalmilliseconds



#$os|select *

#$cs.totalphysicalmemory

#$apm=(Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
#$apm=(get-counter '\memory\available mbytes').countersamples.cookdvalue

<#
"<red>test".color().length
"test".length
"<red>test".color().lengthc()
#>



#"username <p>$env:username<white>\n".color()



#w('<gray>Press Enter to continue...:\n');[void](read-host);


$mu.dispose();cd([environment]::currentdirectory=$headers.rd);
return $t
