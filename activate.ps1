<#
.SYNOPSIS
    WinRAR License Activator
.DESCRIPTION
    Tự động cài đặt khóa bản quyền WinRAR (rarreg.key) hợp lệ cho người dùng.
    Không cần quyền Admin nếu cài vào AppData.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

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

$success = $false

# 1. Cài đặt vào %APPDATA%\WinRAR (Hoạt động cho người dùng hiện tại, không cần quyền Admin)
$appDataDir = Join-Path $env:APPDATA "WinRAR"
try {
    if (-not (Test-Path $appDataDir)) {
        New-Item -ItemType Directory -Path $appDataDir -Force | Out-Null
    }
    $appDataKey = Join-Path $appDataDir "rarreg.key"
    [System.IO.File]::WriteAllText($appDataKey, $keyData, [System.Text.Encoding]::ASCII)
    Write-Host "[+] Da cai dat key thanh cong tai: $appDataKey" -ForegroundColor Green
    $success = $true
} catch {
    Write-Host "[-] Loi ghi vao AppData: $_" -ForegroundColor Red
}

# 2. Cài đặt vào Program Files (Áp dụng cho mọi tài khoản máy tính nếu có quyền Admin)
$programDirs = @(
    "${env:ProgramFiles}\WinRAR",
    "${env:ProgramFiles(x86)}\WinRAR"
)

try {
    $reg = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WinRAR" -ErrorAction SilentlyContinue).exe64
    if ($reg) { $programDirs += (Split-Path $reg) }
} catch {}

foreach ($dir in ($programDirs | Select-Object -Unique)) {
    if (Test-Path $dir) {
        $progKey = Join-Path $dir "rarreg.key"
        try {
            [System.IO.File]::WriteAllText($progKey, $keyData, [System.Text.Encoding]::ASCII)
            Write-Host "[+] Da cai dat key vao thu muc he thong: $progKey" -ForegroundColor Green
            $success = $true
        } catch {
            # Bỏ qua nếu không có quyền Admin, vì AppData đã kích hoạt thành công cho user
        }
    }
}

if ($success) {
    Write-Host "`n[✓] Kich hoat WinRAR hoan tat thanh cong!" -ForegroundColor Green
    Write-Host "    WinRAR da duoc dang ky ban quyen (Unlimited Company License)." -ForegroundColor Cyan
    Write-Host "    Ban hay mo WinRAR -> Help -> About WinRAR de kiem tra nhe!" -ForegroundColor White
} else {
    Write-Host "`n[X] Co loi xay ra trong qua trinh cai dat key." -ForegroundColor Red
}
