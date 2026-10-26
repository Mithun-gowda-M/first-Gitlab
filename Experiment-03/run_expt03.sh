#!/usr/bin/env bash
# ==============================================================================
# Experiment 03: Git Release Management, Cherry-Picking, Reverting & Tagging
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$SCRIPT_DIR/git-release-demo"
REMOTE_DIR="$SCRIPT_DIR/remote.git"

echo "=== Starting Experiment 03 in: $WORK_DIR ==="

# Cleanup old directories
rm -rf "$WORK_DIR" "$REMOTE_DIR"

# 1. Create project folder and move into it
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# 2. Initialize repo with 'main' as default branch
git init -b main

# 3. Configure author details locally
git config user.name "Mithun-gowda-M"
git config user.email "mithunking55@gmail.com"

# 4. Commit A: Root commit
echo "app v1" > app.txt
git add .
git commit -m "A: initial commit"

# 5. Commit B: Adds base feature
echo "base feature" > feature.txt
git add .
git commit -m "B: add base feature"

# 6. Create release branch pointing at commit B (without switching)
git branch release/1.x

# 7. Main branch bug fixes and faulty commit
echo "fix C" > fixC.txt && git add . && git commit -m "C: fix login bug"
echo "fix D" > fixD.txt && git add . && git commit -m "D: fix crash on startup"
echo "fix E" > fixE.txt && git add . && git commit -m "E: fix typo in API"
echo "BROKEN" > broken.txt && git add . && git commit -m "F: faulty change"

# 8. Extract commit hashes
B=$(git rev-parse main~4)
C=$(git rev-parse main~3)
F=$(git rev-parse main)

echo "--- Extracted Hashes: ---"
echo "B=$B"
echo "C=$C"
echo "F=$F"

# 9. View commit history graph
echo "--- Commit History Graph: ---"
git log --oneline --graph --all

# 10. Switch to release/1.x branch
git switch release/1.x

# 11. Tag current commit (B) as release v1.0.0
git tag v1.0.0
echo "--- Tags matching v1.*: ---"
git tag -l "v1.*"

# 12. Show tagged commit details
echo "--- Tag Details for v1.0.0: ---"
git show v1.0.0 --stat

# 13. Compare commits between release/1.x and main
echo "--- Commits in main not in release/1.x: ---"
git log --oneline release/1.x..main

echo "--- git cherry comparison (+ means missing in release): ---"
git cherry -v release/1.x main

# 14. Cherry-pick commits after B up to F onto release/1.x
echo "--- Cherry-picking range \$B..\$F (-x records original hash) ---"
git cherry-pick -x $B..$F

# 15. View release history and list files
echo "--- Release history after cherry-pick: ---"
git log --oneline --decorate
echo "Files present (broken.txt included):"
ls

# 16. Find the faulty commit hash
FAULTY=$(git log --grep="F: faulty" --format=%h -1)
echo "Faulty commit hash on release branch: $FAULTY"

# 17. Revert faulty commit
echo "--- Reverting faulty commit: $FAULTY ---"
git revert --no-edit $FAULTY

echo "--- Last 3 commits after revert: ---"
git log --oneline -3

echo "Files present (broken.txt should be gone):"
ls

# 18. Tag the patched release as v1.0.1
git tag v1.0.1

echo "--- Full graph history on release/1.x with tags: ---"
git log --oneline --decorate --graph -8

echo "--- Tags in repository: ---"
git tag -l "v1.*"

# 19. Create bare remote repository
echo "--- Setting up bare remote repository ---"
git init --bare "$REMOTE_DIR"
git remote add origin "$REMOTE_DIR"

# 20. Push branches to remote
echo "--- Pushing branches to remote ---"
git push origin main release/1.x

# 21. Push tags to remote
echo "--- Pushing tags to remote ---"
git push origin v1.0.0 v1.0.1

# 22. Verify tags on remote
echo "--- Verifying tags on remote via ls-remote: ---"
git ls-remote --tags origin

# 23. Demonstrate revert simulation and abort (Notebook Page 12)
echo "--- Demonstrating revert simulation & abort ---"
git revert --no-commit HEAD~2..HEAD || true
git status
git revert --abort

cd "$SCRIPT_DIR"
rm -rf "$WORK_DIR" "$REMOTE_DIR"
echo "=== Experiment 03 completed successfully! ==="
