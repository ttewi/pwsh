<<<<<<< HEAD
﻿#& header

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

    #_ #(.+?)\s*\-\s*#(.+) gradient regex dklsfajgh srry
    eo('string','color_old',{param($s) # w5
        $e=[char]27;
        $s=$s+$this;
        $d=@{black='#1e1e1e';darkblue='#0037da';darkgreen='#13a10e';darkcyan='#3a96dd';darkred='#c50f1f';darkmagenta='#800080';darkyellow='#cc7703';
        gray='#cdd6f4';darkgray='#767676';blue='#3b78ff';green='#16c60c';cyan='#61d6d6';red='#e74856';magenta='#b4009e';yellow='#f9f1a5';white='#eeedf0';
        reset="$e[0m";};
        $z='(?<!\\)';$t=([regex]"(?s)(?:$z<\s*(.+?)\s*>|^)?(.+?\n*)(?=$z<|$)").matches(($s-replace"$z\\n",("`n")))
        foreach($h in $t.getenumerator()){ # !: remake with argument support for pastelize/gradient
            $l=$h.groups[2].value-replace"(?<!\\)\\(<|>|\\)",'$1';$c=$h.groups[1].value;
            if($d[$c]){$c=$d[$c]};
            if($c[0]-eq'#'){
                #$k=38;$p=37;if($c[7]-eq'!'){$k=47;$p=40}
                $u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[byte]"0x$r"};
                $l="$e[38;2;$($u[0]);$($u[1]);$($u[2])m$l$e[37m"
            }else{
                switch ($c){
                    default {$l=$c+$l}
                    p {$l=$l.pastelize()}
                }
            };
            $f+=$l
        };
        return $f
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
                    "^p" {$l=$l.pastelize($q[0])}
                    "^#" {}
                }
            };
            $f+=$l
        }
        return $f
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

        [HashTable]parse($s){
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


if(($n=(ls $pscommandpath).name)-eq''){$n='script.ps1'};$u=$host.ui.rawui;$u.windowsize=$t=@{width=120;height=30};
$t.height=4096;$u.buffersize=$t;$u.windowtitle=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<#c9a0dc>て$n".color()} #* >.<



w("\n<#ffa0d2>b<white>wa<#76e7f4>a\n<#c9a0dc>:3 <yellow>!! <#76e7f4>c<#9f67e0>o<#67bae0>l<#67e0a5>o<#ede495>r<#ea8181>s\n\n<white>yayaya\n\n")

#w("<#ffa0d2>test`rt<white>es<#76e7f4>t\n\n")
#echo ($m.waitone(0))

$e=[char]27

"
<#ff8080>#!  warning
<#ff6767>#!! warning 2
$e[4m<#ff8080>#!:  underlined warning$e[24m
$e[4m<#ff6767>#!!: underlined warning 2$e[24m

<#c5b2e5>##   note
<#b79fdf># ## note 2

<#ffa0d2>#*   :3
<#ff86c6>#**  :3 2

<#fcb78d>#+   add
<#fba774>#++  add 2

<#aff8b9>#-   remove
<#98f6a4>#--  remove 2

<#f5e399>#%   [placeholder]
<#f0dd8e>#%%  [placeholder] 2

<#a3f0fa>#=   [placeholder]
<#8becf9>#==  [placeholder] 2

<#d2c3fe>#&   [placeholder]
<#bfaafe>#&&  [placeholder] 2

<#a3b6fa>#?   explanation
<#8ba3f9>#??  explanation 2

<#ece7f6>#.   [placeholder]
<#d2cbdf>#..  [placeholder] 2

<#474747>#~   strikthrough

<#ece7f6>#/   folder
<#ece7f6>#\   folder 2


<#a3f0fa>#= ███████████████████
<#ffa0d2>#* ███████████████████
<#ece7f6>#. ███████████████████
<#ffa0d2>#* ███████████████████
<#a3f0fa>#= ███████████████████

".color()

#!   warning
#!!  warning 2
#!:  underlined warning
#!!: underlined warning 2

##   note
# ## note 2

#*   :3
#**  :3 2

#+   add
#++  add 2

#-   remove
#--  remove 2

#%   [placeholder]
#%%  [placeholder] 2

#=   [placeholder]
#==  [placeholder] 2

#&   [placeholder]
#&&  [placeholder] 2

#?   explanation
#??  explanation 2

#.   [placeholder]
#..  [placeholder] 2

#~   strikthrough

#/   folder
#\   folder 2


#= ███████████████████
#* ███████████████████
#. ███████████████████
#* ███████████████████
#= ███████████████████


"   <#76e7f4>*<#ffa0d2>*<white>*<#ffa0d2>*<#76e7f4>*".color()
("   <#76e7f4>█<#ffa0d2>█<white>█<#ffa0d2>█<#76e7f4>█\n"*5).color()






w('<gray>$env:username <reset>' + $env:username.pastelize() + '\n\n')
#w("yeon".pastelize() + '\n\n')


$signature=signature($n)
#w($signature + 'signature\n\n')

$e=[char]27

$t=$pwd
cd '.'
(ls -recurse '.' -file)|%{ # '.\desktop\powershell'
    $l=$_.length
    $tt=(signature("$($_.directory)\$($_.name)"))
    if($l-eq0){$l="$e[4m$l$e[24m"}
    w("$tt$l\n")
}
w('\n')
cd $t




#w('test<gray>test\n')






#w('<gray>Press Enter to continue...:\n');[void](read-host);

$m.dispose()
return "<#76e7f4>*<#ffa0d2>*".color()
#return '<#76e7f4>*'.color()
=======
﻿#& header

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

    #_ #(.+?)\s*\-\s*#(.+) gradient regex dklsfajgh srry
    eo('string','color_old',{param($s) # w5
        $e=[char]27;
        $s=$s+$this;
        $d=@{black='#1e1e1e';darkblue='#0037da';darkgreen='#13a10e';darkcyan='#3a96dd';darkred='#c50f1f';darkmagenta='#800080';darkyellow='#cc7703';
        gray='#cdd6f4';darkgray='#767676';blue='#3b78ff';green='#16c60c';cyan='#61d6d6';red='#e74856';magenta='#b4009e';yellow='#f9f1a5';white='#eeedf0';
        reset="$e[0m";};
        $z='(?<!\\)';$t=([regex]"(?s)(?:$z<\s*(.+?)\s*>|^)?(.+?\n*)(?=$z<|$)").matches(($s-replace"$z\\n",("`n")))
        foreach($h in $t.getenumerator()){ # !: remake with argument support for pastelize/gradient
            $l=$h.groups[2].value-replace"(?<!\\)\\(<|>|\\)",'$1';$c=$h.groups[1].value;
            if($d[$c]){$c=$d[$c]};
            if($c[0]-eq'#'){
                #$k=38;$p=37;if($c[7]-eq'!'){$k=47;$p=40}
                $u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[byte]"0x$r"};
                $l="$e[38;2;$($u[0]);$($u[1]);$($u[2])m$l$e[37m"
            }else{
                switch ($c){
                    default {$l=$c+$l}
                    p {$l=$l.pastelize()}
                }
            };
            $f+=$l
        };
        return $f
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
                    "^p" {$l=$l.pastelize($q[0])}
                    "^#" {}
                }
            };
            $f+=$l
        }
        return $f
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

        [HashTable]parse($s){
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


if(($n=(ls $pscommandpath).name)-eq''){$n='script.ps1'};$u=$host.ui.rawui;$u.windowsize=$t=@{width=120;height=30};
$t.height=4096;$u.buffersize=$t;$u.windowtitle=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<#c9a0dc>て$n".color()} #* >.<



w("\n<#ffa0d2>b<white>wa<#76e7f4>a\n<#c9a0dc>:3 <yellow>!! <#76e7f4>c<#9f67e0>o<#67bae0>l<#67e0a5>o<#ede495>r<#ea8181>s\n\n<white>yayaya\n\n")

#w("<#ffa0d2>test`rt<white>es<#76e7f4>t\n\n")
#echo ($m.waitone(0))

$e=[char]27

"
<#ff8080>#!  warning
<#ff6767>#!! warning 2
$e[4m<#ff8080>#!:  underlined warning$e[24m
$e[4m<#ff6767>#!!: underlined warning 2$e[24m

<#c5b2e5>##   note
<#b79fdf># ## note 2

<#ffa0d2>#*   :3
<#ff86c6>#**  :3 2

<#fcb78d>#+   add
<#fba774>#++  add 2

<#aff8b9>#-   remove
<#98f6a4>#--  remove 2

<#f5e399>#%   [placeholder]
<#f0dd8e>#%%  [placeholder] 2

<#a3f0fa>#=   [placeholder]
<#8becf9>#==  [placeholder] 2

<#d2c3fe>#&   [placeholder]
<#bfaafe>#&&  [placeholder] 2

<#a3b6fa>#?   explanation
<#8ba3f9>#??  explanation 2

<#ece7f6>#.   [placeholder]
<#d2cbdf>#..  [placeholder] 2

<#474747>#~   strikthrough

<#ece7f6>#/   folder
<#ece7f6>#\   folder 2


<#a3f0fa>#= ███████████████████
<#ffa0d2>#* ███████████████████
<#ece7f6>#. ███████████████████
<#ffa0d2>#* ███████████████████
<#a3f0fa>#= ███████████████████

".color()

#!   warning
#!!  warning 2
#!:  underlined warning
#!!: underlined warning 2

##   note
# ## note 2

#*   :3
#**  :3 2

#+   add
#++  add 2

#-   remove
#--  remove 2

#%   [placeholder]
#%%  [placeholder] 2

#=   [placeholder]
#==  [placeholder] 2

#&   [placeholder]
#&&  [placeholder] 2

#?   explanation
#??  explanation 2

#.   [placeholder]
#..  [placeholder] 2

#~   strikthrough

#/   folder
#\   folder 2


#= ███████████████████
#* ███████████████████
#. ███████████████████
#* ███████████████████
#= ███████████████████


"   <#76e7f4>*<#ffa0d2>*<white>*<#ffa0d2>*<#76e7f4>*".color()
("   <#76e7f4>█<#ffa0d2>█<white>█<#ffa0d2>█<#76e7f4>█\n"*5).color()






w('<gray>$env:username <reset>' + $env:username.pastelize() + '\n\n')
#w("yeon".pastelize() + '\n\n')


$signature=signature($n)
#w($signature + 'signature\n\n')

$e=[char]27

$t=$pwd
cd '.'
(ls -recurse '.' -file)|%{ # '.\desktop\powershell'
    $l=$_.length
    $tt=(signature("$($_.directory)\$($_.name)"))
    if($l-eq0){$l="$e[4m$l$e[24m"}
    w("$tt$l\n")
}
w('\n')
cd $t




#w('test<gray>test\n')






#w('<gray>Press Enter to continue...:\n');[void](read-host);

$m.dispose()
return "<#76e7f4>*<#ffa0d2>*".color()
#return '<#76e7f4>*'.color()
>>>>>>> 9faad1be1c4a01cda605ea0a4318101187009d24
