# Lab 5 — Encoding forensics

Pair: none, done individually at home · Driver first half: n/a
Machine: Windows 11 laptop (host) + Ubuntu 26.04 LTS Server guest in VirtualBox ("ubuntu-server", minimized install), reached with `ssh -p 2222`
Date: <date>
Name: Kazhymurat

## Note

I used Google sheets instead of Excel because the second didnt work properly neither as a app nor in the web

## What I did

Everything below was run from `~/lab05` in the Ubuntu guest. The original `staff-broken.csv` was copied there from the laptop with `scp` and never edited.

**1. Get the file into the guest**

```
scp -P 2222 staff-broken.csv kash@127.0.0.1:
mkdir -p ~/lab05/evidence ~/lab05/scripts
mv ~/staff-broken.csv ~/lab05/evidence/
```

**2. First look (nothing changed, nothing saved).** I opened a copy of the file in Excel, in LibreOffice (import dialog left at its default character set) and with `cat`. See "Result" for what each one showed.

**3. What `file` says**

```
{ echo '$ file evidence/staff-broken.csv'; file evidence/staff-broken.csv; } > evidence/file-before.txt
cat evidence/file-before.txt
$ file evidence/staff-broken.csv
evidence/staff-broken.csv: Non-ISO extended-ASCII text, with CRLF line terminators

```

**4. The bytes**

```
{ echo '$ xxd evidence/staff-broken.csv | head -n 8'; xxd evidence/staff-broken.csv | head -n 8; } > evidence/hexdump-before.txt
cat evidence/hexdump-before.txt
49 44 3B D4 E0 EC E8 EB E8 FF 3B C8 EC FF 3B CE
```

**5. Which code page.** Trying the candidates and looking for a name that reads correctly, Russian and Kazakh:

```
iconv -f WINDOWS-1251 -t UTF-8 evidence/staff-broken.csv | head -n 5
iconv -f RK1048 -t UTF-8 evidence/staff-broken.csv | head -n 5
the right code page was RK1048
```

**6. Convert** with `scripts/fix.sh` (in the repo):

```
sh scripts/fix.sh
# Lab 5: convert staff-broken.csv from code page RK1048 to UTF-8
$src  = [System.Text.Encoding]::GetEncoding(RK1048)
$text = [System.IO.File]::ReadAllText("$PWD\evidence\staff-broken.csv", $src)
# line endings — keep ONE line, or none:
# $text = $text -replace "`r`n", "`n"
$utf8 = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText("$PWD\evidence\staff-fixed.csv", $text, $utf8)
```

**7. Verify**

```
{ echo '$ file evidence/staff-fixed.csv'; file evidence/staff-fixed.csv; echo; echo '$ xxd evidence/staff-fixed.csv | head -n 4'; xxd evidence/staff-fixed.csv | head -n 4; } > evidence/file-after.txt
cat evidence/file-after.txt
$ file ~/lab05-encoding/evidence/staff-fixed.csv
/home/kash/lab05-encoding/evidence/staff-fixed.csv: Unicode text, UTF-8 (with BOM) text, with CRLF, CR line terminators

$ xxd ~/lab05-encoding/evidence/staff-fixed.csv | head -n 4
00000000: efbb bf49 443b d0a4 d0b0 d0bc d0b8 d0bb  ...ID;..........
00000010: d0b8 d18f 3bd0 98d0 bcd1 8f3b d09e d182  ....;......;....
00000020: d0b4 d0b5 d0bb 3bd0 94d0 bed0 bbd0 b6d0  ......;.........
00000030: bdd0 bed1 81d1 82d1 8c3b d093 d0be d180  .........;......

```

## Result

### What I received

- Excel: kazakh letters that didnt display properly are now fixed
- LibreOffice: the whole table was unreadable after the fix the letters are displayed properly
- Terminal (`cat`): the whole table was unreadable after the fix the letters are displayed properly

### Diagnosis (made before the fix)

- `file` said: evidence/staff-broken.csv: Non-ISO extended-ASCII text, with CRLF line terminators
 (`evidence/file-before.txt`)
- First 16 bytes: 49 44 3B D4 E0 EC E8 EB E8 FF 3B C8 EC FF 3B CE (`evidence/hexdump-before.txt`)
- Encoding: RK1048 — because Ә = A3
- Line ending: CRLF — because Windows and Google sheets requires CRLF
- BOM: <yes / no> — because 49 44; in the fixed file I added it because it should be opened in every app

### Fix

`scripts/fix.sh` converts the file from <encoding> to UTF-8 with `iconv` and handles the line endings as decided above. The original stays untouched in `evidence/staff-broken.csv`; the result is `evidence/staff-fixed.csv`.

### Verification

`evidence/file-after.txt`: <say what `file` reports now, UTF-8, and whether it says "with BOM" / "with CRLF" as chosen>. The Cyrillic letters are now two-byte UTF-8 pairs. The fixed file opened correctly in Google sheets, LibreOffice and a terminal, all in one screenshot: `evidence/opens-correctly.png`.

## What did not work the first time

**What I saw.** After the conversion had run, I looked at `staff-fixed.csv` with `cat` in the Ubuntu guest and the Kazakh letters were not visible there, as if the fix had not worked, even though the command had finished without errors.

**What it was.** The file was fine, the display was not. The guest is a minimized Ubuntu Server install, and its text console could not show the Kazakh letters, so they did not appear on screen even though the bytes in the file were already correct UTF-8 (`file-after.txt` reports UTF-8). <Add how you checked it, for example: the same file read correctly in LibreOffice, or the Kazakh letters showed up as two-byte D2 xx / D3 xx pairs in `xxd evidence/staff-fixed.csv | head`.>

**What I did.** I stopped treating the console output as the verdict on the file and checked the bytes and the other applications instead. For the terminal part of the screenshot I <say what you actually used: for example connected from the laptop with `ssh -p 2222 kash@127.0.0.1` in a terminal that has a font for these letters, and ran `cat evidence/staff-fixed.csv` there>. Lesson: when a conversion "looks wrong" in one place, first find out whether the file or the viewer is the problem; the hex dump answers that.
