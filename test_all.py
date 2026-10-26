#!/usr/bin/env python3
"""
Master Test Runner for Git Laboratory Experiments
Tests Experiment 01, Experiment 02, and Experiment 03
Verifies command execution, exit codes, git topology, tags, and file states.
"""

import os
import sys
import shutil
import tempfile
import subprocess
from datetime import datetime

class GitLabTester:
    def __init__(self):
        self.results = []
        self.start_time = datetime.now()

    def run_cmd(self, cmd, cwd, check=True, env=None):
        full_env = os.environ.copy()
        if env:
            full_env.update(env)
        # Suppress git editor prompts
        full_env["GIT_MERGE_AUTOEDIT"] = "no"
        full_env["GIT_EDITOR"] = ":"

        res = subprocess.run(
            cmd,
            cwd=cwd,
            shell=True,
            capture_output=True,
            text=True,
            env=full_env
        )
        if check and res.returncode != 0:
            raise RuntimeError(f"Command failed [{res.returncode}]: {cmd}\nStdout: {res.stdout}\nStderr: {res.stderr}")
        return res

    def test_experiment_01(self):
        print("\n" + "="*70)
        print("RUNNING TEST SUITE: EXPERIMENT 01 (Branching, Stashing, History Graph)")
        print("="*70)
        test_dir = tempfile.mkdtemp(prefix="test_expt01_")
        try:
            repo_dir = os.path.join(test_dir, "git-demo01")
            os.makedirs(repo_dir)

            # 1. Init
            self.run_cmd("git init", repo_dir)
            self.run_cmd('git config user.name "Mithun-gowda-M"', repo_dir)
            self.run_cmd('git config user.email "mithunking55@gmail.com"', repo_dir)
            self.run_cmd("git branch -m main", repo_dir)

            # 2. File creation & initial commit
            demo_file = os.path.join(repo_dir, "demo01.txt")
            with open(demo_file, "w") as f:
                f.write("line 1: Hi Bro\n")
            self.run_cmd("git add demo01.txt", repo_dir)
            self.run_cmd('git commit -m "Initial commit"', repo_dir)

            # 3. Branch Deepak & commit
            self.run_cmd("git checkout -b Deepak", repo_dir)
            with open(demo_file, "a") as f:
                f.write("line 2: Deepak branch is created\n")
            self.run_cmd("git add demo01.txt", repo_dir)
            self.run_cmd('git commit -m "Deepak: add line 2"', repo_dir)

            # 4. Switch to main & demonstrate merge failure
            self.run_cmd("git checkout main", repo_dir)
            res_fail = self.run_cmd('git merge --no-ff feature-edit -m "..."', repo_dir, check=False)
            assert res_fail.returncode != 0, "Merge non-existent branch should fail"

            # 5. Merge Deepak with --no-ff
            self.run_cmd('git merge --no-ff Deepak -m "Merge Deepak to main branch"', repo_dir)

            # 6. Branch deletion failure & success
            res_del_fail = self.run_cmd("git branch -d feature-edit", repo_dir, check=False)
            assert res_del_fail.returncode != 0, "Delete non-existent branch should fail"
            self.run_cmd("git branch -d Deepak", repo_dir)

            # 7. Stash test
            with open(demo_file, "a") as f:
                f.write("line 3: temp note\n")
            self.run_cmd('git stash push -m "wip: temp note in demo01.txt"', repo_dir)

            stash_list = self.run_cmd("git stash list", repo_dir).stdout
            assert "wip: temp note in demo01.txt" in stash_list, "Stash not found in list"

            self.run_cmd("git stash pop", repo_dir)
            self.run_cmd("git add demo01.txt", repo_dir)
            self.run_cmd('git commit -m "Apply stashed temp note"', repo_dir)

            # 8. Assertions
            with open(demo_file, "r") as f:
                content = f.read()
            expected_content = "line 1: Hi Bro\nline 2: Deepak branch is created\nline 3: temp note\n"
            assert content == expected_content, f"Content mismatch: {content}"

            log_out = self.run_cmd("git log --oneline --graph", repo_dir).stdout
            assert "Apply stashed temp note" in log_out
            assert "Merge Deepak to main branch" in log_out
            assert "Deepak: add line 2" in log_out
            assert "Initial commit" in log_out

            print(" [PASS] Experiment 01: All assertions verified successfully!")
            self.results.append(("Experiment 01", "PASS", "Verified commit graph, stash pop, 3-line file"))
        finally:
            shutil.rmtree(test_dir, ignore_errors=True)

    def test_experiment_02(self):
        print("\n" + "="*70)
        print("RUNNING TEST SUITE: EXPERIMENT 02 (Remote Clone, Push/Pull & Merge)")
        print("="*70)
        test_dir = tempfile.mkdtemp(prefix="test_expt02_")
        try:
            # 1. Bare remote
            remote_repo = os.path.join(test_dir, "remote.git")
            self.run_cmd("git init --bare remote.git", test_dir)
            self.run_cmd("git -C remote.git symbolic-ref HEAD refs/heads/main", test_dir)

            # Populate remote with initial commit
            temp_seed = os.path.join(test_dir, "temp_seed")
            self.run_cmd("git clone remote.git temp_seed", test_dir)
            self.run_cmd('git config user.name "Mithun-gowda-M"', temp_seed)
            self.run_cmd('git config user.email "mithunking55@gmail.com"', temp_seed)
            self.run_cmd("git branch -m main", temp_seed)
            with open(os.path.join(temp_seed, "README.md"), "w") as f:
                f.write("# Program 02 Repository\n")
            self.run_cmd("git add README.md", temp_seed)
            self.run_cmd('git commit -m "Initial remote commit"', temp_seed)
            self.run_cmd("git push origin main", temp_seed)
            shutil.rmtree(temp_seed, ignore_errors=True)

            # 2. Test clone edge cases
            self.run_cmd("git init --bare empty.git", test_dir)
            res_empty = self.run_cmd("git clone empty.git empty_clone", test_dir)
            assert "warning: You appear to have cloned an empty repository." in res_empty.stderr or res_empty.returncode == 0

            # 3. Clone program02
            prog02_dir = os.path.join(test_dir, "program02")
            self.run_cmd("git clone remote.git program02", test_dir)
            self.run_cmd('git config user.name "Mithun-gowda-M"', prog02_dir)
            self.run_cmd('git config user.email "mithunking55@gmail.com"', prog02_dir)

            # 4. Branch deepak
            self.run_cmd("git checkout -b deepak", prog02_dir)
            with open(os.path.join(prog02_dir, "democlass.txt"), "w") as f:
                f.write("Hi, I am from branch deepak\n")
            self.run_cmd("git add democlass.txt", prog02_dir)
            self.run_cmd('git commit -m "Add new file to deepak"', prog02_dir)

            # 5. Push deepak
            self.run_cmd("git push -u origin deepak", prog02_dir)
            self.run_cmd("git rebase deepak", prog02_dir)
            self.run_cmd("git switch main", prog02_dir)
            self.run_cmd("git push --force-with-lease origin deepak", prog02_dir)

            # 6. Merge deepak into main with --no-ff
            self.run_cmd('git merge --no-ff deepak -m "Merge deepak into main"', prog02_dir)

            # 7. Simulate independent collaborator commit on remote
            collab_dir = os.path.join(test_dir, "collab")
            self.run_cmd("git clone remote.git collab", test_dir)
            self.run_cmd('git config user.name "Collaborator"', collab_dir)
            self.run_cmd('git config user.email "collab@example.com"', collab_dir)
            with open(os.path.join(collab_dir, "lab_syllabus_part1.pdf"), "w") as f:
                f.write("PDF Content 1\n")
            with open(os.path.join(collab_dir, "lab_syllabus_part2.pdf"), "w") as f:
                f.write("PDF Content 2\n")
            self.run_cmd("git add lab_syllabus_part1.pdf lab_syllabus_part2.pdf", collab_dir)
            self.run_cmd('git commit -m "Upload 2 PDF files from GitHub"', collab_dir)
            self.run_cmd("git push origin main", collab_dir)
            shutil.rmtree(collab_dir, ignore_errors=True)

            # 8. Local push should fail
            res_push_fail = self.run_cmd("git push origin main", prog02_dir, check=False)
            assert res_push_fail.returncode != 0, "Push without pull should be rejected"

            # 9. Pull with --allow-unrelated-histories --no-rebase
            self.run_cmd("git pull origin main --allow-unrelated-histories --no-rebase", prog02_dir)

            # 10. Push merged main
            self.run_cmd("git push origin main", prog02_dir)

            # 11. Assertions
            pull_check = self.run_cmd("git pull origin main", prog02_dir).stdout
            assert "Already up to date" in pull_check

            assert os.path.exists(os.path.join(prog02_dir, "democlass.txt"))
            assert os.path.exists(os.path.join(prog02_dir, "lab_syllabus_part1.pdf"))
            assert os.path.exists(os.path.join(prog02_dir, "lab_syllabus_part2.pdf"))

            print(" [PASS] Experiment 02: All assertions verified successfully!")
            self.results.append(("Experiment 02", "PASS", "Verified clone, branch push, rejection, pull resolution & files"))
        finally:
            shutil.rmtree(test_dir, ignore_errors=True)

    def test_experiment_03(self):
        print("\n" + "="*70)
        print("RUNNING TEST SUITE: EXPERIMENT 03 (Release Management, Cherry-Pick, Revert)")
        print("="*70)
        test_dir = tempfile.mkdtemp(prefix="test_expt03_")
        try:
            repo_dir = os.path.join(test_dir, "git-release-demo")
            os.makedirs(repo_dir)

            self.run_cmd("git init -b main", repo_dir)
            self.run_cmd('git config user.name "Mithun-gowda-M"', repo_dir)
            self.run_cmd('git config user.email "mithunking55@gmail.com"', repo_dir)

            # Commits A, B
            with open(os.path.join(repo_dir, "app.txt"), "w") as f:
                f.write("app v1\n")
            self.run_cmd("git add .", repo_dir)
            self.run_cmd('git commit -m "A: initial commit"', repo_dir)

            with open(os.path.join(repo_dir, "feature.txt"), "w") as f:
                f.write("base feature\n")
            self.run_cmd("git add .", repo_dir)
            self.run_cmd('git commit -m "B: add base feature"', repo_dir)

            # Release branch
            self.run_cmd("git branch release/1.x", repo_dir)

            # Commits C, D, E, F on main
            with open(os.path.join(repo_dir, "fixC.txt"), "w") as f:
                f.write("fix C\n")
            self.run_cmd("git add .", repo_dir)
            self.run_cmd('git commit -m "C: fix login bug"', repo_dir)

            with open(os.path.join(repo_dir, "fixD.txt"), "w") as f:
                f.write("fix D\n")
            self.run_cmd("git add .", repo_dir)
            self.run_cmd('git commit -m "D: fix crash on startup"', repo_dir)

            with open(os.path.join(repo_dir, "fixE.txt"), "w") as f:
                f.write("fix E\n")
            self.run_cmd("git add .", repo_dir)
            self.run_cmd('git commit -m "E: fix typo in API"', repo_dir)

            with open(os.path.join(repo_dir, "broken.txt"), "w") as f:
                f.write("BROKEN\n")
            self.run_cmd("git add .", repo_dir)
            self.run_cmd('git commit -m "F: faulty change"', repo_dir)

            # Hashes
            b_hash = self.run_cmd("git rev-parse main~4", repo_dir).stdout.strip()
            f_hash = self.run_cmd("git rev-parse main", repo_dir).stdout.strip()

            # Switch release & tag v1.0.0
            self.run_cmd("git switch release/1.x", repo_dir)
            self.run_cmd("git tag v1.0.0", repo_dir)

            # Cherry comparison
            cherry_out = self.run_cmd("git cherry -v release/1.x main", repo_dir).stdout
            assert "+ " in cherry_out, "Cherry should show missing commits"

            # Cherry pick
            self.run_cmd(f"git cherry-pick -x {b_hash}..{f_hash}", repo_dir)
            assert os.path.exists(os.path.join(repo_dir, "broken.txt")), "broken.txt must exist after cherry-pick"

            # Find faulty commit and revert
            faulty_hash = self.run_cmd('git log --grep="F: faulty" --format=%h -1', repo_dir).stdout.strip()
            self.run_cmd(f"git revert --no-edit {faulty_hash}", repo_dir)

            assert not os.path.exists(os.path.join(repo_dir, "broken.txt")), "broken.txt must be removed after revert"

            # Tag v1.0.1
            self.run_cmd("git tag v1.0.1", repo_dir)

            # Remote push verification
            remote_repo = os.path.join(test_dir, "remote.git")
            self.run_cmd(f"git init --bare {remote_repo}", test_dir)
            self.run_cmd(f"git remote add origin {remote_repo}", repo_dir)
            self.run_cmd("git push origin main release/1.x", repo_dir)
            self.run_cmd("git push origin v1.0.0 v1.0.1", repo_dir)

            ls_tags = self.run_cmd("git ls-remote --tags origin", repo_dir).stdout
            assert "refs/tags/v1.0.0" in ls_tags
            assert "refs/tags/v1.0.1" in ls_tags

            print(" [PASS] Experiment 03: All assertions verified successfully!")
            self.results.append(("Experiment 03", "PASS", "Verified cherry-pick -x, faulty revert, tags v1.0.0 & v1.0.1, remote push"))
        finally:
            shutil.rmtree(test_dir, ignore_errors=True)

    def print_summary(self):
        duration = datetime.now() - self.start_time
        print("\n" + "="*70)
        print("                 GIT LAB TEST EXECUTION SUMMARY")
        print("="*70)
        all_passed = True
        for name, status, details in self.results:
            status_str = f"[{status}]"
            print(f" {name:<18} {status_str:<8} {details}")
            if status != "PASS":
                all_passed = False
        print("-" * 70)
        print(f" Total Duration: {duration.total_seconds():.2f} seconds")
        print(f" Overall Status: {'ALL TESTS PASSED (100%)' if all_passed else 'SOME TESTS FAILED'}")
        print("="*70 + "\n")
        return all_passed

if __name__ == "__main__":
    tester = GitLabTester()
    try:
        tester.test_experiment_01()
        tester.test_experiment_02()
        tester.test_experiment_03()
        success = tester.print_summary()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"\n[FATAL ERROR] {e}")
        sys.exit(1)
