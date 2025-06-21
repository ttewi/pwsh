
#* powershell -executionpolicy bypass -noexit -command "&'%1'"

# powershell -executionpolicy bypass -noexit -command "&'%1'|tee -variable t;echo $t;if($t[$t.length-1] -eq'close'){exit}"

# powershell -executionpolicy bypass -noexit -command "&'%1'|tee -variable t;$l=$t.length;if(($l -ne 0)-and($t.substring($l-5) -eq'close')){exit}"

# powershell -executionpolicy bypass -noexit -command "&'%1'|tee -variable t;$l=$t.length;echo ($t.substring($l-5))"





# powershell -executionpolicy bypass -noexit -command "$tn=$host.UI.RawUI.CursorPosition;&'%1'|tee -variable t;$tn.x;$host.UI.RawUI.CursorPosition=$tn;echo ($host.UI.RawUI.CursorPosition);write-host -foregroundcolor 'cyan' (\""`r\""+$t[$t.length-1])"


# powershell -executionpolicy bypass -noexit -command "echo(&'%1')"

#* powershell -executionpolicy bypass -noexit -command "&'%1'|write-host -foregroundcolor 'cyan'"

#* powershell -executionpolicy bypass -noexit -command "write-host -foregroundcolor 'cyan' (&'%1')"

# powershell -executionpolicy bypass -noexit -command "function w($s){$t=([regex]'(?s)(?:(?:(?<!\\)\<(.+?)\>)|^)?(.+?\n?)(?=(?<!\\)\<|$)').matches(($s -replace'(?<!\\)\\n',\""`n\""));foreach($h in $t.getenumerator()){$l=$h.groups[2].value;$c=$h.groups[1].value;if($c -eq''){$c='white'};$t=@{nonewline=$null};if($c -ne'white'){$t.foregroundcolor=$c};write-host @t $l;}return};w((&'%1')+\""`n\"")"


<#
@
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-Command" "if((Get-ExecutionPolicy ) -ne 'AllSigned') { Set-ExecutionPolicy -Scope Process Bypass }; & '%1'"
#>