# Experiment 03: Git Release Management, Cherry-Picking, Reverting & Tagging

## 🎯 Aim / Objective
Demonstrate Git release management using tagging, cherry-picking, and reverting:
1. Create a repository with commits `A` to `F` on `main` (where `C`, `D`, `E` are bug fixes and `F` is a faulty commit).
2. Create branch `release/1.x` at commit `B` and tag it as `v1.0.0`.
3. Compare missing commits between `release/1.x` and `main` using `git log` and `git cherry -v`.
4. Cherry-pick commits `C` through `F` onto `release/1.x` using the `-x` flag.
5. Identify and revert the faulty commit `F` without interactive editing (`git revert --no-edit`).
6. Tag the fixed release as `v1.0.1`.
7. Push both branches (`main`, `release/1.x`) and both tags (`v1.0.0`, `v1.0.1`) to a remote bare repository.
8. Verify tags on the remote using `git ls-remote --tags origin`.
9. Demonstrate `git revert --no-commit` and `git revert --abort`.

---

## 📸 Lab Manual Pages Reference
- **Page 7:** `images/07_Expt03_Page07.jpeg` (Expt 3 Problem Statement & Commit A)
- **Page 8:** `images/08_Expt03_Page08.jpeg` (Commit B, release/1.x branch, Commits C, D, E, F)
- **Page 9:** `images/09_Expt03_Page09.jpeg` (rev-parse hashes, graph log, tag v1.0.0)
- **Page 10:** `images/10_Expt03_Page10.jpeg` (cherry comparison, cherry-pick range B..F, faulty hash)
- **Page 11:** `images/11_Expt03_Page11.jpeg` (git revert, tag v1.0.1, bare remote, push branches)
- **Page 12:** `images/12_Expt03_Page12.jpeg` (push tags, ls-remote, revert --no-commit, revert --abort)
- **Page 13:** `images/13_Expt03_Page13.jpeg` (cleanup)

---

## 📋 Step-by-Step Execution & Command Explanations

### Step 1: Create Project & Setup Commits A to F on Main
```bash
mkdir git-release-demo && cd git-release-demo
git init -b main
git config user.name "Mithun-gowda-M"
git config user.email "mithunking55@gmail.com"

# Commit A: Root Commit
echo "app v1" > app.txt && git add . && git commit -m "A: initial commit"

# Commit B: Base Feature
echo "base feature" > feature.txt && git add . && git commit -m "B: add base feature"

# Create release branch at Commit B without switching
git branch release/1.x

# Commit C, D, E (Bug fixes) and F (Faulty commit) on main
echo "fix C" > fixC.txt && git add . && git commit -m "C: fix login bug"
echo "fix D" > fixD.txt && git add . && git commit -m "D: fix crash on startup"
echo "fix E" > fixE.txt && git add . && git commit -m "E: fix typo in API"
echo "BROKEN" > broken.txt && git add . && git commit -m "F: faulty change"
```

### Step 2: Save Hashes Using `git rev-parse`
```bash
B=$(git rev-parse main~4)
C=$(git rev-parse main~3)
F=$(git rev-parse main)
echo "B=$B"
echo "C=$C"
echo "F=$F"
```
* **Explanation:** `git rev-parse` resolves revision parameters (like relative references `main~4`) into their full 40-character SHA-1 hashes.

### Step 3: Switch to Release Branch & Tag `v1.0.0`
```bash
git switch release/1.x
git tag v1.0.0
git tag -l "v1.*"
git show v1.0.0 --stat
```
* **Explanation:** `release/1.x` currently points to commit `B`. Creating tag `v1.0.0` marks this stable release snapshot.

### Step 4: Compare Commits Between `release/1.x` and `main`
```bash
git log --oneline release/1.x..main
git cherry -v release/1.x main
```
* **Explanation:** 
  - `release/1.x..main` lists all commits reachable from `main` but not from `release/1.x` (C, D, E, F).
  - `git cherry -v` compares changes; `+` indicates commits in `main` that have not yet been applied to `release/1.x`.

### Step 5: Cherry-Pick Commit Range onto Release Branch
```bash
git cherry-pick -x $B..$F
```
* **Explanation:** 
  - Cherry-picks each commit in the range `(B, F]` (i.e. C, D, E, and F) onto `release/1.x`.
  - The `-x` flag automatically appends `(cherry picked from commit <hash>)` to each commit message, preserving provenance.

### Step 6: Identify & Revert the Faulty Commit
```bash
# Find faulty commit hash dynamically:
FAULTY=$(git log --grep="F: faulty" --format=%h -1)
echo "Faulty commit: $FAULTY"

# Revert commit:
git revert --no-edit $FAULTY
```
* **Explanation:** 
  - `git revert` creates a new commit that applies the exact inverse diff of the target commit.
  - Unlike `git reset`, `git revert` is completely safe for public branches because it does not rewrite history.
  - After revert, `broken.txt` is removed.

### Step 7: Tag Patched Release as `v1.0.1`
```bash
git tag v1.0.1
git log --oneline --decorate --graph -8
git tag -l "v1.*"
```

### Step 8: Setup Remote Repository & Push Branches and Tags
```bash
# Initialize bare remote repo:
git init --bare ../remote.git
git remote add origin ../remote.git

# Push both branches:
git push origin main release/1.x

# Push tags:
git push origin v1.0.0 v1.0.1

# Verify tags on remote:
git ls-remote --tags origin
```

### Step 9: Revert Simulation and Abort Demonstration
```bash
# Start reverting last 2 commits without committing:
git revert --no-commit HEAD~2..HEAD
git status
# Cancel and abort revert, restoring previous state:
git revert --abort
```

---

## 📊 Expected Output & Verification

### Commit Graph on `release/1.x`:
```text
* 93e9ddb (HEAD -> release/1.x, tag: v1.0.1) Revert "F: faulty change"
* 676eb4d F: faulty change
* 8ee0ec2 E: fix typo in API
* b979109 D: fix crash on startup
* f7403f2 C: fix login bug
* 8e26638 (tag: v1.0.0) B: add base feature
* cb1945e A: initial commit
```

### Remote Tags Verification (`git ls-remote --tags origin`):
```text
8e26638f59bc90a0eff133c0e60abc6b54e26ebb	refs/tags/v1.0.0
93e9ddb6119ad7c4b47fbd27992140a38a86bc11	refs/tags/v1.0.1
```

---

## 🚀 How to Run the Automated Script

### On Linux / macOS / Git Bash:
```bash
chmod +x run_expt03.sh
./run_expt03.sh
```

### On Windows PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File .\run_expt03.ps1
```
