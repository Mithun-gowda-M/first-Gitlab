# ==============================================================================
# Experiment 03: Git Release Management, Cherry-Picking, Reverting & Tagging
# ==============================================================================
$ErrorActionPreference = "Continue"

$WorkDir = Join-Path -Path $PSScriptRoot -ChildPath "git-release-demo"
$RemoteDir = Join-Path -Path $PSScriptRoot -ChildPath "remote.git"

if (Test-Path $WorkDir) {
    Remove-Item -Recurse -Force $WorkDir -ErrorAction SilentlyContinue
}
if (Test-Path $RemoteDir) {
    Remove-Item -Recurse -Force $RemoteDir -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $WorkDir | Out-Null
Set-Location $WorkDir

Write-Host "=== Starting Experiment 03 in: $WorkDir ===" -ForegroundColor Cyan

try {
    # 1. Initialize repository with 'main' branch
    git init -b main

    # 2. Configure user identity locally
    git config user.name "Mithun-gowda-M"
    git config user.email "mithunking55@gmail.com"

    # 3. Commit A: Root commit
    Set-Content -Path "app.txt" -Value "app v1"
    git add .
    git commit -m "A: initial commit"

    # 4. Commit B: Adds base feature
    Set-Content -Path "feature.txt" -Value "base feature"
    git add .
    git commit -m "B: add base feature"

    # 5. Create release branch pointing at commit B (without switching)
    git branch release/1.x

    # 6. Main branch bug fixes and faulty commit
    Set-Content -Path "fixC.txt" -Value "fix C"
    git add . ; git commit -m "C: fix login bug"

    Set-Content -Path "fixD.txt" -Value "fix D"
    git add . ; git commit -m "D: fix crash on startup"

    Set-Content -Path "fixE.txt" -Value "fix E"
    git add . ; git commit -m "E: fix typo in API"

    Set-Content -Path "broken.txt" -Value "BROKEN"
    git add . ; git commit -m "F: faulty change"

    # 7. Extract commit hashes
    $B = (git rev-parse main~4).Trim()
    $C = (git rev-parse main~3).Trim()
    $F = (git rev-parse main).Trim()

    Write-Host "`n--- Extracted Hashes: ---" -ForegroundColor Green
    Write-Host "B=$B"
    Write-Host "C=$C"
    Write-Host "F=$F"

    # 8. View commit history graph
    Write-Host "`n--- Commit History Graph: ---" -ForegroundColor Green
    git log --oneline --graph --all

    # 9. Switch to release/1.x branch
    Write-Host "`n--- Switching to release/1.x ---" -ForegroundColor Green
    git switch release/1.x

    # 10. Tag current commit (B) as release v1.0.0
    git tag v1.0.0
    Write-Host "`n--- Tags matching v1.*: ---" -ForegroundColor Green
    git tag -l "v1.*"

    # 11. Show tagged commit details
    Write-Host "`n--- Tag Details for v1.0.0: ---" -ForegroundColor Green
    git show v1.0.0 --stat

    # 12. Compare commits between release/1.x and main
    Write-Host "`n--- Commits in main not in release/1.x: ---" -ForegroundColor Green
    git log --oneline release/1.x..main

    Write-Host "`n--- git cherry comparison (+ means missing in release): ---" -ForegroundColor Green
    git cherry -v release/1.x main

    # 13. Cherry-pick commits after B up to F onto release/1.x
    Write-Host "`n--- Cherry-picking range `$B..`$F (-x records original hash) ---" -ForegroundColor Green
    git cherry-pick -x "$B..$F"

    # 14. View release history and list files
    Write-Host "`n--- Release history after cherry-pick: ---" -ForegroundColor Green
    git log --oneline --decorate
    Write-Host "`nFiles present (broken.txt included):"
    Get-ChildItem -Name

    # 15. Find the faulty commit hash
    $FAULTY = (git log --grep="F: faulty" --format=%h -1).Trim()
    Write-Host "`nFaulty commit hash on release branch: $FAULTY" -ForegroundColor Yellow

    # 16. Revert faulty commit
    Write-Host "`n--- Reverting faulty commit: $FAULTY ---" -ForegroundColor Green
    git revert --no-edit $FAULTY

    Write-Host "`n--- Last 3 commits after revert: ---" -ForegroundColor Green
    git log --oneline -3

    Write-Host "`nFiles present (broken.txt should be gone):"
    Get-ChildItem -Name

    # 17. Tag the patched release as v1.0.1
    git tag v1.0.1

    Write-Host "`n--- Full graph history on release/1.x with tags: ---" -ForegroundColor Green
    git log --oneline --decorate --graph -8

    Write-Host "`n--- Tags in repository: ---" -ForegroundColor Green
    git tag -l "v1.*"

    # 18. Create bare remote repository
    Write-Host "`n--- Setting up bare remote repository ---" -ForegroundColor Green
    git init --bare $RemoteDir
    git remote add origin $RemoteDir

    # 19. Push branches to remote
    Write-Host "`n--- Pushing branches to remote ---" -ForegroundColor Green
    git push origin main release/1.x

    # 20. Push tags to remote
    Write-Host "`n--- Pushing tags to remote ---" -ForegroundColor Green
    git push origin v1.0.0 v1.0.1

    # 21. Verify tags on remote
    Write-Host "`n--- Verifying tags on remote via ls-remote: ---" -ForegroundColor Green
    git ls-remote --tags origin

    # 22. Demonstrate revert simulation and abort (Notebook Page 12)
    Write-Host "`n--- Demonstrating revert simulation & abort ---" -ForegroundColor Yellow
    & git revert --no-commit HEAD~2..HEAD 2>&1 | Out-String | Write-Host
    git status
    git revert --abort

    Write-Host "`n=== Experiment 03 Completed Successfully! ===" -ForegroundColor Cyan
} finally {
    Set-Location $PSScriptRoot
    if (Test-Path $WorkDir) {
        Remove-Item -Recurse -Force $WorkDir -ErrorAction SilentlyContinue
    }
    if (Test-Path $RemoteDir) {
        Remove-Item -Recurse -Force $RemoteDir -ErrorAction SilentlyContinue
    }
}
