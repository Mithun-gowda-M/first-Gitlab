#!/usr/bin/env bash
# ==============================================================================
# Experiment 02: Remote Repository Cloning, Branching, Push/Pull & Merging
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/expt02_sandbox"

echo "=== Starting Experiment 02 in: $BASE_DIR ==="

rm -rf "$BASE_DIR"
mkdir -p "$BASE_DIR"

# 1. Setup Simulated Remote Repository (bare repo)
echo "--- 1. Setting up Simulated Remote Repository (remote.git) ---"
cd "$BASE_DIR"
git init --bare remote.git
git -C remote.git symbolic-ref HEAD refs/heads/main

# Populate remote initially (initial commit with README)
git clone remote.git temp_seed
cd temp_seed
git config user.name "Mithun-gowda-M"
git config user.email "mithunking55@gmail.com"
git branch -m main
echo "# Program 02 Repository" > README.md
git add README.md
git commit -m "Initial commit on remote"
git push origin main
cd ..
rm -rf temp_seed

# 2. Demonstrate Empty Repo Warning and Directory Exists Error (Notebook Page 4)
echo "--- 2. Demonstrating Clone Behaviors ---"
git init --bare empty_prog02.git
set +e
echo "Demonstrating clone of empty repo:"
git clone empty_prog02.git prog02 2>&1 || true

echo "Demonstrating failed clone when folder already exists and isn't empty:"
git clone remote.git prog02 2>&1 || true
set -e

# 3. Clone the correct repository (program02)
echo "--- 3. Cloning Target Repository (program02) ---"
git clone remote.git program02
cd program02
git config user.name "Mithun-gowda-M"
git config user.email "mithunking55@gmail.com"

# 4. Create and Switch to New Branch 'deepak'
echo "--- 4. Creating & Switching to Branch 'deepak' ---"
git checkout -b deepak

# 5. Create new file on this branch
echo "--- 5. Adding democlass.txt and Committing ---"
echo "Hi, I am from branch deepak" > democlass.txt
git add democlass.txt
git commit -m "Add new file to deepak"

# 6. Verify Remote URLs
echo "--- 6. Remote URLs: ---"
git remote -v

# 7. Push 'deepak' branch to remote with upstream tracking
echo "--- 7. Pushing 'deepak' to Remote (-u origin deepak) ---"
git push -u origin deepak

# 8. Rebase onto itself
echo "--- 8. Rebase onto itself (Already up to date) ---"
git rebase deepak

# 9. Switch back to main branch
echo "--- 9. Switching to 'main' ---"
git switch main

# 10. Safe force-push of deepak
echo "--- 10. Safe Force Push (--force-with-lease) ---"
git push --force-with-lease origin deepak

# 11. Merge deepak into main with a merge commit
echo "--- 11. Merging 'deepak' into 'main' with --no-ff ---"
git merge --no-ff deepak -m "Merge deepak into main"

# 12. Simulate GitHub receiving independent commits (e.g. 2 PDF files from another collaborator)
echo "--- 12. Simulating Remote Receiving Independent Commits ---"
cd "$BASE_DIR"
git clone remote.git remote_collaborator
cd remote_collaborator
git config user.name "Collaborator"
git config user.email "collaborator@example.com"
echo "PDF dummy content 1" > lab_syllabus_part1.pdf
echo "PDF dummy content 2" > lab_syllabus_part2.pdf
git add lab_syllabus_part1.pdf lab_syllabus_part2.pdf
git commit -m "Upload 2 PDF files from GitHub"
git push origin main
cd ..
rm -rf remote_collaborator

# 13. Back in local repo: Try pushing (Demonstrating expected rejection)
cd "$BASE_DIR/program02"
echo "--- 13. Demonstrating Push Rejection (Remote has new commits) ---"
set +e
git push origin main 2>&1 || true
set -e

# 14. Fetch and merge remote changes using --allow-unrelated-histories --no-rebase
echo "--- 14. Pulling with --allow-unrelated-histories --no-rebase ---"
GIT_MERGE_AUTOEDIT=no git pull origin main --allow-unrelated-histories --no-rebase

# 15. Push merged main to remote
echo "--- 15. Pushing Merged 'main' to Remote ---"
git push origin main

# 16. Check for updates
echo "--- 16. Checking for Updates ---"
git pull origin main

echo "--- Final History Graph on 'main' ---"
git log --oneline --graph --decorate -6

cd "$SCRIPT_DIR"
rm -rf "$BASE_DIR"
echo "=== Experiment 02 completed successfully! ==="
