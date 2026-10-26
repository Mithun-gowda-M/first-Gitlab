# ==============================================================================
# Experiment 02: Remote Repository Cloning, Branching, Push/Pull & Merging
# ==============================================================================
$ErrorActionPreference = "Continue"

$BaseDir = Join-Path -Path $PSScriptRoot -ChildPath "expt02_sandbox"
if (Test-Path $BaseDir) {
    Remove-Item -Recurse -Force $BaseDir
}
New-Item -ItemType Directory -Path $BaseDir | Out-Null

Write-Host "=== Starting Experiment 02 in: $BaseDir ===" -ForegroundColor Cyan

try {
    # 1. Setup Simulated Remote Repository (bare repo)
    Write-Host "`n--- 1. Setting up Simulated Remote Repository (remote.git) ---" -ForegroundColor Green
    Set-Location $BaseDir
    git init --bare remote.git
    git -C remote.git symbolic-ref HEAD refs/heads/main

    # Populate remote initially (e.g. initial repository state with README)
    git clone remote.git temp_seed
    Set-Location (Join-Path $BaseDir "temp_seed")
    git config user.name "Mithun-gowda-M"
    git config user.email "mithunking55@gmail.com"
    git branch -m main
    Set-Content -Path "README.md" -Value "# Program 02 Repository"
    git add README.md
    git commit -m "Initial commit on remote"
    git push origin main
    Set-Location $BaseDir
    Remove-Item -Recurse -Force temp_seed

    # 2. Demonstrate Empty Repo Warning and Directory Exists Error (Notebook Page 4)
    Write-Host "`n--- 2. Demonstrating Clone Behaviors ---" -ForegroundColor Yellow
    git init --bare empty_prog02.git
    Write-Host "Demonstrating clone of empty repo:"
    & git clone empty_prog02.git prog02 2>&1 | Out-String | Write-Host

    Write-Host "Demonstrating failed clone when folder already exists and isn't empty:"
    & git clone remote.git prog02 2>&1 | Out-String | Write-Host

    # 3. Clone the correct repository (program02)
    Write-Host "`n--- 3. Cloning Target Repository (program02) ---" -ForegroundColor Green
    git clone remote.git program02
    Set-Location (Join-Path $BaseDir "program02")
    git config user.name "Mithun-gowda-M"
    git config user.email "mithunking55@gmail.com"

    # 4. Create and Switch to New Branch 'deepak'
    Write-Host "`n--- 4. Creating & Switching to Branch 'deepak' ---" -ForegroundColor Green
    git checkout -b deepak

    # 5. Create new file on this branch
    Write-Host "`n--- 5. Adding democlass.txt and Committing ---" -ForegroundColor Green
    Set-Content -Path "democlass.txt" -Value "Hi, I am from branch deepak"
    git add democlass.txt
    git commit -m "Add new file to deepak"

    # 6. Verify Remote URLs
    Write-Host "`n--- 6. Remote URLs: ---" -ForegroundColor Green
    git remote -v

    # 7. Push 'deepak' branch to remote with upstream tracking
    Write-Host "`n--- 7. Pushing 'deepak' to Remote (-u origin deepak) ---" -ForegroundColor Green
    git push -u origin deepak

    # 8. Rebase onto itself
    Write-Host "`n--- 8. Rebase onto itself (Already up to date) ---" -ForegroundColor Green
    git rebase deepak

    # 9. Switch back to main branch
    Write-Host "`n--- 9. Switching to 'main' ---" -ForegroundColor Green
    git switch main

    # 10. Safe force-push of deepak
    Write-Host "`n--- 10. Safe Force Push (--force-with-lease) ---" -ForegroundColor Green
    git push --force-with-lease origin deepak

    # 11. Merge deepak into main with a merge commit
    Write-Host "`n--- 11. Merging 'deepak' into 'main' with --no-ff ---" -ForegroundColor Green
    git merge --no-ff deepak -m "Merge deepak into main"

    # 12. Simulate GitHub receiving independent commits from remote collaborator (e.g. 2 PDF files)
    Write-Host "`n--- 12. Simulating Remote Receiving Independent Commits ---" -ForegroundColor Green
    Set-Location $BaseDir
    git clone remote.git remote_collaborator
    Set-Location (Join-Path $BaseDir "remote_collaborator")
    git config user.name "Collaborator"
    git config user.email "collaborator@example.com"
    Set-Content -Path "lab_syllabus_part1.pdf" -Value "PDF dummy content 1"
    Set-Content -Path "lab_syllabus_part2.pdf" -Value "PDF dummy content 2"
    git add lab_syllabus_part1.pdf lab_syllabus_part2.pdf
    git commit -m "Upload 2 PDF files from GitHub"
    git push origin main
    Set-Location $BaseDir
    Remove-Item -Recurse -Force remote_collaborator

    # 13. Back in local repo: Try pushing (Demonstrating expected rejection)
    Set-Location (Join-Path $BaseDir "program02")
    Write-Host "`n--- 13. Demonstrating Push Rejection (Remote has new commits) ---" -ForegroundColor Yellow
    & git push origin main 2>&1 | Out-String | Write-Host

    # 14. Fetch and merge remote changes using --allow-unrelated-histories --no-rebase
    Write-Host "`n--- 14. Pulling with --allow-unrelated-histories --no-rebase ---" -ForegroundColor Green
    $env:GIT_MERGE_AUTOEDIT = "no"
    git pull origin main --allow-unrelated-histories --no-rebase

    # 15. Push merged main to remote
    Write-Host "`n--- 15. Pushing Merged 'main' to Remote ---" -ForegroundColor Green
    git push origin main

    # 16. Check for updates
    Write-Host "`n--- 16. Checking for Updates ---" -ForegroundColor Green
    git pull origin main

    Write-Host "`n--- Final History Graph on 'main' ---" -ForegroundColor Green
    git log --oneline --graph --decorate -6

    Write-Host "`n=== Experiment 02 Completed Successfully! ===" -ForegroundColor Cyan
} finally {
    Set-Location $PSScriptRoot
    if (Test-Path $BaseDir) {
        Remove-Item -Recurse -Force $BaseDir -ErrorAction SilentlyContinue
    }
}
