#& header

    $rd=$pwd

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

        [hashtable]parsec($s){
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



#%% file data initalize
    $tpath="$env:programfiles (x86)\steam\steamapps\common\tmodloader" 

    $pd=$pwd.path

    $tdl="$env:userprofile\documents\my games\terraria\tModLoader" #& \tModLoader
    cd $tdl
    $favorites=$json.parse((gc -raw '.\favorites.json'))
    $config=$json.parse((gc -raw ".\config.json"))

    $tmlp=@{
        #meta='"'+$tpath+'\dotnet\dotnet" "'+$tpath+'\tModLoader.dll" '
        #meta=@("$tpath","dotnet\dotnet","tModLoader.dll")
        meta=@{path=$tpath}
        config='.\serverconfig.txt';
        players='16';
        port='7777';
        #pass=''
        
    }

    function pca($o){
        $k=$o.clone()
        $f=@()
        $k.remove('meta')
        foreach($h in $k.getenumerator()){
            $a=$h.name;$b=$h.value;
            $f+="-$a"
            #if(!$b){$f+=$b}
            $f+=$b
        }
        #$f+='"'
        return $f
    }


    $worldsizes=@{
        ('4200')='small';
        ('6400')='medium';
        ('8400')='large'
    }
    $gamemodes=@{
        ('2')='master';
        # idk if these are right srry
        ('1')='expert';
        ('0')='normal';

        ('3')='journey'
    }

    $f=@()
    (ls ".\worlds" -recurse -file)|%{
        $ignored=$false
        $name=$_.name
        $basename=$_.basename
        $directory=$_.directory
        $extension=$_.extension
        

        if(($extension -ne '.wld')){return}
        
        $t="$directory\$name"

        #echo ($_|select *)
        #pause


        $d=((($directory|rvpa -relative)-replace'^.{2}','')-split'(?<!\\)\\')


        $prefix=$null
        $tt=([regex]'^\s*([^A-z0-9])').matches($name)
        if($tt.length){$prefix=$tt[0].groups[1].value}


        $f+=@{
            file=$t;
            name=$name;
            basename=$basename;
            extension=$extension;
            prefix=$prefix;
            path="$($directory)";
            dirs=$d;
            flags=@()
        }

    }
    cd $pd

#% prefix handler
    foreach($h in $f){
        if (!$t){
            if($h.prefix-eq'!'){
                $h.flags+=$t='ignored'
            }
        }
        if (!$t){
            foreach($k in $h.dirs){
                if ("$($k[0])" -match '^\s*\!'){
                    $h.flags+=$t='ignored'
                }
            }
        }
        $t=$null

        <#
        if ($h.prefix-eq'-'){
            $h.basename=$h.basename-replace'^\s*.(.+)','*$1'
        }
        #>

        #$h.flags+='bleh'
        
    }

#w('\n<#ffa0d2>---\n\n')

#= (binaryreader).readbytes(l);
eo('io.binaryreader','readbytes',{param($c)
    $f=@()

    for ($i=0;$i -lt $c;$i++){
        $f+=$this.readbyte();
    }

    return $f
})

#w('<yellow>*\n')

#% wld consise parser
    $meta=@{l=0}
    foreach($h in $f){
        $s=[io.binaryreader]::new([io.file]::openread($h.file))



        #$w.fileformatheader
        #w('<cyan>---\n')
        #$w.header

        <#
            $h.data=@{
                version=$w.fileformatheader.version;
                favorite=$w.fileformatheader.favorite;

                name=$w.header.name;
                seed=$w.header.seed;
                eviltype=$w.header.eviltype;
                size=$w.header.size;
                gamemode=$w.header.gamemode;
                uuid=$w.header.uuid;
                id=$w.header.id;
                moodtype=$w.header.moontype;
                altarcount=$w.header.altarcount;
                hardmode=$w.header.hardmode;
                hmores=$w.header.hmores;


            }
        #>

        #$h.data


        $t=$h.data=@{}

        $version=$t.version=$s.readint32();
        $t.favorite=$favorites.world[$h.name];
        [void] $s.readbytes(20) #? skip
        [void] $s.readbytes($s.readint16()*4) #? skip
        [void] $s.readbytes($s.readint16()/8) #? skip

        $t.name=$s.readstring(); #$t.name=if(($tt=$s.readstring())-match'[\-]'){}
        $t.seed=$s.readstring();
        [void] $s.readbytes(8) #? skip
        $t.uuid=-join $s.readbytes(16).foreach('tostring','x2')
        $t.id=$s.readint32();
        [void] $s.readbytes(16) #? skip
        #$t.height=$s.readint32();
        #$t.width=$s.readint32();
        [void] $s.readbytes(4);
        $t.size=$worldsizes["$($s.readint32())"];if(!$t.size){$t.size='unknown'};

        if($version-ge255){
            $t.gamemode=$gamemodes["$($s.readint32())"];
            #$t.gamemode=$s.readint32();

            $k=$t.worldflags=@{}
            #$k.drunk=$s.readboolean();
            if($tt=$s.readboolean()){$k+='drunk'}

            if($version-ge267){
                <#
                    $k.good=$s.readboolean();
                    $k.celebrationmk10=$s.readboolean();
                    $k.constant=$s.readboolean();
                    $k.notthebees=$s.readboolean();
                    $k.remix=$s.readboolean();
                    $k.notraps=$s.readboolean();
                    $k.zenith=$s.readboolean();
                #>
                if($tt=$s.readboolean()){$k+='good'};
                if($tt=$s.readboolean()){$k+='celebrationmk10'};
                if($tt=$s.readboolean()){$k+='constant'};
                if($tt=$s.readboolean()){$k+='notthebees'};
                if($tt=$s.readboolean()){$k+='remix'};
                if($tt=$s.readboolean()){$k+='notraps'};
                if($tt=$s.readboolean()){$k+='zenith'};
                $tt=$null;
            }
        } else {$t.gamemode=$gamemodes["$($s.readboolean())"];}
        if(!$t.gamemode){$t.gamemode='unknown'}

        [void] $s.readbytes(8) #? skip
        $t.moontype=$s.readbyte();
        [void] $s.readbytes(115) #? skip
        $t.eviltype=if($s.readboolean()){'crimson'}else{'corruption'};
        [void] $s.readbytes(21) #? skip
        $t.altarcount=$s.readint32();
        $t.hardmode=$s.readboolean();
        if($version-ge257){[void] $s.readbytes(1);}
        [void] $s.readbytes(38) #? skip
        $t.hmores=@($s.readint32();$s.readint32();$s.readint32())

        <#
        [void] $s.readbytes(22) #? skip
        for($i=$s.readint32();$i-gt0;$i--){[void] $s.readstring()}; #? angler who finished today
        [void] $s.readbytes(7) #? skip
        if($version-ge225){[void] $s.readbytes(1)};
        [void] $s.readbytes(8) #? skip
        for($i=$s.readint16();$i-gt0;$i--){[void] $s.readint32()}; #? killcount
        [void] $s.readbytes(4) #? skip
        $t.complete=$this.readbooleon();
        #>



        #w('<#ffa0d2>---\n')
        #$h.data

        if(($tt=$t.name.length)-gt$meta.l){$meta.l=$tt}

        $t=$null;$tt=$null
        #$h.t=$h.data.name
        #$h.f=$h.data.favorite


        $s.close() # $s.dispose()
        #break
    }

#echo $f
#$sort=$f|sort-object f

#$json.stringify($f)

#% selection color string
    $utf8=[text.encoding]::utf8
    $e=[char]27
    $wrapperversion='beta1'
    $tversion=$config.lastlaunchedversion
    $version=($tversion).tostring('x4')+'.'+$wrapperversion
    $tmlversion=$config.lastlaunchedtmodloaderversion
    $p="<white>terraria server wrapper <p,$tversion>v$version<white> - tModLoader <p>v$tmlversion<white>\n\n"
    $i=0
    $nb=$meta.l+2
    $b=16
    $ml=$p

    $ws=@{
        small=[char]0xf10c;
        medium=[char]0xf042;
        large=[char]0xf111;

        unknown=[char]0xf29c;
    }

    $gl=@{
        master='#ff6767';
        expert='#fba774';
        normal='gray'
        journey='#ffa0d2'

        unknown='#474747';
    }

    $et=@{
        crimson='#ff8080';
        corruption='#c5b2e5'
    }

    foreach($h in $f){
        if($h.flags.contains('ignored')){continue}
        if($h.data.gamemode-eq'unknown'){continue}


        $i++
        #$b=0xf
        $p+=$i
        $p+=(' '*($b-"$i".length))
        #$p+=$h.data.name+(' '*($tb-$hs.data.name.length))
        $p+="<p,$($h.data.seed)>$($h.data.name)" #$p+=$h.data.name.pastelize($h.data.seed)
        $p+=(' '*($nb-$h.data.name.length))

        $p+=if($h.data.hardmode){"$e[4m"}

        #$p+=if($h.data.eviltype-eq'crimson'){'<#ff8080>'}else{'<#c5b2e5>'}
        $p+="<$($et[$h.data.eviltype])>"
        $p+="$([char]0xe21c)<white>$e[24m "

        $p+="<$($gl[$h.data.gamemode])>"
        $p+="$($ws[$h.data.size])<white> "

        #$p+="$([char]0xf4ee) " #? moontype maybe idk srryy

        $p+=if($h.data.hardmode){"<#a3f0fa>$([char]0xf069)<white> "}


        #if($h.data.favorite){$p+="<#f5e399>$([char]0x2736)<white> "}
        $p+=if($h.data.favorite){"<#f5e399>$([char]0xf51f)<white> "}

        $p+='\n'

        $w=$null
        #break
    }

    $p+="╺$("━"*(58))╸\n"
    $t='b'
    $p+=$t
    $p+=(' '*($b-$t.length))
    $p+='<gray>bypass<white>\n'

#w($p)

for(;;){
    $b=$false
    cls
    w($p)

    w('\nChoose World: ')
    $sl=(read-host)

    switch -regex ($sl) {
        default {}
        '^\s*([0-9]+)\s*$' {
            $wld=$f[[int]$matches[1]-1]
            $b=$true
        }
        '^\s*(b+)\s*$' {

            $b=$true
        }
    }

    if($b){break}

}

w('<#ffa0d2>---\n')


if($wld){
    $tmlp.world=$wld.file
}
$tmlp.nosteam=''

#$tmlp.world=$tdl+'\autocreate_test.wld'
#$tmlp.autocreate=3;
#$tmlp.worldname='autocreate_test'
#$tmlp.seed='sdkfljghfw'





#scfg($sconfig)>$scl
$pd=$pwd.path
$p=$tmlp.meta.path

$q=@("bash","$p\start-tModLoaderServer.sh")


$env:WINDOWS_MAJOR=10
$env:WINDOWS_MINOR=0


for (;;){
    &"$p\launchutils\busybox64.exe" $q (pca($tmlp))
    cd $pd
    if(!$tmlp.world){break}
    #pause
}





#"<p,$env:username>test".color()

#"<#76e7f4>test".color()
#"test".color()


#w("<p>$env:username<white>\n")

<#
$pd=$pwd.path
cd '~\desktop'
(ls '.' -file)|%{ # '.\desktop\powershell'
    $l=$_.length
    $tt=(signature("$($_.directory)\$($_.name)"))
    if($l-eq0){$l="$e[4m$l$e[24m"}
    w("$tt\n")
}
w('\n')
cd $pd
#>






#w('<gray>Press Enter to continue...:\n');[void](read-host);

$m.dispose()
return '<#76e7f4>*'.color()
