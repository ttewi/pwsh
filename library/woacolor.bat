echo off&cls
for /F "delims=#" %%a in ('prompt #$E# ^& for %%a in ^(1^) do rem') do set "e=%%a"
echo %e%[38;2;255;160;210mbwaa%e%[0m



pause