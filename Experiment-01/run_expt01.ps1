# ==============================================================================
# Experiment 01: Git Repository, Feature Branching, Stashing, and History Graph
# ==============================================================================
$ErrorActionPreference = "Stop"

$WorkDir = Join-Path -Path $PSScriptRoot -ChildPath "git-demo01"
if (Test-Path $WorkDir) {
    Remove-Item -Recurse -Force $WorkDir
}

Write-Host "=== Starting Experiment 01 in: $WorkDir ===" -ForegroundColor Cyan

# 1. Create directory and move into it
New-Item -ItemType Directory -Path $WorkDir | Out-Null
Set-Location $WorkDir

try {
    # 2. Initialize Git repository
    git init

    # 3. Configure author details locally
    git config user.name "Mithun-gowda-M"
    git config user.email "mithunking55@gmail.com"

    # 4. Rename default branch to main
    git branch -m main

    # 5. Create demo01.txt with line 1
    Set-Content -Path "demo01.txt" -Value "line 1: Hi Bro"

    # 6. Stage demo01.txt
    git add demo01.txt

    # 7. Initial commit
    git commit -m "Initial commit"

    # 8. Create and switch to new branch 'Deepak'
    git checkout -b Deepak

    # 9. Append line 2 to demo01.txt
    Add-Content -Path "demo01.txt" -Value "line 2: Deepak branch is created"

    # 10. Stage change
    git add demo01.txt

    # 11. Commit line 2 on Deepak branch
    git commit -m "Deepak: add line 2"

    # 12. Switch back to main branch
    git checkout main

    # 13. Demonstrate expected failure: merge non-existent branch
    Write-Host "`n--- Demonstrating expected failure: merge non-existent branch ---" -ForegroundColor Yellow
    try {
        & git merge --no-ff feature-edit -m "..." 2>&1 | Out-String | Write-Host
    } catch {
        Write-Host "Caught expected error: $($_.Exception.Message)"
    }

    # 14. Merge Deepak branch into main with a merge commit
    git merge --no-ff Deepak -m "Merge Deepak to main branch"

    # 15. Demonstrate expected failure: deleting non-existent branch
    Write-Host "`n--- Demonstrating expected failure: delete non-existent branch ---" -ForegroundColor Yellow
    try {
        & git branch -d feature-edit 2>&1 | Out-String | Write-Host
    } catch {
        Write-Host "Caught expected error: $($_.Exception.Message)"
    }

    # 16. Delete merged branch
    git branch -d Deepak

    # 17. Add line 3 (temporary note)
    Add-Content -Path "demo01.txt" -Value "line 3: temp note"

    # 18. Stash the change with a message
    git stash push -m "wip: temp note in demo01.txt"

    # 19. Show saved stashes
    Write-Host "`n--- Saved Stashes: ---" -ForegroundColor Green
    git stash list

    # 20. Pop the stash
    git stash pop

    # 21. Stage the restored change
    git add demo01.txt

    # 22. Commit line 3 on main
    git commit -m "Apply stashed temp note"

    # 23. Show compact commit history graph
    Write-Host "`n--- Commit Graph: ---" -ForegroundColor Green
    git log --oneline --graph --all --decorate

    # 24. Display file contents
    Write-Host "`n--- Final demo01.txt Content: ---" -ForegroundColor Green
    Get-Content "demo01.txt"

    Write-Host "`n=== Experiment 01 Completed Successfully! ===" -ForegroundColor Cyan
} finally {
    Set-Location $PSScriptRoot
}
