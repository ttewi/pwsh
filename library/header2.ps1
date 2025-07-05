#& header
    $headers=@{}

    #$headers.extracolors=$true #?? enable extra colors with "string".color() and w() sry

    $headers.colors=@{}



    $headers.rd=$pwd

    function eo($o){
        $t=@{membertype='scriptmethod';force=$null;membername=$o[1];value=$o[2]};
        $o[0]|update-typedata @t
    }

    eo('string','pastelize',{param($s,$alt,[bool]$out)
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

        #write-host $hash

        $u=hslc(@(
            $math::floor((($hash/62)*2859)%360);
            (0.85+(1.0-0.85)*($math::floor((($hash/11)*504)%101)/100));
            (0.7+(0.9-0.7)*($math::floor((($hash/19)*634)%101)/100))
        ))

        if($alt-eq$null){$alt=0}
        if($out-eq$null){$alt=$false}

        $e=[char]27

        if($out){
            return "#"+$u[0].tostring('x2')+$u[1].tostring('x2')+$u[2].tostring('x2')
        }else {
            return "$e[$(38+$alt);2;$($u[0]);$($u[1]);$($u[2])m$this$e[39m"
        }

        #return $this.color("<$(hslh($f))>")
        #return "$e[$(38+$alt);2;$($u[0]);$($u[1]);$($u[2])m$this$e[39m"
        #return hslh($f)
    })

    eo('string','color_old',{param($s)
        $e=[char]27;
        $s+=$this;
        <#
        $d=@{black='#1e1e1e';darkblue='#0037da';darkgreen='#13a10e';darkcyan='#3a96dd';darkred='#c50f1f';darkmagenta='#800080';darkyellow='#cc7703';
        gray='#cdd6f4';darkgray='#767676';blue='#3b78ff';green='#16c60c';cyan='#61d6d6';red='#e74856';magenta='#b4009e';yellow='#f9f1a5';white='#eeedf0';
        reset="$e[0m";};
        #>
        #$d=$headers.colors

        $d=@{darkmagenta='#800080';midnightblue='#191970';violet='#ee82ee';papayawhip='#ffefd5';mediumslateblue='#7b68ee';
            mediumturquoise='#48d1cc';springgreen='#00ff7f';saddlebrown='#8b4513';sienna='#a0522d';lightpink='#ffb6c1';
            darkseagreen='#8fbc8b';gray='#cdd6f4';darksalmon='#e9967a';blueviolet='#8a2be2';lightsteelblue='#b0c4de';
            cyan='#61d6d6';wheat='#f5deb3';indigo='#4b0082';darkgoldenrod='#b8860b';rosybrown='#bc8f8f';darkred='#c50f1f';
            antiquewhite='#faebd7';lightslategray='#778899';mediumaquamarine='#66cdaa';dodgerblue='#1e90ff';linen='#faf0e6';
            seashell='#fff5ee';lemonchiffon='#fffacd';aliceblue='#f0f8ff';lightskyblue='#87cefa';lightyellow='#ffffe0';
            magenta='#b4009e';palegreen='#98fb98';powderblue='#b0e0e6';white='#eeedf0';blue='#3b78ff';dimred='#cd5c5c';
            bisque='#ffe4c4';lightgray='#d3d3d3';limegreen='#32cd32';deepskyblue='#00bfff';orange='#ffa500';lavender='#e6e6fa';
            darkslateblue='#483d8b';mediumpurple='#9370db';lavenderblush='#fff0f5';lightsalmon='#ffa07a';lime='#00ff00';
            navy='#000080';mistyrose='#ffe4e1';seagreen='#2e8b57';royalblue='#4169e1';red='#e74856';greenyellow='#adff2f';
            brown='#a52a2a';lightcyan='#e0ffff';palevioletred='#db7093';chocolate='#d2691e';salmon='#fa8072';cornsilk='#fff8dc';
            aqua='#00ffff';darkorchid='#9932cc';honeydew='#f0fff0';green='#16c60c';oldlace='#fdf5e6';olive='#808000';
            snow='#fffafa';mediumorchid='#ba55d3';darkkhaki='#bdb76b';beige='#f5f5dc';pink='#ffa0d2';black='#1e1e1e';
            deeppink='#ff1493';mediumblue='#0000cd';lawngreen='#7cfc00';cadetblue='#5f9ea0';gold='#ffd700';skyblue='#87ceeb';
            whitesmoke='#f5f5f5';goldenrod='#daa520';bananacream='#fee5bc';;lightgreen='#90ee90';palegoldenrod='#eee8aa';
            yellowgreen='#9acd32';darkgreen='#13a10e';lightcoral='#f08080';darkcyan='#3a96dd';darkturquoise='#00ced1';
            burlywood='#deb887';forestgreen='#228b22';crimson='#dc143c';lightseagreen='#20b2aa';chartreuse='#7fff00';
            lightblue='#add8e6';peachpuff='#ffdab9';blanchedalmond='#ffebcd';slategray='#708090';ghostwhite='#f8f8ff';
            firebrick='#b22222';dimgray='#696969';orangered='#ff4500';yellow='#f9f1a5';purple='#800080';tan='#d2b48c';
            khaki='#f0e68c';turquoise='#40e0d0';plum='#dda0dd';olivedrab='#6b8e23';tomato='#ff6347';darkyellow='#cc7703';
            cornflowerblue='#6495ed';mediumvioletred='#c71585';darkviolet='#9400d3';steelblue='#4682b4';peru='#cd853f';
            mediumseagreen='#3cb371';floralwhite='#fffaf0';silver='#c0c0c0';ivory='#fffff0';mediumspringgreen='#00fa9a';
            mintcream='#f5fffa';slateblue='#6a5acd';darkgray='#767676';thistle='#d8bfd8';lightgoldenrodyellow='#fafad2';
            gainsboro='#dcdcdc';darkslategray='#2f4f4f';darkorange='#ff8c00';teal='#008080';darkolivegreen='#556b2f';
            maroon='#800000';orchid='#da70d6';darkblue='#0037da';hotpink='#ff69b4';sandybrown='#f4a460';azure='#f0ffff';
            paleturquoise='#afeeee';moccasin='#ffe4b5';fuchsia='#ff00ff';coral='#ff7f50';reset='[0m'}
        
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

    eo('string','color',{param($s)
        $e=[char]27;
        $s+=$this;
        <#
        $d=@{black='#1e1e1e';darkblue='#0037da';darkgreen='#13a10e';darkcyan='#3a96dd';darkred='#c50f1f';darkmagenta='#800080';darkyellow='#cc7703';
        gray='#cdd6f4';darkgray='#767676';blue='#3b78ff';green='#16c60c';cyan='#61d6d6';red='#e74856';magenta='#b4009e';yellow='#f9f1a5';white='#eeedf0';
        reset="$e[0m";};
        #>
        #$d=$headers.colors

        $d=@{darkmagenta='#800080';midnightblue='#191970';violet='#ee82ee';papayawhip='#ffefd5';mediumslateblue='#7b68ee';
            mediumturquoise='#48d1cc';springgreen='#00ff7f';saddlebrown='#8b4513';sienna='#a0522d';lightpink='#ffb6c1';
            darkseagreen='#8fbc8b';gray='#cdd6f4';darksalmon='#e9967a';blueviolet='#8a2be2';lightsteelblue='#b0c4de';
            cyan='#61d6d6';wheat='#f5deb3';indigo='#4b0082';darkgoldenrod='#b8860b';rosybrown='#bc8f8f';darkred='#c50f1f';
            antiquewhite='#faebd7';lightslategray='#778899';mediumaquamarine='#66cdaa';dodgerblue='#1e90ff';linen='#faf0e6';
            seashell='#fff5ee';lemonchiffon='#fffacd';aliceblue='#f0f8ff';lightskyblue='#87cefa';lightyellow='#ffffe0';
            magenta='#b4009e';palegreen='#98fb98';powderblue='#b0e0e6';white='#eeedf0';blue='#3b78ff';dimred='#cd5c5c';
            bisque='#ffe4c4';lightgray='#d3d3d3';limegreen='#32cd32';deepskyblue='#00bfff';orange='#ffa500';lavender='#e6e6fa';
            darkslateblue='#483d8b';mediumpurple='#9370db';lavenderblush='#fff0f5';lightsalmon='#ffa07a';lime='#00ff00';
            navy='#000080';mistyrose='#ffe4e1';seagreen='#2e8b57';royalblue='#4169e1';red='#e74856';greenyellow='#adff2f';
            brown='#a52a2a';lightcyan='#e0ffff';palevioletred='#db7093';chocolate='#d2691e';salmon='#fa8072';cornsilk='#fff8dc';
            aqua='#00ffff';darkorchid='#9932cc';honeydew='#f0fff0';green='#16c60c';oldlace='#fdf5e6';olive='#808000';
            snow='#fffafa';mediumorchid='#ba55d3';darkkhaki='#bdb76b';beige='#f5f5dc';pink='#ffa0d2';black='#1e1e1e';
            deeppink='#ff1493';mediumblue='#0000cd';lawngreen='#7cfc00';cadetblue='#5f9ea0';gold='#ffd700';skyblue='#87ceeb';
            whitesmoke='#f5f5f5';goldenrod='#daa520';bananacream='#fee5bc';;lightgreen='#90ee90';palegoldenrod='#eee8aa';
            yellowgreen='#9acd32';darkgreen='#13a10e';lightcoral='#f08080';darkcyan='#3a96dd';darkturquoise='#00ced1';
            burlywood='#deb887';forestgreen='#228b22';crimson='#dc143c';lightseagreen='#20b2aa';chartreuse='#7fff00';
            lightblue='#add8e6';peachpuff='#ffdab9';blanchedalmond='#ffebcd';slategray='#708090';ghostwhite='#f8f8ff';
            firebrick='#b22222';dimgray='#696969';orangered='#ff4500';yellow='#f9f1a5';purple='#800080';tan='#d2b48c';
            khaki='#f0e68c';turquoise='#40e0d0';plum='#dda0dd';olivedrab='#6b8e23';tomato='#ff6347';darkyellow='#cc7703';
            cornflowerblue='#6495ed';mediumvioletred='#c71585';darkviolet='#9400d3';steelblue='#4682b4';peru='#cd853f';
            mediumseagreen='#3cb371';floralwhite='#fffaf0';silver='#c0c0c0';ivory='#fffff0';mediumspringgreen='#00fa9a';
            mintcream='#f5fffa';slateblue='#6a5acd';darkgray='#767676';thistle='#d8bfd8';lightgoldenrodyellow='#fafad2';
            gainsboro='#dcdcdc';darkslategray='#2f4f4f';darkorange='#ff8c00';teal='#008080';darkolivegreen='#556b2f';
            maroon='#800000';orchid='#da70d6';darkblue='#0037da';hotpink='#ff69b4';sandybrown='#f4a460';azure='#f0ffff';
            paleturquoise='#afeeee';moccasin='#ffe4b5';fuchsia='#ff00ff';coral='#ff7f50'} # reset='[0m'

        if ($headers.colors-ne$null){$d+=$headers.colors}
        
        $z='(?<!\\)';$g=[regex]"(.+?)\s*($z\,\s*|$)";$v="$z\\(<|>|\\)"
        $t=([regex]"(?s)(?:$z<\s*(.+?)\s*>|^)?(.*?\n*)(?=$z<|$)").matches(($s-replace"$z\\n",("`n")))
        foreach($h in $t.getenumerator()){
            $l=$h.groups[2].value-replace"$v",'$1';$r=$g.matches($h.groups[1].value);$q=@();
            foreach($y in $r.getenumerator()){$q+=$y.groups[1].value-replace"$v",'$1'}
            if($q.length-eq0){$q+=''};$c,[array]$q=$q;if(!$q){$q=@()}

            $alt=0

            if($c[0]-eq'!'){
                $alt+=10
                $tt=$c.length
                $c=$c[1..$tt]-join''
            }

            if($d[$c]){$c=$d[$c]};

            if(($c[0]-eq'#')-and($q.length-eq0)){
                #$k=38;$p=37;if($c[7]-eq'!'){$k=47;$p=40}
                $u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[byte]"0x$r"};
                $l="$e[$(38+$alt);2;$($u[0]);$($u[1]);$($u[2])m$l"
            }else{
                switch -regex ($c){
                    default {$l=$c+$l}
                    "^p$" {$l=$l.pastelize($q[0],$alt)}
                    "^#" {}
                    "^(ra|resetall)" {$l="$e[39;49m"+$l}
                    "^(r|reset)" {$l="$e[$(39+$alt)m"+$l}
                }
            };
            $f+=$l
        }
        $f+="$e[39;49m"
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

    function rvpar($s){if(!($s-is[array])){$s=@($s,$null)}
        $t=$pwd.path
        if(!$s[1]){$s[1]=$t}
        cd $s[1]
        $f=$s[0]|rvpa -relative
        cd $t
        return $f-replace'^.{2}',''
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
            <#
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
            #>
            $f=@{}
            foreach($h in ($s|convertfrom-json).psobject.properties){
                $a=$h.name;$b=$h.value;
                $f[$a]=$b
            }

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
            return ($this.format(($o|convertto-json -depth 8)))
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

#+@

# iex((curl.exe -s "https://raw.githubusercontent.com/ttewi/pwsh/refs/heads/main/library/header.ps1")-join"`n")

#(rvpar("$env:userprofile\appdata\locallow\pugstorm\core keeper","$env:userprofile"))-split'(?<!\\)\\'

class pcd {
    [management.automation.invocationinfo]$mi

    pcd($mi){
        $this.mi=$mi
    }

    [text.regularexpressions.matchcollection]gpd($s){
        $k='\u3066pd'
        $r1=([regex]("(?s)\<#"+"#"+"~\|?\@?($k).+?\1#"+"\>"))

        return $r1.matches($s)
    }

    [hashtable]pull(){
        $json=[json]::new()

        $s=$this.mi.mycommand.scriptblock-join''
        $k='\u3066pd'
        $f=@{}
        foreach($h in $this.gpd($s)){
            $p=$h.index;$l=$h.length;$q=$h.value;
            
            $r1=([regex]("(\<#)?\s*?#"+"~\|?\@?($k)?(.*?)(\r?\n|$k#"+"\>)"))
            $t=''
            foreach($u in $r1.matches($q)){$t+=$u.groups[3].value}
            $t=$json.parse($t)
            $t.p=$p;$t.l=$l;

            $tt=$t.id
            $id=0
            if(!([int]::tryparse($tt,[ref]$id))){$id=$tt}
            $f[$id]=$t
        }
        return $f
    }

    [void]write($o){
        $json=[json]::new()
        $io=[io.file]
        $utf8=[System.Text.Encoding]::UTF8

        $m=$this.mi
        #$g=$m.mycommand.path
        $g=$pscommandpath
        if(!$g){return}

        $s=$m.mycommand.scriptblock-join''
        if($s-match'\r\n'){$c="`r`n"}else{$c="`n"}
        $q=$this.pull()

        $id=$o.id
        if($id-eq$null){$o.id=$id=[int]$q.length}

        $t=$q[$id]
        $h=$s.length

        $f=''

        if($t){
            $p=$t.p;$l=$t.l
        }else{
            $f+="$c"
            $p=$h;$l=0;
        }
        $t=$null

        #$f+="@data@"

        $d=$o|convertto-json -depth 100 -compress
        $k=[char]0x3066+'pd'

        $t="#"+"~@$k$d"

        $a=@();$m=128
        foreach($b in ([regex]"^.{1,$m}|.{1,$($m-1)}").matches($t)){
            $a+=$b.value
        }

        $p2=$a.length-1
        $l2=$a[$p2].length+3
        $u=($k-replace'[^a-~]','!!').length
        if(($l2+$u)-gt$m){$p2++;$a+=''}
        $a[$p2]+="$k#`>"
        $t="<#"+($a-join"$c #"+"~|")

        $f+=$t


        $u=""+((($s[0..($p-1)]-join'')+$f+($s[($p+$l)..$h]-join''))-replace'\r?\n$','')+""

        #write-host $u

        #$this.mi

        #sc $g $u
        $io::writealllines($g,$u,$utf8)


        return
    }
}
$pcd=[pcd]::new($myinvocation)

#$c=(gc "~\desktop\pwsh\teic.ascii")-join"`n"
#$c="$(gc '.\teic.txt')"
#$c

<#
$t=@{
    id=0;
    data=@{
        teic=$c; # (gc "~\desktop\pwsh\teic.ascii")
        #teic='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    }
}
#>

#! pcd.pull()[0].data.teic
#$pd=$pcd.pull()[0]
#$pd.data.teic

#$pd.data.teic=$c
#$pcd.write($t)

#$l='hkcu:\software\microsoft\windows\currentversion\explorer\advanced'
#$explorer=(gp $l)
#$explorer.taskbaracrylicopacity

#(sp $l 'taskbaracrylicopacity' 0)

#+@ sp 'hkcu:\software\microsoft\windows\currentversion\explorer\advanced' 'taskbaracrylicopacity' 0;stop-process -n 'explorer';

<#
class pm {
    $cs

    pm(){
        $this.cs=[console]
    }

    [void]set([array]$p){
        $c=$this.cs
        $c::setcursorposition($p[0],$p[1])
        return
    }

    [array]get(){
        $c=$this.cs
        #$t=$c::getcursorposition()
        #return @($t.left,$t.top)
        return @($c::cursorleft,$c::cursortop)
    }
}

$pm=[pm]::new()

echo "1a"
echo "2a"

$pm.set(@(0,0))
w("<pink>test\n")

$pm.set(@(0,5))

$e=[char]27
#w("$e[2m")

$t=$pm.get()

$pm.set(@(1,0))
w("<white>e")
$pm.set($t)


$pm.get()

#$myinvocation.mycommand|select *
#>



#"\n  <!#c9a0dc><white>test :3<ra>\n".color()

#"\n  <!lightskyblue><white> $n <ra>\n".color()

<#
$e=[char]27
"\n  <!p,bwaa> $env:username <ra>\n".color()

w(" test\n test")
# $e[D   $e[2K
w("$e[F$e[E$e[J<bananacream>*test")

w("\n\n")
#>

class pm {
    $cs

    pm(){
        $this.cs=[console]
    }

    [void]set([array]$p){
        $c=$this.cs
        $c::setcursorposition($p[0],$p[1])
        return
    }

    [array]get(){
        $c=$this.cs
        #$t=$c::getcursorposition()
        #return @($t.left,$t.top)
        return @($c::cursorleft,$c::cursortop)
    }
}
$pm=[pm]::new()

#pause #-@ pause

$selection=@(
    @{name="a";value="1 :3"};
    @{name="b";value="2 :3"};
    @{name="c";value="3 :3"};
    @{name="d";value="4 :3"};
    @{name="e";value="5 :3"};
    @{name="f";value="6 :3"};
    @{name="g";value="7 :3"};
    @{name="h";value="8 :3"};
    @{name="i";value="9 :3"};
    @{name="j";value="10 :3"};
    @{name="k";value="11 :3"};
    @{name="l";value="12 :3"};
    
)


$headers.colors+=@{
    tgray="#3c3c3c";
    tdimgray="#616161";
    tlightgray="#979797";
    wisteria="#c9a0dc"
}

$e=[char]27
$math=[math]

$selected=1
$maxselection=8
$boundaries=@(1,$maxselection)

$page=1
$selectioncount=$selection.count
#$maxpages=[int]$math::ceiling($selection.count/$maxselection)
#$maxpages

$maxpages=0
$pages=@()

$t=$maxselection-1
for($i=0;$i-lt$selectioncount;$i+=8){
    $maxpages++

    $pages+=,$selection[$i..$t]
}

#$maxpages

#$json.stringify($pages)

#$pages[0].length #?? max (12%8)


#$f=[array]::new(14)
$buffer=" "*2
$f=""

$header=@"

$buffer<!#aa72f4> Select **** <ra>


"@

$footer=@"

$buffer <tlightgray>•<tgray>$("•"*($maxpages-1))<r>
$buffer <tdimgray>↑ <tgray>up • <tdimgray>↓ <tgray>down • <tdimgray>q <tgray>quit


"@


$currentpage=$pages[0]
foreach($h in $currentpage){
    $f+="$buffer "+$h.name+"\n"
}

$placeholder="\n"*$maxselection



$t=$pm.get()
$target=@(0;4)

$origin=@($t[0]+$target[0];$t[1]+$target[1])

($header+$placeholder+$footer).color() # ** display
$after=$pm.get()

#$origin
#$after

w("$e[$($origin[1]);$($origin[0])f$e[s$f")


#w("$e[u$e[K$buffer<wisteria>•"+$currentpage[$selected-1].name)
w("$e[$($origin[1]+1);$($origin[0])f$e[K$buffer<wisteria>•"+$currentpage[$selected-0].name)

w("$e[$($after[1]);$($after[0])f")



#"".pastelize("bwaa",$null,$true)


#$headers.colors.wisteria='#c9a0dc'
#"<wisteria>test".color()

#pause
#w('<gray>Press Enter to continue...:\n');[void](read-host);

$mu.dispose();cd([environment]::currentdirectory=$headers.rd);
return '<#76e7f4>*'.color()

<##~@てpd{"id":0,"data":{"teic":"                        \u001b[38;2;3;3;3m@@@@@@\u001b[37m\u001b[38;2;238;237;240m                
 #~|        \n                  \u001b[37m\u001b[38;2;3;3;3m@@@\u001b[37m\u001b[38;2;54;54;54m%%%%%%%%%%%%\u001b[37m\u001b[38;2;3;3
 #~|;3m@@@\u001b[37m\u001b[38;2;238;237;240m                  \n              \u001b[37m\u001b[38;2;3;3;3m@@@\u001b[37m\u001b[38;2;
 #~|54;54;54m%\u001b[37m\u001b[38;2;92;95;102m##################\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;3;3;3m@@@\u00
 #~|1b[37m\u001b[38;2;238;237;240m              \n            \u001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u001b[38;2;54;54;54m%\u001b[
 #~|37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;238;237;240m%\u001b[37m\u001b[38;2;75;77;83m+\u0
 #~|01b[37m\u001b[38;2;92;95;102m################\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;238;237;240m%\u001b[37m\u001
 #~|b[38;2;255;255;255m;\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u0
 #~|01b[38;2;238;237;240m            \n           \u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;
 #~|2;75;77;83m+\u001b[37m\u001b[38;2;238;237;240m%%%\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;92;95;102m##############
 #~|####\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;238;237;240m%%%\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;
 #~|54;54;54m%\u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38;2;238;237;240m           \n          \u001b[37m\u001b[38;2;3;3;3m@\u
 #~|001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;238;237;240m%%%%%\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;92;9
 #~|5;102m##################\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;238;237;240m%%%%%\u001b[37m\u001b[38;2;92;95;102m
 #~|#\u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38;2;238;237;240m          \n        \u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u00
 #~|1b[38;2;92;95;102m#\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;238;237;240m%%%%%%\u001b[37m\u001b[38;2;70;73;79m=\u00
 #~|1b[37m\u001b[38;2;92;95;102m##################\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;238;237;240m%%%%%%\u001b[37
 #~|m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38;2;238;237;240m        \
 #~|n       \u001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;238;237;240m%%%%%%%\u001b[37m\u001b
 #~|[38;2;75;77;83m+\u001b[37m\u001b[38;2;92;95;102m##################\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;238;237
 #~|;240m%%%%%%%\u001b[37m\u001b[38;2;255;255;255m;\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38
 #~|;2;238;237;240m       \n      \u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;76;78;83m-\u00
 #~|1b[37m\u001b[38;2;238;237;240m%%%%%%%\u001b[37m\u001b[38;2;255;255;255m;\u001b[37m\u001b[38;2;92;95;102m####################\u0
 #~|01b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;3;
 #~|3;3m@\u001b[37m\u001b[38;2;238;237;240m      \n     \u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u00
 #~|1b[38;2;255;255;255m;\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;92;95;102m
 #~|####################\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%\u001b[37m\u001b[38;2;255;255;255
 #~|m;\u001b[37m\u001b[38;2;92;95;102m#\u001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38;2;238;237;240m     \n   \u001b[37m\u001b[38
 #~|;2;3;3;3m@@\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;255;255;255m;\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%\u001b[
 #~|37m\u001b[38;2;255;255;255m;\u001b[37m\u001b[38;2;92;95;102m#####\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;92;95;10
 #~|2m##########\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;92;95;102m#\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[3
 #~|8;2;92;95;102m###\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%%\u001b[37m\u001b[38;2;92;95;102m#\u
 #~|001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u001b[38;2;238;237;240m   \n \u001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u001b[38;2;92;95;1
 #~|02m#\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%%\u001b[37m\u001b[38;2;255;255;255m;\u001b[37m\u0
 #~|01b[38;2;67;69;75m*\u001b[37m\u001b[38;2;92;95;102m###\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;92;95;102m#\u001b[3
 #~|7m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;92;95;102m#\u001b[37m\u001b[38;2;75;77;83m++\u001
 #~|b[37m\u001b[38;2;92;95;102m#####\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;75;77;83m++\u001b[37m\u001b[38;2;248;234;
 #~|223m%\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;92;95;102m#\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;92;
 #~|95;102m#\u001b[37m\u001b[38;2;255;255;255m;\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%%\u001b[37m\u001b[38;2;255;255;255m;\u001b
 #~|[37m\u001b[38;2;92;95;102m#\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u001b[38;2;238;237;240m\n\u
 #~|001b[37m\u001b[38;2;3;3;3m@\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%%%%\u001b[37m\u001b[38;2;2
 #~|55;255;255m;\u001b[37m\u001b[38;2;92;95;102m#####\u001b[37m\u001b[38;2;248;234;223m%\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\
 #~|u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;248;234;223m%%\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;248;234;223m%\u0
 #~|01b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;92;95;102m#\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;248;234;223
 #~|m%%%%%%\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;248;234;223m%\u001b[37m\u001b[38;2;92;95;102m###\u001b[37m\u001b[3
 #~|8;2;76;78;83m-\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%%%%\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;3;3;3m@\u001b[
 #~|37m\u001b[38;2;238;237;240m\n\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;238;237;240m%%%%%%%%%\u001b[37m\u001b[38;2;7
 #~|6;78;83m-\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;92;95;102m####\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[3
 #~|8;2;92;95;102m#\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;54;54;54m%%%%%\u001b[37m\u001b[38;2;248;234;223m%%\u001b[3
 #~|7m\u001b[38;2;76;78;83m--\u001b[37m\u001b[38;2;248;234;223m%%\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;54;54;54m%%%
 #~|%%\u001b[37m\u001b[38;2;92;95;102m######\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;2
 #~|38;237;240m%%%%%%%%%\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;238;237;240m\n\u001b[37m\u001b[38;2;3;3;3m@@\u001b[37
 #~|m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;75;77;83m++\u001b[37m\u001b[38;2;67;69;75m*\u001b[
 #~|37m\u001b[38;2;92;95;102m###########\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;76;78;83m-----\u001b[37m\u001b[38;2;2
 #~|48;234;223m%%%%%%\u001b[37m\u001b[38;2;76;78;83m-----\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;92;95;102m######\u00
 #~|1b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;92;95;102m##\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;92;95;102m#
 #~|#\u001b[37m\u001b[38;2;75;77;83m++\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;92;95;102m#\u001b[37m\u001b[38;2;3;3;3m
 #~|@@\u001b[37m\u001b[38;2;238;237;240m\n   \u001b[37m\u001b[38;2;3;3;3m@@@@@\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2
 #~|;92;95;102m#########\u001b[37m\u001b[38;2;67;69;75m*\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;248;234;223m%%%%%%%%%
 #~|%%%%%\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;92;95;102m##########\u001b[37m\u001b
 #~|[38;2;3;3;3m@@@@@@\u001b[37m\u001b[38;2;238;237;240m  \n       \u001b[37m\u001b[38;2;3;3;3m@@@@\u001b[37m\u001b[38;2;54;54;54m%
 #~|\u001b[37m\u001b[38;2;92;95;102m#######\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;70;73;79m=\u001b[37m\u001b[38;2;24
 #~|8;234;223m%%%%%%%%%%%%%\u001b[37m\u001b[38;2;76;78;83m-\u001b[37m\u001b[38;2;92;95;102m########\u001b[37m\u001b[38;2;54;54;54m%
 #~|\u001b[37m\u001b[38;2;3;3;3m@@@@\u001b[37m\u001b[38;2;238;237;240m      \n           \u001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u
 #~|001b[38;2;54;54;54m%%%%%%\u001b[37m\u001b[38;2;3;3;3m@@@\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;67;69;75m*\u001b[
 #~|37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;70;73;79m=====\u001b[37m\u001b[38;2;75;77;83m+\u001b[37m\u001b[38;2;67;69;75m*\u
 #~|001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u001b[38;2;54;54;54m%\u001b[37m\u001b[38;2;3;3;3m@@@\u00
 #~|1b[37m\u001b[38;2;92;95;102m#\u001b[37m\u001b[38;2;54;54;54m%%\u001b[37m\u001b[38;2;3;3;3m@@\u001b[37m\u001b[38;2;238;237;240m 
 #~|         \n             \u001b[37m\u001b[38;2;3;3;3m@@@\u001b[37m\u001b[38;2;238;237;240m \u001b[37m\u001b[38;2;3;3;3m@@@\u001b
 #~|[37m\u001b[38;2;238;237;240m    \u001b[37m\u001b[38;2;3;3;3m@@@@@@@\u001b[37m\u001b[38;2;238;237;240m    \u001b[37m\u001b[38;2;
 #~|3;3;3m@@\u001b[37m\u001b[38;2;238;237;240m \u001b[37m\u001b[38;2;3;3;3m@@@\u001b[37m\u001b[38;2;238;237;240m             \u001b
 #~|[37m"}}てpd#>
