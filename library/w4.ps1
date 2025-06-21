
<#
if(($n=$myinvocation.mycommand.name)-eq''){$n='dummy.ps1'};
mode 120,30;[console]::title=$n;cd($cwd=$psscriptroot);#* >.<
if(!($m=[threading.mutex]::new(1,'て'+$n)).waitone(0)){return};
#>



if(($n=$myinvocation.mycommand.name)-eq''){$n='dummy.ps1'};mode 120,30;
[console]::title=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "て$n"};#* >.<




function w($s){$t=([regex]'(?s)(?:(?:(?<!\\)\<(.+?)\>)|^)?(.+?\n?)(?=(?<!\\)\<|$)').matches(($s-replace'(?<!\\)\\n',"`n"));
    foreach($h in $t.getenumerator()){$l=$h.groups[2].value;$c=$h.groups[1].value;if($c-eq''){$c='white'};
    $l=$l-replace'(?<!\\)\\(.)','$1';$p=@{nonewline=$null};if($c-ne'white'){$p.foregroundcolor=$c};write-host @p $l;};return}





function w2($s){
    if(!($s-is[array])){$s=@($s)}
    $f='';
    $e=[char]27;
    $t=([regex]'(?s)(?:(?:(?<!\\)\<\s*(.+?)\s*\>)|^)?(.+?\n?)(?=(?<!\\)\<|$)').matches(($s[0]-replace'(?<!\\)\\n',"`n"));
    foreach ($h in $t.getenumerator()){
        $l=$h.groups[2].value;$c=$h.groups[1].value;
        if($c-eq''){$c='white'};
        $l=$l-replace'(?<!\\)\\(.)','$1';
        $p=@{nonewline=$null};

        if($c[0]-eq'#'){
            $u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[int]('0x'+$r)};
            $l="$e[38;2;$($u[0]);$($u[1]);$($u[2])m"+$l+"$e[0m"
        }else{if($c-ne'white'){$p.foregroundcolor=$c}};




        write-host @p $l;
        $f+=$l

    }

    if ($s[1]-ne$null){return($f)}
    return
}


function w3($s){
    if(!($s-is[array])){$s=@($s)}
    $d=@{
        black='#1e1e1e';
        darkblue='#0037da';
        darkgreen='#13a10e';
        darkcyan='#3a96dd';
        darkred='#c50f1f';
        darkmagenta='#800080';
        darkyellow='#cc7703';
        gray='#cdd6f4';
        darkgray='#767676';
        blue='#3b78ff';
        green='#16c60c';
        cyan='#61d6d6';
        red='#e74856';
        magenta='#b4009e';
        yellow='#f9f1a5';
        white='#eeedf0';
    }
    $p=@{nonewline=$null};
    $e=[char]27;
    $t=([regex]'(?s)(?:(?:(?<!\\)\<\s*(.+?)\s*\>)|^)?(.+?\n?)(?=(?<!\\)\<|$)').matches(($s[0]-replace'(?<!\\)\\n',"`n"));
    foreach ($h in $t.getenumerator()){
        $l=$h.groups[2].value-replace'(?<!\\)\\(.)','$1';$c=$h.groups[1].value;
        #if($c-eq''){$c='white'};
        #$l=$l-replace'(?<!\\)\\(.)','$1';

        if($d[$c]){$c=$d[$c]}
        if($c[0]-eq'#'){
            $u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[int]('0x'+$r)};
            $l="$e[38;2;$($u[0]);$($u[1]);$($u[2])m"+$l+"$e[0m"
        };

        $f+=$l
    }

    if($s[1]-eq$null){write-host @p $f}else{return $f};
}

function w4($s){if(!($s-is[array])){$s=@($s)};$d=@{black='#1e1e1e';darkblue='#0037da';darkgreen='#13a10e';darkcyan='#3a96dd';
    darkred='#c50f1f';darkmagenta='#800080';darkyellow='#cc7703';gray='#cdd6f4';darkgray='#767676';blue='#3b78ff';green='#16c60c';
    cyan='#61d6d6';red='#e74856';magenta='#b4009e';yellow='#f9f1a5';white='#eeedf0'};$p=@{nonewline=$null};$e=[char]27;
    $t=([regex]'(?s)(?:(?:(?<!\\)\<\s*(.+?)\s*\>)|^)?(.+?\n?)(?=(?<!\\)\<|$)').matches(($s[0]-replace'(?<!\\)\\n',"`n"));
    foreach ($h in $t.getenumerator()){$l=$h.groups[2].value-replace'(?<!\\)\\(.)','$1';$c=$h.groups[1].value;
        if($d[$c]){$c=$d[$c]};if($c[0]-eq'#'){$u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[int]('0x'+$r)};
        $l="$e[38;2;$($u[0]);$($u[1]);$($u[2])m"+$l+"$e[0m"};$f+=$l};if($s[1]-eq$null){write-host @p $f}else{return $f}};


# <>██
w('<black>██<darkblue>██<darkgreen>██<darkcyan>██<darkred>██<darkmagenta>██<darkyellow>██<gray>██<darkgray>██<blue>██<green>██<cyan>██<red>██<magenta>██<yellow>██<white>██\n')
w3('<black>██<darkblue>██<darkgreen>██<darkcyan>██<darkred>██<darkmagenta>██<darkyellow>██<gray>██<darkgray>██<blue>██<green>██<cyan>██<red>██<magenta>██<yellow>██<white>██\n\n')

#w('<cyan>bw<white>aa <yellow>:3\n')


#w2('<#ffa0d2>test<yellow>! <#cdd6f4>n<#c9a0dc>e<#76e7f4>w\n')


#w('<red>test ██\n')

w3('<#ffa0d2>test<yellow>! <#cdd6f4>n<#c9a0dc>e<#76e7f4>w')

w3(' <#ffa06a>=> <white>:3\n\n')



w3('<#c9a0dc>wisteria?\n')


w4('<#ffa0d2>test<yellow>! <#cdd6f4>n<#c9a0dc>e<#76e7f4>w'); w4(' <#ffa06a>=> <white>:3\n\n')

echo test

w4('<@>yayayay\n')




#echo ([environment]::currentdirectory)

#echo ($m.waitone(0))



#/fn
    function k($s){
        $h=@{}
        $f=@{} #[hashtable]::new()
        foreach($t in ($s|ConvertFrom-Json).psobject.properties){
            $a=$t.name;$b=$t.value;
            $h[$a]=$f[$a]=$b
        }
        $n=l($s)


        foreach ($t in $h.getenumerator()) {
            $a=$t.name;$b=$t.value;
            if ($b.length -eq $null) {$f[$a]=$n[$a]}
        }


        return $f
    };
    add-type -assemblyname 'System.Web.Extensions'
    function l([string]$s) {
        $parser = New-Object Web.Script.Serialization.JavaScriptSerializer
        $parser.MaxJsonLength = $s.length
        Write-Output -NoEnumerate $parser.Deserialize($s, [hashtable])

        #Write-Output -NoEnumerate $parser.DeserializeObject($s)
        #return $parser.Deserialize($s, [hashtable])
        # To deserialize to a dictionary, use $parser.DeserializeObject($text) instead
    }
    function format-json([Parameter(Mandatory, ValueFromPipeline)][String] $json) {
        $indent = 0;
        ($json -Split "`n" | % {
            if ($_ -match '[\}\]]\s*,?\s*$') {$indent--};
            $line = ('  ' * $indent) + $($_.TrimStart() -replace '":  (["{[])', '": $1' -replace ':  ', ': ');
            if ($_ -match '[\{\[]\s*$') {$indent++};
            $line
        }) -Join "`n"
    };
    function json($o){return ($o|convertto-json|format-json)}


## json



#set-psreadlinekeyhandler -chord 'ctrl+b' -scriptblock {}





#pause
$m.dispose()
return w3('<red>test ██',1)
