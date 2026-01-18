# daily_push.ps1
# Usage:
#   Right click > Run with PowerShell
#   OR: powershell -ExecutionPolicy Bypass -File .\daily_push.ps1
# Optional:
#   .\daily_push.ps1 -Message "Update homepage content"

param(
    [string]$Message = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "=== Daily Push ===" -ForegroundColor Cyan
Write-Host "Folder: $(Get-Location)`n"

# 1) Verify git repo
try {
    git rev-parse --is-inside-work-tree | Out-Null
}
catch {
    Write-Host "ERROR: This folder is not a Git repository." -ForegroundColor Red
    Write-Host "Tip: Run 'git init' and set remote first." -ForegroundColor Yellow
    exit 1
}

# 2) Safety: block if any .env* files are TRACKED
$trackedEnv = git ls-files | Select-String -Pattern '^\.env' -SimpleMatch
if ($trackedEnv) {
    Write-Host "`nWARNING: Some .env* files are TRACKED by git. This can leak secrets." -ForegroundColor Yellow
    Write-Host "Fix: git rm --cached .env.local (or the file) then commit again." -ForegroundColor Yellow
    exit 1
}

# 3) Stage all changes
Write-Host "`n--- Staging changes ---" -ForegroundColor Cyan
git add -A

# 4) Check if there is anything staged
$staged = git diff --cached --name-only
if ([string]::IsNullOrWhiteSpace($staged)) {
    Write-Host "`nNothing staged to commit. Working tree clean or only ignored files changed." -ForegroundColor Green
    exit 0
}

# 5) Show status
Write-Host "`n--- Git Status ---" -ForegroundColor Cyan
git status

# 6) Commit message
if ([string]::IsNullOrWhiteSpace($Message)) {
    $inputMsg = Read-Host "Enter commit message (leave empty to auto-generate)"
    if ([string]::IsNullOrWhiteSpace($inputMsg)) {
        $Message = "Daily update - " + (Get-Date -Format "yyyy-MM-dd HH:mm")
    }
    else {
        $Message = $inputMsg
    }
}

Write-Host "`n--- Committing ---" -ForegroundColor Cyan
git commit -m "$Message"

# 7) Push current branch (safer than hardcoding main)
$branch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host "`n--- Pushing to origin/$branch ---" -ForegroundColor Cyan
git push -u origin $branch

Write-Host "`nDone. Pushed successfully." -ForegroundColor Green