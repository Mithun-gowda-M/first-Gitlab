#!/usr/bin/env bash
# ==============================================================================
# Master Test Runner (Bash) for Git Laboratory Experiments
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================================================"
echo "        RUNNING ALL GIT LAB EXPERIMENT AUTOMATION SCRIPTS            "
echo "======================================================================"

echo ""
echo ">>> Running Experiment 01..."
bash "$SCRIPT_DIR/Experiment-01/run_expt01.sh"

echo ""
echo ">>> Running Experiment 02..."
bash "$SCRIPT_DIR/Experiment-02/run_expt02.sh"

echo ""
echo ">>> Running Experiment 03..."
bash "$SCRIPT_DIR/Experiment-03/run_expt03.sh"

echo ""
echo "======================================================================"
echo "           ALL 3 EXPERIMENT SCRIPTS COMPLETED SUCCESSFULLY!           "
echo "======================================================================"
