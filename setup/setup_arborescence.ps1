# ==============================================================================
# Script de reproduction, migration et synchronisation automatique de l'arborescence Windows (PowerShell)
#
# RÈGLE IMPORTANTE SUR '_hors_git' :
# Le dossier '_hors_git' est strictement réservé aux données locales propres à la
# machine hôte (sauvegardes, caches, documents locaux, projets hors git).
# Il est STRICTEMENT SANCTUARISÉ : ce script ne modifie, ne déplace et ne supprime
# JAMAIS son contenu.
#
# Usage :
#   .\setup_arborescence.ps1 [-TargetDir "C:\chemin\vers\Projets"]
# ==============================================================================

param(
    [string]$TargetDir = ""
)

$ErrorActionPreference = "Continue"

if ($TargetDir) {
    $BASE_DIR = $TargetDir
} elseif ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "..\..\..\Productivite\floSa"))) {
    $BASE_DIR = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
} elseif ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "..\.."))) {
    $BASE_DIR = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
} else {
    $BASE_DIR = (Get-Location).Path
}

if (-not (Test-Path $BASE_DIR)) {
    New-Item -ItemType Directory -Path $BASE_DIR -Force | Out-Null
}
$BASE_DIR = (Resolve-Path $BASE_DIR).Path

Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  Arborescence des Projets — Synchronisation & Mise à jour (Windows)" -ForegroundColor Cyan
Write-Host "  Répertoire racine : $BASE_DIR" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan

# --- 1. Gestion stricte et sanctuarisation de '_hors_git' ---
$horsGitDash = Join-Path $BASE_DIR "_hors-git"
$horsGitUnder = Join-Path $BASE_DIR "_hors_git"

if ((Test-Path $horsGitDash) -and (-not (Test-Path $horsGitUnder))) {
    Write-Host "[HORS-GIT] Normalisation du dossier '_hors-git' -> '_hors_git'" -ForegroundColor Yellow
    Rename-Item -Path $horsGitDash -NewName "_hors_git"
    try {
        New-Item -ItemType SymbolicLink -Path $horsGitDash -Target "_hors_git" | Out-Null
    } catch {}
} elseif (-not (Test-Path $horsGitUnder)) {
    New-Item -ItemType Directory -Path $horsGitUnder -Force | Out-Null
}

Write-Host "[HORS-GIT] Dossier '_hors_git' vérifié : sanctuarisé (aucun fichier interne touché)." -ForegroundColor Green

# --- 2. Création de l'arborescence cible ---
$dirs = @(
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

function Sync-Repo($url, $targetRelPath) {
    $targetPath = Join-Path $BASE_DIR $targetRelPath
    $repoName = Split-Path -Leaf $targetRelPath

    # 1. Si déjà en place
    if (Test-Path (Join-Path $targetPath ".git")) {
        Write-Host -NoNewline "[DÉJÀ EN PLACE] $targetRelPath ... " -ForegroundColor Gray
        $dirty = git -C $targetPath status --porcelain 2>$null
        if (-not $dirty) {
            git -C $targetPath pull --ff-only -q 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "pull OK" -ForegroundColor Green
            } else {
                Write-Host "pull ignoré (divergence ou branche locale)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "modifs locales, pull ignoré" -ForegroundColor Yellow
        }
        return
    }

    # 2. Migration automatique si présent dans une ancienne arborescence
    $candidates = Get-ChildItem -Path $BASE_DIR -Directory -Recurse -Depth 3 -Filter $repoName -ErrorAction SilentlyContinue |
        Where-Object { (Test-Path (Join-Path $_.FullName ".git")) -and ($_.FullName -ne $targetPath) -and ($_.FullName -notmatch "_hors[-_]git") }

    if ($candidates) {
        $oldPath = $candidates[0].FullName
        Write-Host "[MIGRATION] $oldPath -> $targetRelPath" -ForegroundColor Yellow
        $parent = Split-Path -Parent $targetPath
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Move-Item -Path $oldPath -Destination $targetPath
        $dirty = git -C $targetPath status --porcelain 2>$null
        if (-not $dirty) {
            git -C $targetPath pull --ff-only -q 2>$null
        }
        return
    }

    # 3. Clonage si absent
    Write-Host "[CLONAGE] $url -> $targetRelPath" -ForegroundColor Cyan
    $parent = Split-Path -Parent $targetPath
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    git clone $url $targetPath
    if ($LASTEXITCODE -ne 0) {
        $fallbackUrl = $url -replace "git@github\.com-perso:", "https://github.com/"
        Write-Host "  -> Repli HTTPS: $fallbackUrl" -ForegroundColor Yellow
        git clone $fallbackUrl $targetPath
    }
}

# --- Autres-Projets ---
Sync-Repo "git@github.com-perso:floSa/Atlas-Metiers-Roadmaps.git" "Autres-Projets\Atlas-Metiers-Roadmaps"
Sync-Repo "git@github.com-perso:floSa/Cardmarket-Wantlist-Optimizer.git" "Autres-Projets\Cardmarket-Wantlist-Optimizer"
Sync-Repo "git@github.com-perso:floSa/Planning-Usine-CPSAT.git" "Autres-Projets\Planning-Usine-CPSAT"
Sync-Repo "git@github.com-perso:floSa/PowerVision-S1-Backup.git" "Autres-Projets\PowerVision-S1-Backup"
Sync-Repo "git@github.com-perso:floSa/Reels-Instagram-Graph-MD.git" "Autres-Projets\Reels-Instagram-Graph-MD"
Sync-Repo "git@github.com-perso:floSa/Template-services-docker.git" "Autres-Projets\Template-Services-Docker"
Sync-Repo "git@github.com-perso:floSa/Test-pre-entretien-technique.git" "Autres-Projets\Test-Pre-Entretien-Technique"

# --- Jeu ---
Sync-Repo "git@github.com-perso:floSa/7Wonders-BoardGame.git" "Jeu\Board-Games\7Wonders-BoardGame"
Sync-Repo "git@github.com-perso:floSa/Dracula-VS-Van-Helsing-BoardGame.git" "Jeu\Board-Games\Dracula-VS-Van-Helsing-BoardGame"
Sync-Repo "git@github.com-perso:floSa/Sea-Salt-And-Paper-BoardGame.git" "Jeu\Board-Games\Sea-Salt-And-Paper-BoardGame"
Sync-Repo "git@github.com-perso:floSa/Toy-Battle-BoardGame.git" "Jeu\Board-Games\Toy-Battle-BoardGame"
Sync-Repo "git@github.com-perso:floSa/Courtisans-BoardGame.git" "Jeu\Courtisan\Courtisans-BoardGame"
Sync-Repo "git@github.com-perso:floSa/Courtisans-IA-Game.git" "Jeu\Courtisan\Courtisans-IA-Game"
Sync-Repo "git@github.com-perso:floSa/Crossy-Road-AI-Game.git" "Jeu\IA\Crossy-Road-AI-Game"
Sync-Repo "git@github.com-perso:floSa/Quiz-Geo.git" "Jeu\Quiz\Quiz-Geo"
Sync-Repo "git@github.com-perso:floSa/Quiz-Hist.git" "Jeu\Quiz\Quiz-Hist"
Sync-Repo "git@github.com-perso:floSa/Urban-Rivals-Game.git" "Jeu\Urban-Rivals\Urban-Rivals-Game"
Sync-Repo "git@github.com-perso:floSa/Urban-Rivals-Scraper.git" "Jeu\Urban-Rivals\Urban-Rivals-Scraper"

# --- Projet-ML-DL ---
Sync-Repo "git@github.com-perso:floSa/Analyse-Esperance-De-Vie-FR.git" "Projet-ML-DL\Analyse-Esperance-De-Vie-FR"
Sync-Repo "git@github.com-perso:floSa/Analyse-Habitudes-Alimentaires.git" "Projet-ML-DL\Analyse-Habitudes-Alimentaires"
Sync-Repo "git@github.com-perso:floSa/Analyse-Vente-Prosol.git" "Projet-ML-DL\Analyse-Vente-Prosol"
Sync-Repo "git@github.com-perso:floSa/Annotation-Images.git" "Projet-ML-DL\Annotation-Images"
Sync-Repo "git@github.com-perso:floSa/Annotation-Text-Streamlit.git" "Projet-ML-DL\Annotation-Text-Streamlit"
Sync-Repo "git@github.com-perso:floSa/Classification-Bulles.git" "Projet-ML-DL\Classification-Bulles"
Sync-Repo "git@github.com-perso:floSa/Defi-IA-2019.git" "Projet-ML-DL\Defis-IA\Defi-IA-2019"
Sync-Repo "git@github.com-perso:floSa/Defi-IA-2020.git" "Projet-ML-DL\Defis-IA\Defi-IA-2020"
Sync-Repo "git@github.com-perso:floSa/Defi-IA-2021.git" "Projet-ML-DL\Defis-IA\Defi-IA-2021"
Sync-Repo "git@github.com-perso:floSa/Defi-IA-2022.git" "Projet-ML-DL\Defis-IA\Defi-IA-2022"
Sync-Repo "git@github.com-perso:floSa/Defi-IA-2023.git" "Projet-ML-DL\Defis-IA\Defi-IA-2023"
Sync-Repo "git@github.com-perso:floSa/Detection-Pneumonie-Radio.git" "Projet-ML-DL\Detection-Pneumonie-Radio"
Sync-Repo "git@github.com-perso:floSa/Images-collection-clean.git" "Projet-ML-DL\Images-Collection-Clean"
Sync-Repo "git@github.com-perso:floSa/Notebooks-Cheat-Sheet.git" "Projet-ML-DL\Notebooks-Cheat-Sheet"
Sync-Repo "git@github.com-perso:floSa/sales-ops-planning-poc.git" "Projet-ML-DL\Sales-Ops-Planning-POC"

# --- Projet-IA ---
Sync-Repo "git@github.com-perso:floSa/Agents-MCP-Orchestration.git" "Projet-IA\Agents-MCP-Orchestration"
Sync-Repo "git@github.com-perso:floSa/data-analyst-agent.git" "Projet-IA\Data-Analyst-Agent"
Sync-Repo "git@github.com-perso:floSa/llm-service.git" "Projet-IA\LLM-Service"
Sync-Repo "git@github.com-perso:floSa/MCP_maison.git" "Projet-IA\MCP-Maison"
Sync-Repo "git@github.com-perso:floSa/rag-agent-chat.git" "Projet-IA\RAG-Agent-Chat"
Sync-Repo "git@github.com-perso:floSa/RAG-Eval-Bench.git" "Projet-IA\RAG-Eval-Bench"
Sync-Repo "git@github.com-perso:floSa/rag-ingestion-pipeline.git" "Projet-IA\RAG-Ingestion-Pipeline"
Sync-Repo "git@github.com-perso:floSa/traceable-agent.git" "Projet-IA\Traceable-Agent"

# --- Musique ---
Sync-Repo "git@github.com-perso:floSa/Bibliotheque-Musicale.git" "Musique\Bibliotheque-Musicale"
Sync-Repo "git@github.com-perso:floSa/Classification-Genres-Musicaux.git" "Musique\Classification-Genres-Musicaux"
Sync-Repo "git@github.com-perso:floSa/karaokit.git" "Musique\Karaokit"

# --- Productivite ---
Sync-Repo "git@github.com-perso:floSa/Boite-A-Outils.git" "Productivite\Boite-A-Outils"
Sync-Repo "git@github.com-perso:floSa/Brain-Kit.git" "Productivite\Brain-Kit"
Sync-Repo "git@github.com-perso:floSa/Catalogue-Comparateur-Solutions-IA.git" "Productivite\Catalogue-Comparateur-Solutions-IA"
Sync-Repo "git@github.com-perso:floSa/Dev-Brain.git" "Productivite\Dev-Brain"
Sync-Repo "git@github.com-perso:floSa/Fast-HTML-To-MD.git" "Productivite\Fast-HTML-To-MD"
Sync-Repo "git@github.com-perso:floSa/Outil-Dictee-Audio.git" "Productivite\Outil-Dictee-Audio"
Sync-Repo "git@github.com-perso:floSa/Veille-Repo.git" "Productivite\Veille-Repo"
Sync-Repo "git@github.com-perso:floSa/mes-skills.git" "Productivite\claude-skills"
Sync-Repo "git@github.com-perso:floSa/floSa.git" "Productivite\floSa"

# --- Tutoriels ---
Sync-Repo "git@github.com-perso:floSa/Tuto-Dagster.git" "Tutoriels\Tuto-Dagster"
Sync-Repo "git@github.com-perso:floSa/Tuto-MLflow.git" "Tutoriels\Tuto-MLflow"
Sync-Repo "git@github.com-perso:floSa/Tuto-openmetadata.git" "Tutoriels\Tuto-OpenMetadata"

# Nettoyage
$oldDirs = @("apprentissage", "data-ml", "ia-agents", "infra", "jeux", "outils", "pro")
foreach ($od in $oldDirs) {
    $odPath = Join-Path $BASE_DIR $od
    if ((Test-Path $odPath) -and ((Get-ChildItem -Path $odPath -Force | Measure-Object).Count -eq 0)) {
        Remove-Item -Path $odPath -Force
    }
}

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "  Terminé ! Arborescence Windows et dépôts synchronisés avec succès." -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green
