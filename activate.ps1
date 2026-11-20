# WinRAR License Activator
# Tu dong cai dat khoa ban quyen WinRAR (rarreg.key)

$keyData = @"
RAR registration data
WinRAR
Unlimited Company License
UID=4b914fb772c8376bf571
6412212250f5711ad072cf351cfa39e2851192daf8a362681bbb1d
cd48da1d14d995f0bbf960fce6cb5ffde62890079861be57638717
7131ced835ed65cc743d9777f2ea71a8e32c7e593cf66794343565
b41bcf56929486b8bcdac33d50ecf773996052598f1f556defffbd
982fbe71e93df6b6346c37a3890f3c7edc65d7f5455470d13d1190
6e6fb824bcf25f155547b5fc41901ad58c0992f570be1cf5608ba9
aef69d48c864bcd72d15163897773d314187f6a9af350808719796
"@

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       WinRAR License Activator           " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Cai dat vao %APPDATA%\WinRAR
$appDataDir = Join-Path $env:APPDATA "WinRAR"
try {
    if (-not (Test-Path $appDataDir)) {
        New-Item -ItemType Directory -Path $appDataDir -Force | Out-Null
    }
    $appDataKey = Join-Path $appDataDir "rarreg.key"
    [System.IO.File]::WriteAllText($appDataKey, $keyData, [System.Text.Encoding]::ASCII)
    Write-Host "[+] Da cai dat key vao AppData: $appDataKey" -ForegroundColor Green
} catch {}

# Kiem tra quyen Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$programDirs = @(
    "${env:ProgramFiles}\WinRAR",
    "${env:ProgramFiles(x86)}\WinRAR"
)

try {
    $reg = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WinRAR" -ErrorAction SilentlyContinue).exe64
    if ($reg) { $programDirs += (Split-Path $reg) }
} catch {}

if (-not $isAdmin) {
    Write-Host "[*] Dang yeu cau quyen Administrator de cai vao Program Files..." -ForegroundColor Yellow
    try {
        $cmd = 'irm https://raw.githubusercontent.com/dat1799/DTrix-Winrar-License-Releases/main/activate.ps1 | iex'
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $cmd"
        return
    } catch {
        Write-Host "[-] Ban da huy yeu cau quyen Administrator." -ForegroundColor Red
        Write-Host "    Hay mo PowerShell voi quyen 'Run as administrator' de kich hoat hoan toan." -ForegroundColor Yellow
        return
    }
}

foreach ($dir in ($programDirs | Select-Object -Unique)) {
    if (Test-Path $dir) {
        $progKey = Join-Path $dir "rarreg.key"
        try {
            [System.IO.File]::WriteAllText($progKey, $keyData, [System.Text.Encoding]::ASCII)
            Write-Host "[+] Da cai dat key vao thu muc he thong: $progKey" -ForegroundColor Green
        } catch {}
    }
}

Write-Host "`n[✓] KICH HOAT WINRAR THANH CONG 100%!" -ForegroundColor Green
Write-Host "    Ban quyen: Unlimited Company License" -ForegroundColor Cyan
Write-Host "    Hay dong han WinRAR va mo lai -> Help -> About WinRAR de kiem tra." -ForegroundColor White

if ($isAdmin) {
    Start-Sleep -Seconds 3
}
