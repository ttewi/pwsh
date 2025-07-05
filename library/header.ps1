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

    $e=[char]27

#~/\!#*+-%=&?.


if(!($n=$myinvocation.mycommand.name)){$n='t'};($u=[console])::setwindowsize(($t=120),30);
$u::setbuffersize($t,4096);$u::title=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($mu=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<p,$n>て$n".color()}#*@ >.<


#$u::setbuffersize($t,4096);$u::title=$n;cd($t=$psscriptroot);[void] $ev::currentdirectory=$t;





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

#! $pcd.pull()[0].data.teic
#$pd=$pcd.pull()[0]
#$pd.data.teic

#$pd.data.teic=$c
#$pcd.write($t)

#$l='hkcu:\software\microsoft\windows\currentversion\explorer\advanced'
#$explorer=(gp $l)
#$explorer.taskbaracrylicopacity

#(sp $l 'taskbaracrylicopacity' 0)

#+@ sp 'hkcu:\software\microsoft\windows\currentversion\explorer\advanced' 'taskbaracrylicopacity' 0;stop-process -n 'explorer';


$headers.colors+=@{
    tgray="#515151";
    tdimgray="#727272";
    tlightgray="#979797";
    wisteria="#c9a0dc"
}




class selection {
    $_selection
    $_console
    $_origin
    $_after
    $_buffer
    $_bufferlength
    $_abuffer
    $_headersize
    $_totalfillarea
    $_footerbuffer
    $_version
    $_selectionname

    selection($selection){
        $this._selection=$selection
        $this._console=[console]

        $this._version="ts@"+("0001")
    }

    [array]getpos(){
        $c=$this._console
        return @($c::cursorleft;$c::cursortop)
    }

    [array]getpages($c){
        $f=@()
        $selection=$this._selection
        $selectioncount=$selection.count

        $t=$c-1
        for($i=0;$i-lt$selectioncount;$i+=$c){
            $f+=,$selection[$i..($i+$t)]
        }
        return $f
    }

    [void]fillselection($pages,$page,$maxselection){
        $e=[char]27
        $origin=$this._origin
        $after=$this._after
        $buffer=$this._buffer
        $abuffer=$this._abuffer

        $oy=$origin[1];$ox=$origin[0]
        $ay=$after[1];$ax=$after[0]

        $currentpage=$pages[$page-1]
        $selectionarea=$currentpage.length

        w("$e[$oy;$ox"+"f$e[s") # %% go to origin and save position
        #~ w(("$e[K$e[1B"*$maxselection)+"$e[u") # %% clear lines to use

        $f="$e[B$e[F"
        foreach($h in $currentpage[0..($selectionarea-1)]){
            $f+="$abuffer "+$h.name+"\n"
        }

        w(("$e[K$e[1B"*($maxselection+1))+"$e[u"+$f) # * clear lines to use & fill selection


        w("$e[$ay;$ax"+"f") # %% return to after pointer
        return
    }

    [void]fillfooter($pages,$page,$maxselection){
        $e=[char]27
        $origin=$this._origin
        $after=$this._after
        $buffer=$this._buffer
        $abuffer=$this._abuffer

        $oy=$origin[1];$ox=$origin[0]
        $ay=$after[1];$ax=$after[0]

        $headersize=$this._headersize
        $footerbuffer=$this._footerbuffer
        $totalfillarea=$this._totalfillarea

        $currentpage=$pages[$page-1]
        $selectionarea=$currentpage.length
        $maxpages=$pages.length

        $totalspace=$headersize+$totalfillarea+1+$footerbuffer
        $usedspace=$headersize+$maxselection+1

        $space=$totalspace-$usedspace


        $pageindicator="$e[B$e[F$abuffer <tgray>$("•"*($page-1))<tlightgray>•<tgray>$("•"*($maxpages-$page))<r>\n"
        $consisefooter="$abuffer <tdimgray>↑\l <tgray>up • <tdimgray>↓\. <tgray>down • <tdimgray>q <tgray>quit • <tdimgray>? <tgray>more<r>\n"

        $fullfooter=@(
            #"$abuffer <tdimgray>↑ <tgray>up • <tdimgray>↓ <tgray>down • <tdimgray>q <tgray>quit • <tdimgray>? <tgray>more<r>"
            "$abuffer <tdimgray>↑\l <tgray>up               <tdimgray>q <tgray>quit"
            "$abuffer <tdimgray>↓\. <tgray>down             <tdimgray>? <tgray>close more"
            "$abuffer <tdimgray>←\, <tgray>prev page<r>"
            "$abuffer <tdimgray>→\/ <tgray>next page<r>"
            #~ "$abuffer <tgray>-------------------------------"
            "$abuffer "
            "$abuffer <tdimgray>metadata<tgray> p$maxpages b$($buffer.length) $($this._version) "
        )

        w("$e[$($oy+$maxselection+1);$ox"+"f$e[s") # %% go to footer and save position
        #~ w(("$e[K$e[1B"*$space)+"$e[u") # %% clear lines to use

        $f=$pageindicator
        if($space-eq2){
            $f+=$consisefooter
        } else {
            $f+=$fullfooter[0..($space-2)]-join"`n"
        }

        w(("$e[K$e[1B"*$space)+"$e[u"+$f) # * clear lines to use & fill footer

        w("$e[$oy;$ox"+"f$e[s") # %% restore origin saved position
        w("$e[$ay;$ax"+"f") # %% return to after pointer
        return
    }

    [void]hover($pages,$page,$selected,$movement){
        $e=[char]27
        $math=[math]
        $origin=$this._origin
        $after=$this._after
        $buffer=$this._buffer
        $abuffer=$this._abuffer

        $oy=$origin[1];$ox=$origin[0]
        $ay=$after[1];$ax=$after[0]

        $currentpage=$pages[$page-1]

        $t=$currentpage[$selected-1].name
        #~ w("$e[u$e[K$buffer $t$e[B$e[F") # %% go to saved position, restore, reset position
        
        w("$e[$($oy-1+$selected);$ox"+"f$e[B$e[F") # %% go to origin + selected offset
        if($movement-ne0){
            w("$abuffer$e[K $t$e[B$e[F") # %% restore & reset position

            $direction="B"
            if($movement-lt0){
                $direction="A"
            }

            #~ w(("$e[$direction"*$math::abs($movement))+"$e[s") # %% perform movement and save position
            w(("$e[$direction"*$math::abs($movement))) # %% perform movement
        }
        
        $t=$currentpage[$selected-1+$movement].name
        w("$abuffer$e[K<wisteria>•$t") # %% hover new selected
        

        <#
        $direction="B"
        if($movement-lt0){
            $direction="A"
        }
        $tt=$currentpage[$selected-1+$movement].name

        w("$e[$($oy-1+$selected);$ox"+"f$e[K$buffer $t$e[B$e[F"+("$e[$direction"*$math::abs($movement))+"$e[K$buffer<wisteria>•$tt")
        #>


        w("$e[$ay;$ax"+"f") # %% return to after pointer
        return
    }

    [int]wrap($n,$min,$max){
        $l=$max-$min+1
        $f=($n-$min)%$l
        if($f-lt0){$f+=$l}
        $f+=1
        return $f
    }

    [int]constraint($n,$min,$max){
        $f=$n
        #write-host ("n: $n")
        #write-host ("max: $max")
        if($f-gt$max){$f=$max}
        if($f-lt$min){$f=$min}
        return $f
    }

    [hashtable]start([int]$s){return $this.start("****",$s)}
    [hashtable]start([string]$s){return $this.start($s,8)}
    [hashtable]start(){return $this.start("****",8)}
    [hashtable]start($selectionname,$startsize){
        $e=[char]27;$math=[math];$json=[json]::new();

        $t=$selectionname
        if($t-eq''-or$t-eq$null){$selectionname="****"}
        $this._selectionname=$selectionname

        #* header stuff srry
            $selection=$this._selection

            $selected=1
            #$maxselection=8
            $maxselection=$startsize
            $this._headersize=$headersize=3
            #$boundaries=@(1;$maxselection)

            $page=1
            $selectioncount=$selection.count

            $this._footerbuffer=$footerbuffer=2

        $pages=$this.getpages($maxselection)
        $maxpages=$pages.length

        #w($json.stringify($pages)+"\n")

        $namelengthlimit=22 # * 19
        $r1="(^.{$namelengthlimit})"
        $r2="(^.{$($namelengthlimit-2)}).+"
        foreach($h in $selection){
            if($h.name-match$r1){
                $h.name=$h.name-replace$r2,"`$1<tlightgray>..<r>"
            }
        }

        $currentpos=$this.getpos()

        $this._bufferlength=$bufferlength=2
        $this._buffer=$buffer=" "*($bufferlength+$currentpos[0])
        $this._abuffer=$abuffer="$e[$($buffer.length)C"
        $f=""

        $header="\n$abuffer<!#aa72f4> select $selectionname <ra>\n\n" # +"\n"*$maxselection

        $this._totalfillarea=$totalfillarea=$maxselection
        $totalspace=$headersize+$totalfillarea+1+$footerbuffer

        $f="\n"*($totalspace-$headersize+1) # ?? reserve space


        #$currentpos=$this.getpos()
        <#
        if($currentpos[0]-ne0){ # ?? create newline if there isn't one i think srry
            $header="\n"+$header
            $currentpos=@(0;$currentpos[1]+1)
        }
        #>
        $targetoffset=@(3;$headersize+1)

        w("$e[?25l") # %% hide cursor

        $sizeoffset=0
        $sizeoffset=$currentpos[1]+$totalspace+2-($this._console::windowheight)
        if($sizeoffset-lt0){$sizeoffset=0}

        $this._origin=$origin=@($currentpos[0]+$targetoffset[0];$currentpos[1]+$targetoffset[1]-$sizeoffset) # $sizeoffset
        #w("$currentpos\n")
        #w("$totalspace\n")
        #w("$sizeoffset\n")
        #pause

        w($header+$f) # ** display
        $this._after=$after=$this.getpos()


        #$maxselection=8

        $oldsize=$maxselection
        #$maxselection=$newsize=8
        $maxselection=$newsize=$maxselection

        $selected=1
        
        $pages=$this.getpages($newsize)
        $t=((($page-1)*$oldsize)+$selected)
        $lastpage=$page=$math::ceiling($t/$newsize)
        $selected=$t%$newsize

        $currentpage=$pages[$page-1]
        #write-host $page

        $this.fillselection($pages,$page,$maxselection)
        $this.fillfooter($pages,$page,$maxselection)

        $this.hover($pages,$page,$selected,0)

        $c=[console]


        $out=$null
        for(;;){
            $rawkey=$c::readkey($true)
            $k=$rawkey.key
            $m=$rawkey.modifiers

            $continue=$false
            $quit=$false

            $movement=0
            $choice=$null
            switch -regex ($k){
                default {$continue=$true}
                "^(uparrow|l)$" {$movement-=1}
                "^(downarrow|oemperiod)$" {$movement+=1}

                "^(leftarrow|oemcomma)$" {$page-=1} # * change these to directly change page and contraint selected to new page size
                "^(rightarrow)$" {$page+=1}

                "^(enter)$" {$choice=$selected}

                "^(q)$" {$quit=$true}

                "^(oem2)$" {
                    #$continue=$true
                    if(!($m-match'shift')){
                        #$continue=$true;break
                        $page+=1
                        break
                    }
                    $o=$maxselection
                    $t=$oldsize-5
                    if($t-lt0){$t=$oldsize}
                    if($maxselection-eq$t){
                        $maxselection=$oldsize
                    }else{
                        $maxselection=$t
                    }


                    $pages=$this.getpages($maxselection)
                    $t=((($page-1)*$o)+$selected)
                    $page=$math::ceiling($t/$maxselection)
                    $selected=$t%$maxselection
                    #write-host $selected
                    #write-host $t
                    #write-host $maxselection

                    $lastpage=-1

                    #$this.fillselection($pages,$page,$maxselection)
                    #$this.fillfooter($pages,$page,$maxselection)
                    #$this.hover($pages,$page,$selected,$movement)
                    break
                }

            }

            $boundaries=@(1;$currentpage.length)

            #w("$e[B$e[F$e[K$($k)")
            if($continue){
                continue
            }
            if($choice-ne$null){
                $out=$currentpage[$choice-1]
                break
            }
            if($quit){
                $out=@{}
                break
            }


            $pm=$movement
            $expectedposition=$selected+$movement
            #write-host "#"
            #write-host $expectedposition
            if(!($expectedposition-ge$boundaries[0] -and $expectedposition-le$boundaries[1])){
                $page+=$movement
                $movement=0
                if($expectedposition-gt$boundaries[1]-and($lastpage-ne-1)){ #!!@ icky
                    $expectedposition=$selected=1
                }
            }

            $page=$this.wrap($page,1,$pages.length)


            $currentpage=$pages[$page-1]


            $t=$this.wrap($this.constraint($expectedposition,0,$currentpage.length),1,$currentpage.length)
            if($t-ne$expectedposition){$movement=0;$selected=$t}



            
            $this.fillselection($pages,$page,$maxselection) # * pages logic..
            if($page-ne$lastpage){
                $this.fillfooter($pages,$page,$maxselection)
            }



            $this.hover($pages,$page,$selected,$movement)


            #$selected+=$movement
            $selected=$t
            $lastpage=$page
        }

        $cy=$currentpos[1]+1;$cx=$currentpos[0]+1
        w("$e[$($cy-$sizeoffset);$cx"+"f$e[s"+("$e[K$e[1B"*($totalspace))+"$e[u") # %% clear selection ui

        #w("$e[u")

        w("$e[?25h$e[?12h") # %% restore cursor and blinking

        #return " <pink>---".color()
        return $out
    }
}
$sel=[selection]::new(@{})

<#
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
    @{name="m";value="13 :3"};
    @{name="n";value="14 :3"};
    @{name="o";value="15 :3"};
    @{name="p";value="16 :3"};
    @{name="q";value="17 :3"};
    @{name="r";value="18 :3"};
    @{name="s";value="19 :3"};
    @{name="t";value="20 :3"};
    @{name="u";value="21 :3"};
    @{name="v";value="22 :3"};
    @{name="w";value="23 :3"};
    @{name="x";value="24 :3"};
    @{name="y";value="25 :3"};
    @{name="z";value="26 :3"};
    
)
#>

$selection=@()
for($i=0;$i-lt100;){
    $i++
    $selection+=,@{name="$i";value="$i :3"}
}

#w("<pink>---\n")

<#
$s=[selection]::new($selection)
$s.start("thingy")

sleep -milliseconds 1250

$s=[selection]::new($selection)
$s.start("bwaa")
#>

#pause


<#
$f=@()
$pd=$pwd.path
cd ".."
(ls "$pd\.." -recurse -file)|%{
    $ignored=$false
    $name=$_.name
    $basename=$_.basename
    $directory=$_.directory
    $extension=$_.extension
    

    if(($extension -ne '.ps1')){return}
    
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
        
        value=$t
    }

}
cd $pd
#>

#$f=@(@{name="a";value="1"})

<#
$t='https://api.github.com/repos/ttewi/pwsh/contents'
$t=$json.parse((curl.exe -s $t)).syncroot
$i=0
foreach($h in $t){
    $m=@{}
    foreach($q in $h.psobject.properties){
        $a=$q.name;$b=$q.value;
        $m[$a]=$b
    }
    $t[$i++]=$m
}

$f=$t
#>


w($pcd.pull()[0].data.teic+"\n")
#w("\n"*30)


$sx,$sy=$sel.getpos()
w("$e[19A$e[56C") # = 19,56




#$t=[selection]::new($selection).start()
$previousloc=@()
$previousloc+=($loc='https://api.github.com/repos/ttewi/pwsh/contents/public')

for(;;){
    $f=$null
    $tt=$json.parse((curl.exe -s $loc)).syncroot
    $i=0;$g=@()
    foreach($h in $tt){
        $m=@{}
        foreach($q in $h.psobject.properties){
            $a=$q.name;$b=$q.value;
            $m[$a]=$b
        }
        $g+=$m
        $i++
    }

    $f=$g

    $t=@{}
    $t=([selection]::new($f).start("script",12))

    $break=$false
    $err=$false


    <#
    if($t.count-eq0){
        $err=$loc
        break
    }
    #>

    $type=$t.type
    $name=$t.name


    switch ($type){
        default {
            $loc=$previousloc[-1]
            $l=$previousloc.length
            if($l-ne1){
                $previousloc=$previousloc[0..($l-2)]
            }
            sleep -milliseconds 400
        }
        "dir" {
            $previousloc+=$loc
            $loc=$t.url
            sleep -milliseconds 400
        }
        "file" {
            if(!($name-match'\.ps1$')){
                continue
            }
            $break=$true
        }
    }

    
    #if($type-eq'file'-and$name-match'\.ps1$'){break}

    if($break){break}
}

w("$e[$($sy+1);$sx"+"f")

# $t

iex((curl.exe -s $t.download_url)-join"`n")

#iex("cls;"+(gc -raw ([selection]::new($f).start("script")).value))
#iex("cls;&'"+([selection]::new($f).start("script")).value+"'")







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
