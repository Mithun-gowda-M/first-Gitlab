# Experiment 01: Git Repository, Feature Branching, Stashing, and History Graph

## 🎯 Aim / Objective
Create a Git repository and demonstrate the following:
1. Initialize an empty Git repository and configure user identity.
2. Create and commit a file (`demo01.txt`).
3. Create a feature branch (`Deepak`), modify the file, and commit.
4. Merge the feature branch into `main` using a non-fast-forward merge (`--no-ff`).
5. Delete the merged feature branch.
6. Use `git stash` to shelve and restore temporary changes.
7. Display the compact commit history as a graph.

---

## 📸 Lab Manual Pages Reference
- **Page 1:** `images/01_Expt01_Page01.jpeg`
- **Page 2:** `images/02_Expt01_Page02.jpeg`
- **Page 3:** `images/03_Expt01_Page03.jpeg`

---

## 📋 Step-by-Step Execution & Command Explanations

### Step 1: Create Project Directory & Initialize Git
```bash
mkdir git-demo01
cd git-demo01
git init
```
* **Explanation:** `git init` creates an empty `.git` subdirectory containing metadata, object store, and ref pointers.

### Step 2: Configure User Identity
```bash
git config user.name "Mithun-gowda-M"
git config user.email "mithunking55@gmail.com"
```
* **Explanation:** Sets author attribution for commits created inside this repository.

### Step 3: Set Default Branch Name to Main
```bash
git branch -m main
```
* **Explanation:** Renames the default branch from `master` to `main`.

### Step 4: Create and Commit Root File
```bash
echo "line 1: Hi Bro" > demo01.txt
git add demo01.txt
git commit -m "Initial commit"
```
* **Explanation:** 
  - `git add` stages `demo01.txt` into the index. (On Windows, a harmless LF to CRLF line-ending warning may be displayed).
  - `git commit` creates the root commit (Commit A) snapshot in the Git object database.

### Step 5: Create and Switch to Feature Branch
```bash
git checkout -b Deepak
```
* **Explanation:** Creates a new branch named `Deepak` pointing to the current commit and updates `HEAD` to point to it.

### Step 6: Work on Feature Branch and Commit
```bash
echo "line 2: Deepak branch is created" >> demo01.txt
git add demo01.txt
git commit -m "Deepak: add line 2"
```
* **Explanation:** Appends line 2 to `demo01.txt` and commits it onto branch `Deepak`.

### Step 7: Switch Back to Main Branch
```bash
git checkout main
```
* **Explanation:** Moves `HEAD` back to `main`. At this point, `main` does not have line 2.

### Step 8: Expected Failure Demonstration (Branch Not Found)
```bash
git merge --no-ff feature-edit -m "..."
```
* **Output / Expected Error:** `merge: feature-edit - not something we can merge`
* **Explanation:** Demonstrates handling when attempting to merge a branch that does not exist.

### Step 9: Merge Feature Branch with Merge Commit
```bash
git merge --no-ff Deepak -m "Merge Deepak to main branch"
```
* **Explanation:** 
  - `--no-ff` ensures Git always creates an explicit merge commit with two parents even if a fast-forward was possible.
  - This preserves the branching topology in the commit graph.

### Step 10: Delete Merged Feature Branch
```bash
# Attempt deleting non-existent branch (demonstrating error handling):
git branch -d feature-edit
# Error: branch 'feature-edit' not found

# Safely delete merged branch:
git branch -d Deepak
# Deleted branch Deepak (was <hash>)
```
* **Explanation:** `git branch -d` safely deletes a branch only if its commits are already merged into upstream `HEAD`.

### Step 11: Stash Temporary Work
```bash
echo "line 3: temp note" >> demo01.txt
git stash push -m "wip: temp note in demo01.txt"
```
* **Explanation:** 
  - `git stash push` captures uncommitted modifications from the working directory and index and saves them onto the stash stack, reverting working tree to `HEAD`.

### Step 12: Inspect and Restore Stash
```bash
git stash list
git stash pop
```
* **Explanation:** 
  - `git stash list` lists all stashes with their indices and labels (`stash@{0}: ...`).
  - `git stash pop` applies the most recent stashed change (`stash@{0}`) and drops it from the stash stack.

### Step 13: Stage and Commit Restored Changes
```bash
git add demo01.txt
git commit -m "Apply stashed temp note"
```

### Step 14: Display Compact Commit Graph & File Content
```bash
git log --oneline --graph --all --decorate
cat demo01.txt
```

---

## 📊 Expected Output & Verification

### Commit Graph Output:
```text
* 6f5f57a (HEAD -> main) Apply stashed temp note
*   5226cd9 Merge Deepak to main branch
|\  
| * ad6f7f7 Deepak: add line 2
|/  
* 3d03c5c Initial commit
```

### Final File (`demo01.txt`) Content:
```text
line 1: Hi Bro
line 2: Deepak branch is created
line 3: temp note
```

---

## 🚀 How to Run the Automated Script

### On Linux / macOS / Git Bash:
```bash
chmod +x run_expt01.sh
./run_expt01.sh
```

### On Windows PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File .\run_expt01.ps1
```
