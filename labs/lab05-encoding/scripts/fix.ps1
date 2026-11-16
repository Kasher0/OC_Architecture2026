# Lab 5: convert staff-broken.csv from code page RK1048 to UTF-8
$src  = [System.Text.Encoding]::GetEncoding(RK1048)     # e.g. 1251 for Windows-1251
$text = [System.IO.File]::ReadAllText("$PWD\evidence\staff-broken.csv", $src)
# line endings — keep ONE line, or none:
# $text = $text -replace "`r`n", "`n"                  # CRLF -> LF
$utf8 = New-Object System.Text.UTF8Encoding($true)     # $true = with BOM, $false = without
[System.IO.File]::WriteAllText("$PWD\evidence\staff-fixed.csv", $text, $utf8)