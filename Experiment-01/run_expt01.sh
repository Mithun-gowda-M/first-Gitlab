#!/usr/bin/env bash
# ==============================================================================
# Experiment 01: Git Repository, Feature Branching, Stashing, and History Graph
# ==============================================================================
set -e

WORK_DIR="git-demo01"
echo "=== Starting Experiment 01 in directory: $WORK_DIR ==="

# Cleanup old directory if it exists
rm -rf "$WORK_DIR"

# 1. Create project folder and move into it
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# 2. Initialize an empty Git repository
git init

# 3. Configure author details (local to this repo)
git config user.name "Mithun-gowda-M"
git config user.email "mithunking55@gmail.com"

# 4. Rename default branch to 'main'
git branch -m main

# 5. Create demo01.txt with line 1
echo "line 1: Hi Bro" > demo01.txt

# 6. Stage demo01.txt
git add demo01.txt

# 7. Create root commit
git commit -m "Initial commit"

# 8. Create and switch to new branch 'Deepak'
git checkout -b Deepak

# 9. Append line 2 to demo01.txt
echo "line 2: Deepak branch is created" >> demo01.txt

# 10. Stage the change
git add demo01.txt

# 11. Commit line 2 on 'Deepak' branch
git commit -m "Deepak: add line 2"

# 12. Switch back to main branch
git checkout main

# 13. Demonstrate expected failure: merge non-existent branch
echo "--- Demonstrating expected failure: merging non-existent branch 'feature-edit' ---"
set +e
git merge --no-ff feature-edit -m "..." 2>&1 || true
set -e

# 14. Merge 'Deepak' branch into 'main' with a merge commit
git merge --no-ff Deepak -m "Merge Deepak to main branch"

# 15. Demonstrate expected failure: deleting non-existent branch
echo "--- Demonstrating expected failure: deleting non-existent branch 'feature-edit' ---"
set +e
git branch -d feature-edit 2>&1 || true
set -e

# 16. Delete the merged 'Deepak' branch
git branch -d Deepak

# 17. Add line 3 (temporary note)
echo "line 3: temp note" >> demo01.txt

# 18. Temporarily shelve the change with a label
git stash push -m "wip: temp note in demo01.txt"

# 19. Show saved stashes
echo "--- Stash list: ---"
git stash list

# 20. Restore the stashed change and remove it from stash list
git stash pop

# 21. Stage the restored change
git add demo01.txt

# 22. Commit line 3 on main
git commit -m "Apply stashed temp note"

# 23. Show compact commit history as a branch graph
echo "--- Commit history graph: ---"
git log --oneline --graph --all --decorate

# 24. Display final file contents
echo "--- demo01.txt contents: ---"
cat demo01.txt

cd ..
echo "=== Experiment 01 completed successfully! ==="
