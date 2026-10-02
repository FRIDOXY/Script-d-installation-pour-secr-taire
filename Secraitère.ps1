# ============================================================
# INSTALLATION AUTOMATIQUE - POSTE SECRETAIRE
# Windows 11 - WinGet
# ============================================================

$ErrorActionPreference = "Continue"

Clear-Host

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "          INSTALLATION DU POSTE SECRETAIRE" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------------------------
# Vérification des droits administrateur
# ------------------------------------------------------------

$CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)

if (-not $Principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    Write-Host "ERREUR : Le script doit être lancé en administrateur." -ForegroundColor Red
    Write-Host ""
    Write-Host "Clic droit sur le fichier .ps1 > Exécuter avec PowerShell"
    Write-Host ""
    Pause
    exit
}

Write-Host "[OK] Droits administrateur détectés." -ForegroundColor Green
Write-Host ""

# ------------------------------------------------------------
# Vérification de WinGet
# ------------------------------------------------------------

Write-Host "[1/3] Vérification de WinGet..." -ForegroundColor Yellow

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERREUR : WinGet n'est pas disponible sur ce PC." -ForegroundColor Red
    Write-Host ""
    Write-Host "Installe ou mets à jour 'App Installer' depuis le Microsoft Store."
    Write-Host ""

    Pause
    exit
}

Write-Host "[OK] WinGet est disponible." -ForegroundColor Green
Write-Host ""

# ------------------------------------------------------------
# Liste des applications
# ------------------------------------------------------------

$Applications = @(
    "TheDocumentFoundation.LibreOffice",
    "Mozilla.Firefox",
    "Google.Chrome",
    "7zip.7zip",
    "VideoLAN.VLC",
    "Adobe.Acrobat.Reader.64-bit",
    "Mozilla.Thunderbird",
    "RustDesk.RustDesk"
)

# ------------------------------------------------------------
# Installation
# ------------------------------------------------------------

Write-Host "[2/3] Installation des applications..." -ForegroundColor Yellow
Write-Host ""

$Success = @()
$Failed = @()

foreach ($Application in $Applications) {

    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "Installation : $Application" -ForegroundColor Cyan
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

    winget install `
        --id $Application `
        --exact `
        --silent `
        --accept-source-agreements `
        --accept-package-agreements

    if ($LASTEXITCODE -eq 0) {

        Write-Host "[OK] $Application installé." -ForegroundColor Green
        $Success += $Application

    }
    else {

        Write-Host "[!] $Application : installation échouée ou déjà installé." -ForegroundColor Yellow
        $Failed += $Application
    }

    Write-Host ""
}

# ------------------------------------------------------------
# Résumé
# ------------------------------------------------------------

Write-Host ""
Write-Host "[3/3] Installation terminée." -ForegroundColor Yellow
Write-Host ""

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "                     RAPPORT FINAL" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Applications installées :" -ForegroundColor Green
Write-Host ""

foreach ($Application in $Success) {
    Write-Host "  [OK] $Application" -ForegroundColor Green
}

if ($Failed.Count -gt 0) {

    Write-Host ""
    Write-Host "Applications à vérifier :" -ForegroundColor Yellow
    Write-Host ""

    foreach ($Application in $Failed) {
        Write-Host "  [!] $Application" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "              INSTALLATION TERMINEE" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Un redémarrage de Windows peut être recommandé." -ForegroundColor White
Write-Host ""

Pause