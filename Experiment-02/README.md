# Experiment 02: Remote Repository Operations, Branching, Push/Pull & Merging

## 🎯 Aim / Objective
Clone a remote GitHub repository, create a new branch, add and commit a file, push the branch to GitHub, merge it into `main` with a merge commit, push `main`, and pull the latest changes.

---

## 📸 Lab Manual Pages Reference
- **Page 4:** `images/04_Expt02_Page04.jpeg`
- **Page 5:** `images/05_Expt02_Page05.jpeg`
- **Page 6:** `images/06_Expt02_Page06.jpeg`

---

## 📋 Step-by-Step Execution & Command Explanations

### Step 1: Check Git Settings & Demonstrate Clone Edge Cases
```bash
git config --list
```
Demonstrating common clone edge cases:
1. **Cloning an empty remote repository:**
   ```bash
   git clone <remote_empty_url> prog02
   # Warning output: warning: You appear to have cloned an empty repository.
   ```
2. **Directory collision (directory already exists and contains files):**
   ```bash
   git clone <remote_url> prog02
   # Error output: fatal: destination path 'prog02' already exists and is not an empty directory.
   ```

### Step 2: Clone Target Repository
```bash
git clone <remote_url> program02
cd program02
```
* **Explanation:** Downloads the full object store and checks out the default branch.

### Step 3: Create and Switch to Feature Branch
```bash
git checkout -b deepak
```
* **Explanation:** Creates and switches to a feature branch named `deepak`.

### Step 4: Add New File & Commit
```bash
echo "Hi, I am from branch deepak" > democlass.txt
git add democlass.txt
git commit -m "Add new file to deepak"
```
* **Explanation:** Adds and commits `democlass.txt` onto branch `deepak`.

### Step 5: Check Remote URLs & Push with Upstream Tracking
```bash
git remote -v
git push -u origin deepak
```
* **Explanation:** 
  - `git remote -v` lists configured fetch and push URLs.
  - `-u` (or `--set-upstream`) links local branch `deepak` to remote branch `origin/deepak`.

### Step 6: Local Rebase & Safe Force-Push Demonstration
```bash
git rebase deepak
git switch main
git push --force-with-lease origin deepak
```
* **Explanation:** 
  - `git rebase deepak` rebases onto itself (no-op, "Already up to date").
  - `--force-with-lease` is a safe alternative to `--force` that ensures nobody else has updated the remote branch before overwriting.

### Step 7: Merge Feature Branch into Main
```bash
git merge --no-ff deepak -m "Merge deepak into main"
```
* **Explanation:** Explicit non-fast-forward merge recording the branch integration history.

### Step 8: Push Main & Observe Non-Fast-Forward Rejection
```bash
git push origin main
```
* **Expected Output:**
  ```text
  ! [rejected]        main -> main (fetch first)
  error: failed to push some refs to '...'
  hint: Updates were rejected because the remote contains work that you do not
  hint: have locally. This is usually caused by another repository pushing to
  hint: the same ref. If you want to integrate the remote changes, use
  hint: 'git pull' before pushing again.
  ```
* **Explanation:** The remote `main` branch has received commits that are not present in your local branch (e.g. 2 PDF documentation files uploaded on GitHub). Git protects your repository against accidental history loss.

### Step 9: Pull and Integrate Remote Changes
```bash
git pull origin main --allow-unrelated-histories --no-rebase
```
* **Explanation:** 
  - `--allow-unrelated-histories` allows merging two independent commit trees with different root commits.
  - `--no-rebase` creates a standard 3-way merge commit integrating remote changes.

### Step 10: Push Merged Main to Remote
```bash
git push origin main
```
* **Explanation:** Pushes the merged commit to GitHub successfully.

### Step 11: Verify Repository Status
```bash
git pull origin main
# Output: Already up to date.
```

---

## 📊 Expected Output & Verification

### Final Commit Graph on `main`:
```text
*   49a7094 (HEAD -> main, origin/main, origin/HEAD) Merge branch 'main' of ...
|\  
| * d12effd Upload 2 PDF files from GitHub
* |   a8b6ebe Merge deepak into main
|\ \  
| |/  
|/|   
| * f3c3e07 (origin/deepak, deepak) Add new file to deepak
|/  
* 846ecd6 Initial commit on remote
```

---

## 🚀 How to Run the Automated Script

### On Linux / macOS / Git Bash:
```bash
chmod +x run_expt02.sh
./run_expt02.sh
```

### On Windows PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File .\run_expt02.ps1
```
