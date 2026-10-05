# ==============================================================================
# Script de reproduction automatique de l'arborescence Windows (PowerShell)
# Usage :
#   .\setup_arborescence.ps1 [-TargetDir "C:\chemin\vers\Projets"]
# ==============================================================================

param(
    [string]$TargetDir = ""
)

$ErrorActionPreference = "Stop"

if ($TargetDir) {
    $BASE_DIR = $TargetDir
} elseif ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "..\..\Productivite\floSa"))) {
    $BASE_DIR = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
} else {
    $BASE_DIR = (Get-Location).Path
}

if (-not (Test-Path $BASE_DIR)) {
    New-Item -ItemType Directory -Path $BASE_DIR -Force | Out-Null
}
$BASE_DIR = (Resolve-Path $BASE_DIR).Path

Write-Host "=== Initialisation de l'arborescence dans $BASE_DIR ==="

$dirs = @(
    "_hors_git",
    "Autres-Projets",
    "Jeu\Board-Games",
    "Jeu\Courtisan",
    "Jeu\IA",
    "Jeu\Quiz",
    "Jeu\Urban-Rivals",
    "Projet-ML-DL\Defis-IA",
    "Projet-IA",
    "Musique",
    "Productivite",
    "Tutoriels"
)

foreach ($d in $dirs) {
    $fullPath = Join-Path $BASE_DIR $d
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    }
}

function Clone-Repo($url, $targetRelPath) {
    $targetPath = Join-Path $BASE_DIR $targetRelPath
    if (Test-Path (Join-Path $targetPath ".git")) {
        Write-Host "[DÉJÀ INSTALLÉ] $targetRelPath"
    } else {
        Write-Host "[CLONAGE] $url -> $targetRelPath"
        git clone $url $targetPath
    }
}

# --- Autres-Projets ---
Clone-Repo "https://github.com/floSa/Atlas-Metiers-Roadmaps.git" "Autres-Projets\Atlas-Metiers-Roadmaps"
Clone-Repo "git@github.com-perso:floSa/Cardmarket-Wantlist-Optimizer.git" "Autres-Projets\Cardmarket-Wantlist-Optimizer"
Clone-Repo "https://github.com/floSa/Planning-Usine-CPSAT.git" "Autres-Projets\Planning-Usine-CPSAT"
Clone-Repo "git@github.com-perso:floSa/Reels-Instagram-Graph-MD.git" "Autres-Projets\Reels-Instagram-Graph-MD"
Clone-Repo "https://github.com/floSa/Template-Services-Docker.git" "Autres-Projets\Template-Services-Docker"
Clone-Repo "https://github.com/floSa/Test-Pre-Entretien-Technique.git" "Autres-Projets\Test-Pre-Entretien-Technique"

# --- Jeu ---
Clone-Repo "https://github.com/floSa/7Wonders-BoardGame.git" "Jeu\Board-Games\7Wonders-BoardGame"
Clone-Repo "https://github.com/floSa/Dracula-VS-Van-Helsing-BoardGame.git" "Jeu\Board-Games\Dracula-VS-Van-Helsing-BoardGame"
Clone-Repo "https://github.com/floSa/Sea-Salt-And-Paper-BoardGame.git" "Jeu\Board-Games\Sea-Salt-And-Paper-BoardGame"
Clone-Repo "https://github.com/floSa/Toy-Battle-BoardGame.git" "Jeu\Board-Games\Toy-Battle-BoardGame"
Clone-Repo "https://github.com/floSa/Courtisans-BoardGame.git" "Jeu\Courtisan\Courtisans-BoardGame"
Clone-Repo "https://github.com/floSa/Courtisans-IA-Game.git" "Jeu\Courtisan\Courtisans-IA-Game"
Clone-Repo "https://github.com/floSa/Crossy-Road-AI-Game.git" "Jeu\IA\Crossy-Road-AI-Game"
Clone-Repo "https://github.com/floSa/Quiz-Geo.git" "Jeu\Quiz\Quiz-Geo"
Clone-Repo "https://github.com/floSa/Quiz-Hist.git" "Jeu\Quiz\Quiz-Hist"
Clone-Repo "https://github.com/floSa/Urban-Rivals-Game.git" "Jeu\Urban-Rivals\Urban-Rivals-Game"
Clone-Repo "https://github.com/floSa/Urban-Rivals-Scraper.git" "Jeu\Urban-Rivals\Urban-Rivals-Scraper"

# --- Projet-ML-DL ---
Clone-Repo "https://github.com/floSa/Analyse-Esperance-De-Vie-FR.git" "Projet-ML-DL\Analyse-Esperance-De-Vie-FR"
Clone-Repo "git@github.com-perso:floSa/Analyse-Habitudes-Alimentaires.git" "Projet-ML-DL\Analyse-Habitudes-Alimentaires"
Clone-Repo "https://github.com/floSa/Analyse-Vente-Prosol.git" "Projet-ML-DL\Analyse-Vente-Prosol"
Clone-Repo "https://github.com/floSa/Annotation-Images.git" "Projet-ML-DL\Annotation-Images"
Clone-Repo "git@github.com-perso:floSa/Annotation-Text-Streamlit.git" "Projet-ML-DL\Annotation-Text-Streamlit"
Clone-Repo "git@github.com-perso:floSa/Classification-Bulles.git" "Projet-ML-DL\Classification-Bulles"
Clone-Repo "git@github.com-perso:floSa/Defi-IA-2019.git" "Projet-ML-DL\Defis-IA\Defi-IA-2019"
Clone-Repo "git@github.com-perso:floSa/Defi-IA-2020.git" "Projet-ML-DL\Defis-IA\Defi-IA-2020"
Clone-Repo "git@github.com-perso:floSa/Defi-IA-2021.git" "Projet-ML-DL\Defis-IA\Defi-IA-2021"
Clone-Repo "git@github.com-perso:floSa/Defi-IA-2022.git" "Projet-ML-DL\Defis-IA\Defi-IA-2022"
Clone-Repo "git@github.com-perso:floSa/Defi-IA-2023.git" "Projet-ML-DL\Defis-IA\Defi-IA-2023"
Clone-Repo "https://github.com/floSa/Detection-Pneumonie-Radio.git" "Projet-ML-DL\Detection-Pneumonie-Radio"
Clone-Repo "git@github.com-perso:floSa/Notebooks-Cheat-Sheet.git" "Projet-ML-DL\Notebooks-Cheat-Sheet"
Clone-Repo "https://github.com/floSa/Sales-Ops-Planning-POC.git" "Projet-ML-DL\Sales-Ops-Planning-POC"

# --- Projet-IA ---
Clone-Repo "git@github.com-perso:floSa/Agents-MCP-Orchestration.git" "Projet-IA\Agents-MCP-Orchestration"
Clone-Repo "https://github.com/floSa/Data-Analyst-Agent.git" "Projet-IA\Data-Analyst-Agent"
Clone-Repo "git@github.com-perso:floSa/LLM-Service.git" "Projet-IA\LLM-Service"
Clone-Repo "https://github.com/floSa/MCP-Maison.git" "Projet-IA\MCP-Maison"
Clone-Repo "https://github.com/floSa/RAG-Agent-Chat.git" "Projet-IA\RAG-Agent-Chat"
Clone-Repo "git@github.com-perso:floSa/RAG-Eval-Bench.git" "Projet-IA\RAG-Eval-Bench"
Clone-Repo "https://github.com/floSa/RAG-Ingestion-Pipeline.git" "Projet-IA\RAG-Ingestion-Pipeline"
Clone-Repo "git@github.com-perso:floSa/Traceable-Agent.git" "Projet-IA\Traceable-Agent"

# --- Musique ---
Clone-Repo "git@github.com-perso:floSa/Bibliotheque-Musicale.git" "Musique\Bibliotheque-Musicale"
Clone-Repo "git@github.com-perso:floSa/Classification-Genres-Musicaux.git" "Musique\Classification-Genres-Musicaux"
Clone-Repo "git@github.com-perso:floSa/Karaokit.git" "Musique\Karaokit"

# --- Productivite ---
Clone-Repo "https://github.com/floSa/Boite-A-Outils.git" "Productivite\Boite-A-Outils"
Clone-Repo "git@github.com-perso:floSa/Brain-Kit.git" "Productivite\Brain-Kit"
Clone-Repo "git@github.com-perso:floSa/Catalogue-Comparateur-Solutions-IA.git" "Productivite\Catalogue-Comparateur-Solutions-IA"
Clone-Repo "git@github.com-perso:floSa/Fast-HTML-To-MD.git" "Productivite\Fast-HTML-To-MD"
Clone-Repo "git@github.com-perso:floSa/Outil-Dictee-Audio.git" "Productivite\Outil-Dictee-Audio"
Clone-Repo "git@github.com-perso:floSa/Veille-Repo.git" "Productivite\Veille-Repo"
Clone-Repo "git@github.com-perso:floSa/Mes-Skills.git" "Productivite\claude-skills"
Clone-Repo "https://github.com/floSa/floSa.git" "Productivite\floSa"

# --- Tutoriels ---
Clone-Repo "git@github.com-perso:floSa/Tuto-Dagster.git" "Tutoriels\Tuto-Dagster"
Clone-Repo "git@github.com-perso:floSa/Tuto-MLflow.git" "Tutoriels\Tuto-MLflow"
Clone-Repo "https://github.com/floSa/Tuto-OpenMetadata.git" "Tutoriels\Tuto-OpenMetadata"

Write-Host "=== Terminé ! Arborescence Windows reproduite avec succès. ==="
