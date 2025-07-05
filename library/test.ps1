<<<<<<< HEAD
mode 120,30;if(($n=$myinvocation.mycommand.name)-eq''){$n='script.ps1'};$c=[console];
$c::title=$n;$c::bufferheight=4096;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<#c9a0dc>て$n".color()} #* >.<



$host.ui.rawui.windowsize=@{width=120;height=30}
#echo ($host.ui.rawui)

=======
mode 120,30;if(($n=$myinvocation.mycommand.name)-eq''){$n='script.ps1'};$c=[console];
$c::title=$n;$c::bufferheight=4096;cd([environment]::currentdirectory=$psscriptroot);
if(!($m=[threading.mutex]::new(1,"て$n")).waitone(0)){return "<#c9a0dc>て$n".color()} #* >.<



$host.ui.rawui.windowsize=@{width=120;height=30}
#echo ($host.ui.rawui)

>>>>>>> 9faad1be1c4a01cda605ea0a4318101187009d24
pause