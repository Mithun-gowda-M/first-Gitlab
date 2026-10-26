# first-Gitlab: Git Laboratory Manual & Solutions

Comprehensive solutions, automated test suites, and documentation for the **Git Laboratory Experiments**, transcribed from handwritten lab records and verified with 100% automated test coverage.

[![Git Tests](https://img.shields.io/badge/Git%20Lab%20Tests-100%25%20Passed-brightgreen.svg)](#-automated-testing--verification)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📑 Table of Contents
1. [Lab Manual Pages & Scrambled Image Mapping](#-lab-manual-pages--scrambled-image-mapping)
2. [Syllabus & Experiment Index](#-syllabus--experiment-index)
   - [Experiment 01: Branching, Stashing & Graph](#experiment-01-git-repository-feature-branching-stashing--history-graph)
   - [Experiment 02: Remote Operations, Push/Pull & Merging](#experiment-02-remote-repository-cloning-branching-pushpull--merging)
   - [Experiment 03: Release Management, Cherry-Pick & Revert](#experiment-03-git-release-management-tagging-cherry-picking--reverting)
3. [Automated Testing & Verification](#-automated-testing--verification)
4. [Project Directory Layout](#-project-directory-layout)
5. [Git Concepts & Viva Voce Guide](#-git-concepts--viva-voce-guide)

---

## 📸 Lab Manual Pages & Scrambled Image Mapping

The original notebook photos were organized and renamed in numerical order inside the [`images/`](images/) directory:

| Original Scrambled File Name | Organized Sequential Name | Experiment # | Page # | Description |
|:---|:---|:---:|:---:|:---|
| `WhatsAppbb Image 2026-10-18 at 11.48.31 AM.jpeg` | [`01_Expt01_Page01.jpeg`](images/01_Expt01_Page01.jpeg) | **Expt 01** | Page 1 | Repo init, author config, `main` branch, `demo01.txt` |
| `WhatsApp Image 20vv26-10-18 at 11.48.32 AM.jpeg` | [`02_Expt01_Page02.jpeg`](images/02_Expt01_Page02.jpeg) | **Expt 01** | Page 2 | Initial commit, `Deepak` branch, add line 2, `--no-ff` merge |
| `WhatsApp Image vv2026-10-18 at 11.48.32 AM.jpeg` | [`03_Expt01_Page03.jpeg`](images/03_Expt01_Page03.jpeg) | **Expt 01** | Page 3 | Branch deletion, stash push/pop, commit line 3, graph log |
| `WhatsApp Image 2026-10-18 at 11.48.36 AM.jpeg` | [`04_Expt02_Page04.jpeg`](images/04_Expt02_Page04.jpeg) | **Expt 02** | Page 4 | Empty clone warning, directory collision, branch `deepak` |
| `WhatsApp Image 2026-10-18 at 11.48.36 AvM.jpeg` | [`05_Expt02_Page05.jpeg`](images/05_Expt02_Page05.jpeg) | **Expt 02** | Page 5 | `democlass.txt`, push `-u`, rebase, `--force-with-lease` |
| `WhatsApp Image 2026-10-18 at 11.48.35 vAM.jpeg` | [`06_Expt02_Page06.jpeg`](images/06_Expt02_Page06.jpeg) | **Expt 02** | Page 6 | Non-fast-forward push rejection, pull unrelated histories, push |
| `WhatsApp Image 2026-10-18 at 11.48.35 AM.jpeg` | [`07_Expt03_Page07.jpeg`](images/07_Expt03_Page07.jpeg) | **Expt 03** | Page 7 | `git-release-demo`, init `main`, commit A (`app.txt`) |
| `WhatsApp Image 20vv6-10-18 at 11.48.32 AM.jpeg` | [`08_Expt03_Page08.jpeg`](images/08_Expt03_Page08.jpeg) | **Expt 03** | Page 8 | Commit B (`feature.txt`), branch `release/1.x`, commits C, D, E, F |
| `WhatsApp Image 2026-10-18 at 11.b48.35 AM.jpeg` | [`09_Expt03_Page09.jpeg`](images/09_Expt03_Page09.jpeg) | **Expt 03** | Page 9 | `rev-parse` B, C, F, switch `release/1.x`, tag `v1.0.0`, show |
| `WhatsApp Image 2026-10-18v at 11.48.34 AM.jpeg` | [`10_Expt03_Page10.jpeg`](images/10_Expt03_Page10.jpeg) | **Expt 03** | Page 10 | `git cherry -v`, cherry-pick `$B..$F` with `-x`, faulty commit hash |
| `WhatsApp Image 2026-10-18 at 11v.48.34 AM.jpeg` | [`11_Expt03_Page11.jpeg`](images/11_Expt03_Page11.jpeg) | **Expt 03** | Page 11 | `git revert --no-edit $FAULTY`, tag `v1.0.1`, bare remote push |
| `WhatsApp Image 2026-10-18 atc 11.48.33 AM.jpeg` | [`12_Expt03_Page12.jpeg`](images/12_Expt03_Page12.jpeg) | **Expt 03** | Page 12 | Push tags, `ls-remote`, revert simulation (`--no-commit`, `--abort`) |
| `WhatsApp Image 2026-10-18 vt 11.48.33 AM.jpeg` | [`13_Expt03_Page13.jpeg`](images/13_Expt03_Page13.jpeg) | **Expt 03** | Page 13 | Final cleanup |

---

## 📚 Syllabus & Experiment Index

### Experiment 01: Git Repository, Feature Branching, Stashing & History Graph
📁 **Directory:** [`Experiment-01/`](Experiment-01/) | 📄 **Manual:** [`Experiment-01/README.md`](Experiment-01/README.md)

* **Problem Statement:** Create a Git repository and demonstrate commit file, create and merge a feature branch, use `git stash` to save and restore a temporary change, and display the commit history as a graph.
* **Key Steps:**
  1. Initialize repository and set default branch to `main`.
  2. Create and commit `demo01.txt` (`"line 1: Hi Bro"`).
  3. Create and switch to feature branch `Deepak`.
  4. Append line 2 (`"line 2: Deepak branch is created"`) and commit.
  5. Merge `Deepak` into `main` with `--no-ff` (preserves merge commit topology).
  6. Safely delete merged branch with `git branch -d`.
  7. Add temporary change (`"line 3: temp note"`), stash with message (`git stash push -m "..."`).
  8. Restore stash with `git stash pop`, stage, and commit (`"Apply stashed temp note"`).
  9. Display history graph with `git log --oneline --graph --all --decorate`.

---

### Experiment 02: Remote Repository Cloning, Branching, Push/Pull & Merging
📁 **Directory:** [`Experiment-02/`](Experiment-02/) | 📄 **Manual:** [`Experiment-02/README.md`](Experiment-02/README.md)

* **Problem Statement:** Clone a remote GitHub repository, create a new branch, add and commit a file, push the branch to GitHub, merge it into `main` with a merge commit, push `main`, and pull the latest changes.
* **Key Steps:**
  1. Inspect Git configuration and observe edge cases (empty repository warning, directory collision error).
  2. Clone repository and branch into `deepak`.
  3. Add `democlass.txt` and commit.
  4. Push branch to remote with upstream tracking (`git push -u origin deepak`).
  5. Switch back to `main` and perform safe force push (`--force-with-lease`).
  6. Merge `deepak` into `main` using `--no-ff`.
  7. Push to remote and observe non-fast-forward rejection caused by remote collaborator commits.
  8. Pull remote changes using `git pull origin main --allow-unrelated-histories --no-rebase`.
  9. Push merged `main` to remote and verify repository state.

---

### Experiment 03: Git Release Management, Tagging, Cherry-Picking & Reverting
📁 **Directory:** [`Experiment-03/`](Experiment-03/) | 📄 **Manual:** [`Experiment-03/README.md`](Experiment-03/README.md)

* **Problem Statement:** Demonstrate Git release management using tagging, cherry-picking, and reverting. Create a repository with commits `A` to `F` on `main` (`C`, `D`, `E` are bug fixes and `F` is a faulty commit). Create `release/1.x` branch at commit `B`, cherry-pick `C` to `F` onto `release/1.x`, revert the faulty commit `F`, and tag the patched release `v1.0.1`.
* **Key Steps:**
  1. Create commits `A` and `B` on `main`.
  2. Create branch `release/1.x` pointing at commit `B` without switching.
  3. Add bug fixes `C`, `D`, `E` and faulty commit `F` (`broken.txt`) on `main`.
  4. Switch to `release/1.x` and tag commit `B` as initial release `v1.0.0`.
  5. Compare missing commits with `git cherry -v release/1.x main`.
  6. Cherry-pick range `B..F` onto `release/1.x` using `-x` (preserves original commit SHA in commit messages).
  7. Locate faulty commit and revert with `git revert --no-edit $FAULTY` (removes `broken.txt`).
  8. Tag patched release as `v1.0.1`.
  9. Push branches (`main`, `release/1.x`) and tags (`v1.0.0`, `v1.0.1`) to bare remote repository.
  10. Verify remote tags via `git ls-remote --tags origin`.
  11. Demonstrate `git revert --no-commit` and `git revert --abort`.

---

## 🧪 Automated Testing & Verification

All three experiments include automated execution scripts in both **PowerShell (`.ps1`)** and **Bash (`.sh`)**, plus a unified **Python test suite (`test_all.py`)**.

### Running the Python Test Suite (Cross-Platform):
```bash
python test_all.py
```

### Running via PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File .\test_all.ps1
```

### Running via Bash:
```bash
chmod +x test_all.sh
./test_all.sh
```

### Test Suite Execution Output:
```text
======================================================================
                 GIT LAB TEST EXECUTION SUMMARY
======================================================================
 Experiment 01      [PASS]   Verified commit graph, stash pop, 3-line file
 Experiment 02      [PASS]   Verified clone, branch push, rejection, pull resolution & files
 Experiment 03      [PASS]   Verified cherry-pick -x, faulty revert, tags v1.0.0 & v1.0.1, remote push
----------------------------------------------------------------------
 Total Duration: 10.93 seconds
 Overall Status: ALL TESTS PASSED (100%)
======================================================================
```
Full test report: [`TEST_RESULTS.md`](TEST_RESULTS.md)

---

## 📂 Project Directory Layout

```text
git lab/
├── .gitignore                      # Prevents committing temporary test sandboxes and OS files
├── README.md                       # Master documentation and laboratory index
├── TEST_RESULTS.md                 # Detailed test execution log and assertions report
├── test_all.py                     # Cross-platform automated test suite
├── test_all.ps1                    # PowerShell test runner
├── test_all.sh                     # Bash test runner
├── images/                         # Organized handwritten lab manual records (Pages 1 to 13)
│   ├── 01_Expt01_Page01.jpeg
│   ├── 02_Expt01_Page02.jpeg
│   ├── 03_Expt01_Page03.jpeg
│   ├── 04_Expt02_Page04.jpeg
│   ├── 05_Expt02_Page05.jpeg
│   ├── 06_Expt02_Page06.jpeg
│   ├── 07_Expt03_Page07.jpeg
│   ├── 08_Expt03_Page08.jpeg
│   ├── 09_Expt03_Page09.jpeg
│   ├── 10_Expt03_Page10.jpeg
│   ├── 11_Expt03_Page11.jpeg
│   ├── 12_Expt03_Page12.jpeg
│   └── 13_Expt03_Page13.jpeg
├── Experiment-01/
│   ├── README.md                   # Full step-by-step manual and theoretical explanations
│   ├── run_expt01.sh               # Executable Bash script
│   └── run_expt01.ps1              # Executable PowerShell script
├── Experiment-02/
│   ├── README.md                   # Full step-by-step manual and theoretical explanations
│   ├── run_expt02.sh               # Executable Bash script
│   └── run_expt02.ps1              # Executable PowerShell script
└── Experiment-03/
    ├── README.md                   # Full step-by-step manual and theoretical explanations
    ├── run_expt03.sh               # Executable Bash script
    └── run_expt03.ps1              # Executable PowerShell script
```

---

## 🧠 Git Concepts & Viva Voce Guide

### 1. Why use `--no-ff` when merging?
* By default, if the target branch has no new commits, Git performs a **fast-forward** merge by simply moving the branch pointer forward without creating a new commit.
* Using `--no-ff` forces Git to create an explicit **merge commit** with two parent pointers. This preserves the branch's historical existence and makes it clear in the log graph where feature development began and merged.

### 2. Difference between `git revert` and `git reset`:
* **`git reset`**: Moves `HEAD` backwards in time, rewriting history. Unsafe on public/shared branches because other collaborators have already based work on those commits.
* **`git revert`**: Appends a brand-new commit that applies the inverse diff of the target commit. Does not alter history, making it completely safe for shared branches.

### 3. What does `git cherry-pick -x` do?
* Copies existing commits from another branch and replays them on top of the current `HEAD`.
* The `-x` flag automatically appends `(cherry picked from commit <SHA>)` to the commit message, providing clear traceability back to the upstream commit.

### 4. What is `git stash` and how is it structured?
* `git stash` stores dirty working directory and staging index changes onto a Last-In-First-Out (LIFO) stack without creating a permanent commit.
* `git stash list` views the stack (`stash@{0}`, `stash@{1}`, etc.).
* `git stash pop` applies `stash@{0}` and deletes it from the stack, whereas `git stash apply` leaves it in the stack.

### 5. Why do pushes get rejected with non-fast-forward errors?
* When the remote branch has commits that your local repository does not possess, Git protects against silent overwrites.
* The developer must first integrate remote changes using `git pull` (or `git fetch` followed by `git merge` / `git rebase`) before pushing.
* If histories are disconnected (different root commits), `--allow-unrelated-histories` allows Git to perform a 3-way merge.

---

## 👤 Author
**Mithun Gowda M**  
GitHub: [@Mithun-gowda-M](https://github.com/Mithun-gowda-M)  
Email: [mithunking55@gmail.com](mailto:mithunking55@gmail.com)
