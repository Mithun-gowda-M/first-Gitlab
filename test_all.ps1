# ==============================================================================
# Master Test Runner (PowerShell) for Git Laboratory Experiments
# ==============================================================================
$ErrorActionPreference = "Stop"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "        RUNNING ALL GIT LAB EXPERIMENT AUTOMATION SCRIPTS            " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan

$expt1 = Join-Path $PSScriptRoot "Experiment-01\run_expt01.ps1"
$expt2 = Join-Path $PSScriptRoot "Experiment-02\run_expt02.ps1"
$expt3 = Join-Path $PSScriptRoot "Experiment-03\run_expt03.ps1"

Write-Host "`n>>> Running Experiment 01..." -ForegroundColor Yellow
& powershell -ExecutionPolicy Bypass -File $expt1

Write-Host "`n>>> Running Experiment 02..." -ForegroundColor Yellow
& powershell -ExecutionPolicy Bypass -File $expt2

Write-Host "`n>>> Running Experiment 03..." -ForegroundColor Yellow
& powershell -ExecutionPolicy Bypass -File $expt3

Write-Host "`n======================================================================" -ForegroundColor Cyan
Write-Host "           ALL 3 EXPERIMENT SCRIPTS COMPLETED SUCCESSFULLY!           " -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
