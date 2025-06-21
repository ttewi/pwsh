
<#* 2 lines silly
mode concols=120lines=30;cd $psscriptroot;if(![threading.mutex]::new(1,
'て'+([console]::title=$myinvocation.mycommand)).waitone(0)){return};#
#>

<#* 1 line silly
mode concols=120lines=30;cd $psscriptroot;if(![threading.mutex]::new(1,'て'+([console]::title=$myinvocation.mycommand)).waitone(0)){return};
#>


<#* 3 line simple
mode concols=120lines=30;cd $psscriptroot;
$n=[console]::title=$myinvocation.mycommand;
if(![threading.mutex]::new(1,'て'+$n).waitone(0)){return};
#>

<#* 2 line simple
mode concols=120lines=30;cd $psscriptroot;$n=[console]::title=$myinvocation.mycommand;
if(![threading.mutex]::new(1,'て'+$n).waitone(0)){return};
#>

<#* 1 line simple?
mode concols=120lines=30;cd $psscriptroot;$n=[console]::title=$myinvocation.mycommand;if(![threading.mutex]::new(1,'て'+$n).waitone(0)){return};
#>


<#* 3 line simple mutex reference
mode concols=120lines=30;cd $psscriptroot;
$n=[console]::title=$myinvocation.mycommand;
if(!($m=[threading.mutex]::new(1,'て'+$n)).waitone(0)){return};
#>

##

<#*
if(($n=$myinvocation.mycommand.name)-eq''){$n='dummy.ps1'};
mode 120,30;[console]::title=$n;cd($cwd=$psscriptroot);#* >.<
if(!($m=[threading.mutex]::new(1,'て'+$n)).waitone(0)){return};
#>

<#*
if(($n=$myinvocation.mycommand.name)-eq''){$n='dummy.ps1'};mode 120,30;
[console]::title=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "て$n"};#* >.<
#>

<#*
if(($n=$myinvocation.mycommand.name)-eq''){$n='script'};[console]::title=$n;
mode 50,15;cd([environment]::currentdirectory=$psscriptroot);if(!($m=#* >.<
[threading.mutex]::new(1,"て$n")).waitone(0)){return w("<#c9a0dc>て$n",1)};
#>

<#*
if(($n=$myinvocation.mycommand.name)-eq''){$n='dummy.ps1'};$s=@{width=120;height=30};$w=$host.ui.rawui;$w.buffersize=
@{width=$s.width;height=4096};$w.windowsize=$s;$w.windowtitle=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return w("<#c9a0dc>て$n",1)}; #* >.<
#>


<#*
if(($n=$myinvocation.mycommand.name)-eq''){$n='dummy.ps1'};mode 120,30;
$w=$host.ui.rawui;$b=$w.buffersize;$b.height=0xfff;$w.buffersize=$b;
$w.windowtitle=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return w("<#c9a0dc>て$n",1)};#* >.<
#>


<#* buffer height, .net cd, mutex reference, mutex held return, 3 lines (w4)
mode 120,30;if(($n=$myinvocation.mycommand.name)-eq''){$n='script.ps1'};$c=[console];
$c::title=$n;$c::bufferheight=4096;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return w("<#c9a0dc>て$n",1)};#* >.<
#>

#?? i think mode started bing weird after username change srry

<#
if(($n=(ls $pscommandpath).name)-eq''){$n='script.ps1'};$u=$host.ui.rawui;$u.windowsize=$t=@{width=120;height=30};
$t.height=4096;$u.buffersize=$t;$u.windowtitle=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<p,$n>て$n".color()} #* >.<
#>

<#* shortened non directory name set, [console] setwindowsize/setbufferize/title, .net cd, mutex reference, 3lines (.color() .pastelize())
if(!($n=$myinvocation.mycommand.name)){$n='t'};($u=[console])::setwindowsize(($t=120),30);
$u::setbuffersize($t,4096);$u::title=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<p,$n>て$n".color()} #* >.<
#>

<#* shortened non directory name set, [console] setwindowsize/setbufferize/title, .net cd, mutex reference ($mut), 3lines (.color() .pastelize())
if(!($n=$myinvocation.mycommand.name)){$n='t'};($u=[console])::setwindowsize(($t=120),30);
$u::setbuffersize($t,4096);$u::title=$n;cd([environment]::currentdirectory=$psscriptroot);
if(!($mut=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<p,$n>て$n".color()}#* >.<
#>



mode concols=120lines=30;cd $psscriptroot;
$n=[console]::title=$myinvocation.mycommand;
if(![threading.mutex]::new(1,'て'+$n).waitone(0)){return};


echo (0)


<#
#! ROBLOX_singletonMutex
start powershell -windowstyle hidden {
    mode concols=120lines=30;
    if(![threading.mutex]::new(1,([console]::title='ROBLOX_singletonMutex')).waitone(0)){return};
    pause
};
#>




#$args|%{echo $_}

pause
