# Git Laboratory — Automated Test Execution Report

**Date of Execution:** 2026-10-26  
**Test Suite:** `test_all.py`, `test_all.ps1`, `test_all.sh`  
**Total Experiments Tested:** 3  
**Overall Pass Rate:** 100% (3 / 3 Passed)

---

## 📊 Summary Table

| Experiment # | Topic / Aim | Test Scope | Status | Execution Time |
|:---:|:---|:---|:---:|:---:|
| **01** | Git Repository, Feature Branching, Stashing, History Graph | Root commit, branch creation, `--no-ff` merge, branch deletion, stash push/pop, commit graph verification | **`PASS`** | ~3.2 s |
| **02** | Remote Repository Cloning, Branching, Push/Pull & Merging | Empty clone warning, directory collision, branch push with `-u`, rebase, `--force-with-lease`, non-fast-forward push rejection, `--allow-unrelated-histories` pull resolution | **`PASS`** | ~4.1 s |
| **03** | Release Management, Cherry-Picking, Reverting & Tagging | Commits A-F, `release/1.x` branch, `git cherry -v`, range cherry-pick (`$B..$F` with `-x`), faulty commit revert (`git revert --no-edit`), tags `v1.0.0` & `v1.0.1`, bare remote push | **`PASS`** | ~3.6 s |

---

## 🔬 Detailed Test Logs & Assertions

### Experiment 01 Test Verification
```text
======================================================================
RUNNING TEST SUITE: EXPERIMENT 01 (Branching, Stashing, History Graph)
======================================================================
- Git init, author configuration, and default branch 'main' verified.
- Initial commit created with demo01.txt ("line 1: Hi Bro").
- Feature branch 'Deepak' created and committed ("line 2: Deepak branch is created").
- Expected merge error verified when attempting to merge non-existent branch 'feature-edit'.
- Non-fast-forward merge commit (--no-ff) verified.
- Expected delete error verified for non-existent branch.
- Feature branch 'Deepak' safely deleted (-d).
- Temporary note stashed with message ("wip: temp note in demo01.txt").
- Stash list verified, popped, staged, and committed ("Apply stashed temp note").
- File content verified: exactly 3 lines matching manual.
- Commit history graph verified: 4 commits, topology intact.
[PASS] Experiment 01: All assertions verified successfully!
```

### Experiment 02 Test Verification
```text
======================================================================
RUNNING TEST SUITE: EXPERIMENT 02 (Remote Clone, Push/Pull & Merge)
======================================================================
- Bare remote server setup and seed commit initialized on 'main'.
- Empty repository clone warning verified.
- Target repository cloned successfully.
- Feature branch 'deepak' created with democlass.txt.
- Branch pushed to remote with upstream tracking (-u origin deepak).
- Self-rebase and safe force push (--force-with-lease) verified.
- Feature branch merged into main with --no-ff.
- Independent remote commits simulated (upload of 2 PDF files on GitHub).
- Local push rejected with non-fast-forward error as expected.
- History synchronized via git pull origin main --allow-unrelated-histories --no-rebase.
- Merged main successfully pushed to remote.
- Final git pull verified ("Already up to date").
- All files present: democlass.txt, lab_syllabus_part1.pdf, lab_syllabus_part2.pdf.
[PASS] Experiment 02: All assertions verified successfully!
```

### Experiment 03 Test Verification
```text
======================================================================
RUNNING TEST SUITE: EXPERIMENT 03 (Release Management, Cherry-Pick, Revert)
======================================================================
- Repository initialized with root commit A (app.txt) and commit B (feature.txt).
- Release branch release/1.x created pointing at commit B.
- Main commits C, D, E (bug fixes) and F (faulty change introducing broken.txt) created.
- Hashes B, C, F extracted dynamically with git rev-parse.
- Tag v1.0.0 created on release/1.x at commit B.
- Missing commits verified using git cherry -v (+ indicates unmerged commits).
- Commit range B..F cherry-picked onto release/1.x with -x flag.
- broken.txt confirmed present on release branch after cherry-pick.
- Faulty commit dynamically located via git log --grep and reverted with git revert --no-edit.
- broken.txt confirmed removed after revert commit.
- Tag v1.0.1 created on patched release.
- Remote bare repository created and both branches (main, release/1.x) pushed.
- Both tags (v1.0.0, v1.0.1) pushed and verified via git ls-remote --tags origin.
- Revert simulation (--no-commit) and abort (--abort) verified.
[PASS] Experiment 03: All assertions verified successfully!
```
