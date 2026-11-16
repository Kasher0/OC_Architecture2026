# Lab 5 — Encoding forensics

Pair: none, done individually at home · Driver first half: n/a
Machine: Windows 11 laptop (host) + Ubuntu 26.04 LTS Server guest in VirtualBox ("ubuntu-server", minimized install), reached with `ssh -p 2222`
Date: <date>
Name: <your name>

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
<PASTE the real output>
```

**4. The bytes**

```
{ echo '$ xxd evidence/staff-broken.csv | head -n 8'; xxd evidence/staff-broken.csv | head -n 8; } > evidence/hexdump-before.txt
cat evidence/hexdump-before.txt
<PASTE the real first lines of the hex dump>
```

**5. Which code page.** Trying the candidates and looking for a name that reads correctly, Russian and Kazakh:

```
iconv -f WINDOWS-1251 -t UTF-8 evidence/staff-broken.csv | head -n 5
iconv -f RK1048 -t UTF-8 evidence/staff-broken.csv | head -n 5
<PASTE what each one printed, and say which one read every name correctly>
```

**6. Convert** with `scripts/fix.sh` (in the repo):

```
sh scripts/fix.sh
<PASTE the content of scripts/fix.sh as you actually ran it>
```

**7. Verify**

```
{ echo '$ file evidence/staff-fixed.csv'; file evidence/staff-fixed.csv; echo; echo '$ xxd evidence/staff-fixed.csv | head -n 4'; xxd evidence/staff-fixed.csv | head -n 4; } > evidence/file-after.txt
cat evidence/file-after.txt
<PASTE the real output>
```

## Result

### What I received

- Excel: <one line: what it looked like>
- LibreOffice: <one line: what the default character set in the import dialog was, and what the table looked like>
- Terminal (`cat`): <one line>

### Diagnosis (made before the fix)

- `file` said: <...> (`evidence/file-before.txt`)
- First 16 bytes: <hex> (`evidence/hexdump-before.txt`)
- Encoding: <exact name> — because <the bytes you saw, for example that "A" is the single byte C0>
- Line ending: <CRLF / LF> — because <the bytes at the end of line 1, 0D 0A or 0A>
- BOM: <yes / no> — because <first bytes>; in the fixed file I <kept / removed / added> it because <reason, keeping in mind that the brief wants it to open correctly in Excel by double-click>
- Separator: <, or ;>

### Fix

`scripts/fix.sh` converts the file from <encoding> to UTF-8 with `iconv` and handles the line endings as decided above. The original stays untouched in `evidence/staff-broken.csv`; the result is `evidence/staff-fixed.csv`.

### Verification

`evidence/file-after.txt`: <say what `file` reports now, UTF-8, and whether it says "with BOM" / "with CRLF" as chosen>. The Cyrillic letters are now two-byte UTF-8 pairs. The fixed file opened correctly in <Excel>, LibreOffice and a terminal, all in one screenshot: `evidence/opens-correctly.png`.

## What did not work the first time

**What I saw.** After the conversion had run, I looked at `staff-fixed.csv` with `cat` in the Ubuntu guest and the Kazakh letters were not visible there, as if the fix had not worked, even though the command had finished without errors.

**What it was.** The file was fine, the display was not. The guest is a minimized Ubuntu Server install, and its text console could not show the Kazakh letters, so they did not appear on screen even though the bytes in the file were already correct UTF-8 (`file-after.txt` reports UTF-8). <Add how you checked it, for example: the same file read correctly in LibreOffice, or the Kazakh letters showed up as two-byte D2 xx / D3 xx pairs in `xxd evidence/staff-fixed.csv | head`.>

**What I did.** I stopped treating the console output as the verdict on the file and checked the bytes and the other applications instead. For the terminal part of the screenshot I <say what you actually used: for example connected from the laptop with `ssh -p 2222 kash@127.0.0.1` in a terminal that has a font for these letters, and ran `cat evidence/staff-fixed.csv` there>. Lesson: when a conversion "looks wrong" in one place, first find out whether the file or the viewer is the problem; the hex dump answers that.

## Evidence

- [evidence/](evidence/) — one line per file on what it proves:
  - `staff-broken.csv` — the original as received, never edited.
  - `file-before.txt` — what `file` guessed before the fix (a guess, not proof).
  - `hexdump-before.txt` — the real bytes: encoding, BOM and line ending are read from here.
  - `staff-fixed.csv` — the result of `scripts/fix.sh`.
  - `file-after.txt` — `file` and `xxd` on the fixed file: UTF-8, two-byte Cyrillic letters.
  - `opens-correctly.png` — the fixed file in Excel, LibreOffice and a terminal, names correct, Kazakh letters visible.
- [scripts/fix.sh](scripts/fix.sh) — the conversion, kept in the repo as required.
