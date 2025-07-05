<<<<<<< HEAD
﻿#& header

    function eo($o){
        $t=@{membertype='scriptmethod';force=$null;membername=$o[1];value=$o[2]};
        $o[0]|update-typedata @t
    }

    #_ #(.+?)\s*\-\s*#(.+) gradient regex dklsfajgh srry
    eo('string','color',{param($s) # w5
        $e=[char]27;
        $s=$s+$this;
        $d=@{black='#1e1e1e';darkblue='#0037da';darkgreen='#13a10e';darkcyan='#3a96dd';darkred='#c50f1f';darkmagenta='#800080';darkyellow='#cc7703';
        gray='#cdd6f4';darkgray='#767676';blue='#3b78ff';green='#16c60c';cyan='#61d6d6';red='#e74856';magenta='#b4009e';yellow='#f9f1a5';white='#eeedf0';
        reset="$e[0m";};
        $z='(?<!\\)';$t=([regex]"(?s)(?:$z<\s*(.+?)\s*>|^)?(.+?\n*)(?=$z<|$)").matches(($s-replace"$z\\n",("`n")))
        foreach($h in $t.getenumerator()){
            $l=$h.groups[2].value-replace"(?<!\\)\\(<|>|\\)",'$1';$c=$h.groups[1].value;
            if($d[$c]){$c=$d[$c]};
            if($c[0]-eq'#'){
                #$k=38;$p=37;if($c[7]-eq'!'){$k=47;$p=40}
                $u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[byte]"0x$r"};
                $l="$e[38;2;$($u[0]);$($u[1]);$($u[2])m$l$e[37m"
            }else{$l=$c+$l};
            $f+=$l
        };
        return $f
    })

    function w($s){
        $p=@{nonewline=$null};
        write-host @p $s.color()
    }

    eo('string','pastelize',{
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
            $f+=([byte]$math::round($r*255))#.tostring('x2')
            $f+=([byte]$math::round($g*255))#.tostring('x2')
            $f+=([byte]$math::round($b*255))#.tostring('x2')

            return $f
        }

        $utf8=[text.encoding]::utf8
        $y=$utf8.getbytes($this)
        $hash=$crc32::rtlcomputecrc32(0,$y,$y.count)
        

        $u=hslc(@(
            $math::floor($hash/551%360);
            (0.85+(1.0-0.85)*($math::floor($hash/434%101)/100));
            (0.65+(0.9-0.65)*($math::floor($hash/575%101)/100))
        ))

        $e=[char]27

        #return $this.color("<$(hslh($f))>")
        return "$e[38;2;$($u[0]);$($u[1]);$($u[2])m$this$e[37m"
    })

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

# if(!($n=(ls $pscommandpath).name)){$n='script.ps1'};$u=$host.ui.rawui;$u.windowsize=$t=@{width=120;height=30};

if(($n=(ls $pscommandpath).name)-eq''){$n='script.ps1'};$u=$host.ui.rawui;$u.windowsize=$t=@{width=120;height=30};
$t.height=4096;$u.buffersize=$t;$u.windowtitle=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<#c9a0dc>て$n".color()} #* >.<


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
    $pd=$pwd.path

    $l="$env:userprofile\documents\my games\terraria\tModLoader" #& \tModLoader
    cd $l
    $favorites=$json.parse((gc -raw '.\favorites.json'))

    $worldsizes=@{
        ('4200')='small';
        ('6400')='medium';
        ('8400')='large'
    }
    $gamemodes=@{
        ('2')='master'
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

w('\n<#ffa0d2>---\n\n')

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
    foreach($h in $f){
        $s=[io.binaryreader]::new([io.file]::openread($h.file))

        $w=@{}
        $t=$w.fileFormatHeader=@{} #= fileFormatHeader

            $version=$t.version=$s.readuint32();
            $t.favorite=$favorites.world[$h.name]
            echo ("position: $($s.basestream.position)")
            <#
            $t.magicnumber=[string]::new($s.readchars(7)); # $s.readstring()

            $t.filetype=$s.readbyte();
            $t.revision=$s.readuint32();
            #$t.favorite=$s.readint64();
            #$t.favorite=$s.readboolean();
            [void] $s.readboolean();
            echo ("position: $($s.basestream.position)")
            $t.favorite=$favorites.world[$h.name]
            #>
            

            #for($i=0;$i-lt20;$i++){$s.readboolean();}

            #[void] $s.readbytes(7) #? skip
            [void] $s.readbytes(20) #? skip
            echo ("position: $($s.basestream.position)")
            #echo $s.readbytes(7)

            #[void] $s.readbytes((20+($s.readint16()*4)+($s.readint16()/8)))
            
            #echo (20+(($s.readint16()-1)*4)+($s.readint16()/8))

            #$t.pointers=@();
            #for ($c=$s.readint16();$c -gt 0;$c--){$t.pointers+=$s.readint32()};

            [void] $s.readbytes($s.readint16()*4) #? skip

            #$t.importants=$s.readint16() #!! skip importants (parseBitsByte)
            #$t.importants=$()
            #for ($i=$s.readint16();$i -gt 0;$i-=8){[void] $s.readbyte()};
            [void] $s.readbytes($s.readint16()/8) #? skip
            echo ("position: $($s.basestream.position)")


        $t=$w.header=@{} #= header

            $t.name=$s.readstring()
            $t.seed=$s.readstring()

            <#
            $t.worldGeneratorVersion=$s.readbytes(8)
            $t._uuid=$s.readbytes(16)
            #>
            [void] $s.readbytes(24) #? skip
            $t.uuid=-join $t._uuid.foreach('tostring','x2')
            $t.id=$s.readint32();

            [void] $s.readbytes(16) #? skip

            $t.height=$s.readint32();
            $t.width=$s.readint32();
            $t.size=$worldsizes["$($t.width)"];
            if(!$t.size){$t.size='unknown'}

            if($version-ge255){
                $t.gamemode=$gamemodes["$($s.readint32())"];
                #$t.gamemode=$s.readint32();

                $k=$t.worldflags=@{}
                $k.drunk=$s.readboolean();

                if($version-ge267){
                    $k.good=$s.readboolean();
                    $k.celebrationmk10=$s.readboolean();
                    $k.constant=$s.readboolean();
                    $k.notthebeeds=$s.readboolean();
                    $k.remix=$s.readboolean();
                    $k.notraps=$s.readboolean();
                    $k.zenith=$s.readboolean();
                }
            } else {$t.gamemode=$gamemodes["$($s.readboolean())"];}

            if(!$t.gamemode){$t.gamemode='unknown'}


            
            <#
            if ($version -ge 225){
                $t.gamemode=$s.readint32();
                $k=$t.worldflags=@{}
                $k.drunk=$s.readboolean();

                #?? skipping versions check
                if ($version -ge 267){
                    $k.good=$s.readboolean();
                    $k.celebrationmk10=$s.readboolean();
                    $k.constant=$s.readboolean();
                    $k.notthebeeds=$s.readboolean();
                    $k.remix=$s.readboolean();
                    $k.notraps=$s.readboolean();
                    $k.zenith=$s.readboolean();
                    
                }
            } else {$t.expertMode=$s.readboolean();}
            #>



            #$t._creationtime=$s.readbytes(8)
            [void] $s.readbytes(8) #? skip

            #$t.creationtime=@{unix=([datetimeoffset]($t._creationtime)).tounixtimeseconds()}
            #$t.creationtime=@{}

            $t.moontype=$s.readbyte();

            #& echo ("position: $($s.basestream.position)")

            #[void] $s.readbytes(137)

            <#
                $s.readint32();
                $s.readint32();
                $s.readint32();

                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readint32();

                $s.readint32();
                $s.readint32();
                $s.readint32();

                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readint32();


                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readdouble();
                $s.readdouble();
                $s.readdouble();
                $s.readboolean();
                $s.readint32();
                $s.readboolean();
                $s.readboolean();
                $s.readint32();
                $s.readint32();
            #>

            [void] $s.readbytes(115) #? skip

            #$t.crimson=$s.readboolean();
            #$t.eviltype=if($t.crimson){'crimson'}else{'corruption'}

            $t.eviltype=if($s.readboolean()){'crimson'}else{'corruption'}

            [void] $s.readbytes(21) #? skip

            #$s.readbytes(137)
            #for($i=0;$i-lt137;$i++){$s.readboolean();}

            #& echo ("position: $($s.basestream.position)")

            

            $t.altarcount=$s.readint32();

            $t.hardmode=$s.readboolean();

            #$t.afterPartyOfDoom=if($version -ge 257){$s.readboolean();}else{$false}
            if($version-ge257){[void] $s.readbytes(1);}

            #echo ("position: $($s.basestream.position)")
            #[void] $s.readbytes(38) #? skip
            [void] $s.readbytes(38) #? skip
            #$s.readbytes(38)
            <#
                for($i=0;$i-lt256;$i++){
                    $tt=$s.readint32()
                    if ($tt-eq107){
                        w('<red>!! ')
                    }
                    $tt
                }
            #>
            #echo ("position: $($s.basestream.position)")

            #$t.oretier1=$s.readint32();
            #$t.oretier2=$s.readint32();
            #$t.oretier3=$s.readint32();
            $t.hmores=@($s.readint32();$s.readint32();$s.readint32())

            #$t.treeStyle=$s.readint32();


        #$s|get-member

        #$w.fileformatheader
        #w('<cyan>---\n')
        #$w.header

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

        $h.data


        #$t=$h.data=@{}

        #$t.version=$s.readint32();
        #$favorite

        $t=$null
        #$h.t=$h.data.name
        #$h.f=$h.data.favorite

        $s.close() # $s.dispose()
        break
    }

#echo $f
$sort=$f|sort-object f

#% selection color string
    $utf8=[text.encoding]::utf8
    $p="<white>"
    $i=0
    foreach($h in $sort){
        if($h.flags.contains('ignored')){continue}

        #w('<cyan>---\n')
        #echo $h.data

        #$c=$utf8.getstring((gc $h.file -encoding 'byte' -totalcount 0xfff))

        $i++
        #$b=0xf
        $b=16
        $p+=$i
        $p+=(' '*($b-"$i".length))
        $p+=$h.data.name
        

        $p+='\n'

        $w=$null
        $consise=$null
        #break
    }


w($p)

#$f[2]
#$utf8
#$c=[text.encoding]::default.getstring((gc $f[2].file -encoding 'byte' -totalcount 4096)) # -totalcount 0xfff
# (?m)(�){3}(☺)\s+(.+?)☺\$☺�   ���☺ tewi_base☺\$☺
#$t=([regex]"(?m)í¼¾(.).{4}(.+?)\1\$").matches($c)#[0].groups[1].value # \x{fffd} \x{263a}

#echo ($c)
#echo ($t)

#$utf8=[text.encoding]::utf8 # (($b=[char[]]::new()),$offset,1)
#$offset=0

#$file=$f[11-1].file #* 10(hardmode) 18(crimson)

#$file





#* output
#$w.fileFormatHeader
#w('<#ffa0d2>---\n')
#$w.header
#$w.header.mapName
#$w.header.worldGeneratorVersion

#"$($w.header.creationTime)"


#w('<gray>Press Enter to continue...:\n');[void](read-host);

$m.dispose()
return '<#76e7f4>*'.color()
=======
﻿#& header

    function eo($o){
        $t=@{membertype='scriptmethod';force=$null;membername=$o[1];value=$o[2]};
        $o[0]|update-typedata @t
    }

    #_ #(.+?)\s*\-\s*#(.+) gradient regex dklsfajgh srry
    eo('string','color',{param($s) # w5
        $e=[char]27;
        $s=$s+$this;
        $d=@{black='#1e1e1e';darkblue='#0037da';darkgreen='#13a10e';darkcyan='#3a96dd';darkred='#c50f1f';darkmagenta='#800080';darkyellow='#cc7703';
        gray='#cdd6f4';darkgray='#767676';blue='#3b78ff';green='#16c60c';cyan='#61d6d6';red='#e74856';magenta='#b4009e';yellow='#f9f1a5';white='#eeedf0';
        reset="$e[0m";};
        $z='(?<!\\)';$t=([regex]"(?s)(?:$z<\s*(.+?)\s*>|^)?(.+?\n*)(?=$z<|$)").matches(($s-replace"$z\\n",("`n")))
        foreach($h in $t.getenumerator()){
            $l=$h.groups[2].value-replace"(?<!\\)\\(<|>|\\)",'$1';$c=$h.groups[1].value;
            if($d[$c]){$c=$d[$c]};
            if($c[0]-eq'#'){
                #$k=38;$p=37;if($c[7]-eq'!'){$k=47;$p=40}
                $u=@();foreach($r in ($c[1..6]-join''-split'(.{2})'-ne'')){$u+=[byte]"0x$r"};
                $l="$e[38;2;$($u[0]);$($u[1]);$($u[2])m$l$e[37m"
            }else{$l=$c+$l};
            $f+=$l
        };
        return $f
    })

    function w($s){
        $p=@{nonewline=$null};
        write-host @p $s.color()
    }

    eo('string','pastelize',{
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
            $f+=([byte]$math::round($r*255))#.tostring('x2')
            $f+=([byte]$math::round($g*255))#.tostring('x2')
            $f+=([byte]$math::round($b*255))#.tostring('x2')

            return $f
        }

        $utf8=[text.encoding]::utf8
        $y=$utf8.getbytes($this)
        $hash=$crc32::rtlcomputecrc32(0,$y,$y.count)
        

        $u=hslc(@(
            $math::floor($hash/551%360);
            (0.85+(1.0-0.85)*($math::floor($hash/434%101)/100));
            (0.65+(0.9-0.65)*($math::floor($hash/575%101)/100))
        ))

        $e=[char]27

        #return $this.color("<$(hslh($f))>")
        return "$e[38;2;$($u[0]);$($u[1]);$($u[2])m$this$e[37m"
    })

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

# if(!($n=(ls $pscommandpath).name)){$n='script.ps1'};$u=$host.ui.rawui;$u.windowsize=$t=@{width=120;height=30};

if(($n=(ls $pscommandpath).name)-eq''){$n='script.ps1'};$u=$host.ui.rawui;$u.windowsize=$t=@{width=120;height=30};
$t.height=4096;$u.buffersize=$t;$u.windowtitle=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<#c9a0dc>て$n".color()} #* >.<


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
    $pd=$pwd.path

    $l="$env:userprofile\documents\my games\terraria\tModLoader" #& \tModLoader
    cd $l
    $favorites=$json.parse((gc -raw '.\favorites.json'))

    $worldsizes=@{
        ('4200')='small';
        ('6400')='medium';
        ('8400')='large'
    }
    $gamemodes=@{
        ('2')='master'
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

w('\n<#ffa0d2>---\n\n')

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
    foreach($h in $f){
        $s=[io.binaryreader]::new([io.file]::openread($h.file))

        $w=@{}
        $t=$w.fileFormatHeader=@{} #= fileFormatHeader

            $version=$t.version=$s.readuint32();
            $t.favorite=$favorites.world[$h.name]
            echo ("position: $($s.basestream.position)")
            <#
            $t.magicnumber=[string]::new($s.readchars(7)); # $s.readstring()

            $t.filetype=$s.readbyte();
            $t.revision=$s.readuint32();
            #$t.favorite=$s.readint64();
            #$t.favorite=$s.readboolean();
            [void] $s.readboolean();
            echo ("position: $($s.basestream.position)")
            $t.favorite=$favorites.world[$h.name]
            #>
            

            #for($i=0;$i-lt20;$i++){$s.readboolean();}

            #[void] $s.readbytes(7) #? skip
            [void] $s.readbytes(20) #? skip
            echo ("position: $($s.basestream.position)")
            #echo $s.readbytes(7)

            #[void] $s.readbytes((20+($s.readint16()*4)+($s.readint16()/8)))
            
            #echo (20+(($s.readint16()-1)*4)+($s.readint16()/8))

            #$t.pointers=@();
            #for ($c=$s.readint16();$c -gt 0;$c--){$t.pointers+=$s.readint32()};

            [void] $s.readbytes($s.readint16()*4) #? skip

            #$t.importants=$s.readint16() #!! skip importants (parseBitsByte)
            #$t.importants=$()
            #for ($i=$s.readint16();$i -gt 0;$i-=8){[void] $s.readbyte()};
            [void] $s.readbytes($s.readint16()/8) #? skip
            echo ("position: $($s.basestream.position)")


        $t=$w.header=@{} #= header

            $t.name=$s.readstring()
            $t.seed=$s.readstring()

            <#
            $t.worldGeneratorVersion=$s.readbytes(8)
            $t._uuid=$s.readbytes(16)
            #>
            [void] $s.readbytes(24) #? skip
            $t.uuid=-join $t._uuid.foreach('tostring','x2')
            $t.id=$s.readint32();

            [void] $s.readbytes(16) #? skip

            $t.height=$s.readint32();
            $t.width=$s.readint32();
            $t.size=$worldsizes["$($t.width)"];
            if(!$t.size){$t.size='unknown'}

            if($version-ge255){
                $t.gamemode=$gamemodes["$($s.readint32())"];
                #$t.gamemode=$s.readint32();

                $k=$t.worldflags=@{}
                $k.drunk=$s.readboolean();

                if($version-ge267){
                    $k.good=$s.readboolean();
                    $k.celebrationmk10=$s.readboolean();
                    $k.constant=$s.readboolean();
                    $k.notthebeeds=$s.readboolean();
                    $k.remix=$s.readboolean();
                    $k.notraps=$s.readboolean();
                    $k.zenith=$s.readboolean();
                }
            } else {$t.gamemode=$gamemodes["$($s.readboolean())"];}

            if(!$t.gamemode){$t.gamemode='unknown'}


            
            <#
            if ($version -ge 225){
                $t.gamemode=$s.readint32();
                $k=$t.worldflags=@{}
                $k.drunk=$s.readboolean();

                #?? skipping versions check
                if ($version -ge 267){
                    $k.good=$s.readboolean();
                    $k.celebrationmk10=$s.readboolean();
                    $k.constant=$s.readboolean();
                    $k.notthebeeds=$s.readboolean();
                    $k.remix=$s.readboolean();
                    $k.notraps=$s.readboolean();
                    $k.zenith=$s.readboolean();
                    
                }
            } else {$t.expertMode=$s.readboolean();}
            #>



            #$t._creationtime=$s.readbytes(8)
            [void] $s.readbytes(8) #? skip

            #$t.creationtime=@{unix=([datetimeoffset]($t._creationtime)).tounixtimeseconds()}
            #$t.creationtime=@{}

            $t.moontype=$s.readbyte();

            #& echo ("position: $($s.basestream.position)")

            #[void] $s.readbytes(137)

            <#
                $s.readint32();
                $s.readint32();
                $s.readint32();

                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readint32();

                $s.readint32();
                $s.readint32();
                $s.readint32();

                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readint32();


                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readint32();
                $s.readdouble();
                $s.readdouble();
                $s.readdouble();
                $s.readboolean();
                $s.readint32();
                $s.readboolean();
                $s.readboolean();
                $s.readint32();
                $s.readint32();
            #>

            [void] $s.readbytes(115) #? skip

            #$t.crimson=$s.readboolean();
            #$t.eviltype=if($t.crimson){'crimson'}else{'corruption'}

            $t.eviltype=if($s.readboolean()){'crimson'}else{'corruption'}

            [void] $s.readbytes(21) #? skip

            #$s.readbytes(137)
            #for($i=0;$i-lt137;$i++){$s.readboolean();}

            #& echo ("position: $($s.basestream.position)")

            

            $t.altarcount=$s.readint32();

            $t.hardmode=$s.readboolean();

            #$t.afterPartyOfDoom=if($version -ge 257){$s.readboolean();}else{$false}
            if($version-ge257){[void] $s.readbytes(1);}

            #echo ("position: $($s.basestream.position)")
            #[void] $s.readbytes(38) #? skip
            [void] $s.readbytes(38) #? skip
            #$s.readbytes(38)
            <#
                for($i=0;$i-lt256;$i++){
                    $tt=$s.readint32()
                    if ($tt-eq107){
                        w('<red>!! ')
                    }
                    $tt
                }
            #>
            #echo ("position: $($s.basestream.position)")

            #$t.oretier1=$s.readint32();
            #$t.oretier2=$s.readint32();
            #$t.oretier3=$s.readint32();
            $t.hmores=@($s.readint32();$s.readint32();$s.readint32())

            #$t.treeStyle=$s.readint32();


        #$s|get-member

        #$w.fileformatheader
        #w('<cyan>---\n')
        #$w.header

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

        $h.data


        #$t=$h.data=@{}

        #$t.version=$s.readint32();
        #$favorite

        $t=$null
        #$h.t=$h.data.name
        #$h.f=$h.data.favorite

        $s.close() # $s.dispose()
        break
    }

#echo $f
$sort=$f|sort-object f

#% selection color string
    $utf8=[text.encoding]::utf8
    $p="<white>"
    $i=0
    foreach($h in $sort){
        if($h.flags.contains('ignored')){continue}

        #w('<cyan>---\n')
        #echo $h.data

        #$c=$utf8.getstring((gc $h.file -encoding 'byte' -totalcount 0xfff))

        $i++
        #$b=0xf
        $b=16
        $p+=$i
        $p+=(' '*($b-"$i".length))
        $p+=$h.data.name
        

        $p+='\n'

        $w=$null
        $consise=$null
        #break
    }


w($p)

#$f[2]
#$utf8
#$c=[text.encoding]::default.getstring((gc $f[2].file -encoding 'byte' -totalcount 4096)) # -totalcount 0xfff
# (?m)(�){3}(☺)\s+(.+?)☺\$☺�   ���☺ tewi_base☺\$☺
#$t=([regex]"(?m)í¼¾(.).{4}(.+?)\1\$").matches($c)#[0].groups[1].value # \x{fffd} \x{263a}

#echo ($c)
#echo ($t)

#$utf8=[text.encoding]::utf8 # (($b=[char[]]::new()),$offset,1)
#$offset=0

#$file=$f[11-1].file #* 10(hardmode) 18(crimson)

#$file





#* output
#$w.fileFormatHeader
#w('<#ffa0d2>---\n')
#$w.header
#$w.header.mapName
#$w.header.worldGeneratorVersion

#"$($w.header.creationTime)"


#w('<gray>Press Enter to continue...:\n');[void](read-host);

$m.dispose()
return '<#76e7f4>*'.color()
>>>>>>> 9faad1be1c4a01cda605ea0a4318101187009d24
