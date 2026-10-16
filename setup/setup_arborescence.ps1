# ==============================================================================
# Script de reproduction, migration et synchronisation automatique de l'arborescence Windows (PowerShell)
#
# RÈGLE IMPORTANTE SUR '_hors_git' :
# Le dossier '_hors_git' est strictement réservé aux données locales propres à la
# machine hôte (sauvegardes, caches, documents locaux, projets hors git).
# Il est STRICTEMENT SANCTUARISÉ : ce script ne modifie, ne déplace et ne supprime
# JAMAIS son contenu existant. Il n'y fait qu'ajouter : les dossiers non versionnés
# trouvés dans l'arborescence y sont rangés (jamais supprimés).
#
# Ce que fait le script, dans l'ordre :
#   1. clone / migre / met à jour (pull --ff-only) tous les dépôts du référentiel ;
#   2. signale les commits non poussés (-Push les pousse) et les modifs locales ;
#   3. range dans _hors_git tout dossier hors référentiel qui n'est pas réellement
#      dans Git : non versionné, git init sans remote, ou branche jamais poussée.
#      Un dépôt hors référentiel réellement poussé, ou dont le remote est
#      injoignable, est seulement signalé ;
#   4. installe / met à jour les skills de ~\.claude\skills (copies, car Windows
#      refuse les liens symboliques sans droits admin) et les plugins
#      (i-have-adhd, ponytail), sauf avec -NoSkills.
#
# Usage :
#   .\setup_arborescence.ps1 [-TargetDir "C:\chemin\vers\Projets"] [-Push] [-NoSkills]
#
# Ce fichier doit rester en UTF-8 AVEC BOM : Windows PowerShell 5.1 lit sinon les
# accents de travers et le script ne se charge plus.
# ==============================================================================

param(
    [string]$TargetDir = "",
    [switch]$Push,
    [switch]$NoSkills
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

$script:Leaves = @{}
$script:Groups = @{}

function Sync-Repo($url, $targetRelPath) {
    $targetPath = Join-Path $BASE_DIR $targetRelPath
    $repoName = Split-Path -Leaf $targetRelPath

    # Référentiel : dépôts (feuilles) et leurs dossiers parents (groupes), pour l'étape hors-référentiel
    $script:Leaves[$targetRelPath] = $true
    $parent = Split-Path -Parent $targetRelPath
    while ($parent) { $script:Groups[$parent] = $true; $parent = Split-Path -Parent $parent }

    # 1. Si déjà en place
    if (Test-Path (Join-Path $targetPath ".git")) {
        Write-Host -NoNewline "[DÉJÀ EN PLACE] $targetRelPath ... " -ForegroundColor Gray
        $ahead = [int](git -C $targetPath rev-list --count '@{u}..HEAD' 2>$null)
        if ($ahead -gt 0) {
            $pushed = $false
            if ($Push) { git -C $targetPath push -q 2>$null; $pushed = ($LASTEXITCODE -eq 0) }
            if ($pushed) { Write-Host -NoNewline "$ahead commit(s) poussés, " -ForegroundColor Green }
            else { Write-Host -NoNewline "$ahead commit(s) NON POUSSÉS, " -ForegroundColor Yellow }
        }
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
    $aliases = @($repoName -replace '_', '-'); if ($repoName -eq 'Mes-Skills') { $aliases += 'claude-skills' }
    $candidates = Get-ChildItem -Path $BASE_DIR -Directory -Recurse -Depth 3 -ErrorAction SilentlyContinue |
        Where-Object { ($aliases -contains ($_.Name -replace '_', '-')) -and (Test-Path (Join-Path $_.FullName ".git")) -and ($_.FullName -ne $targetPath) -and ($_.FullName -notmatch "_hors[-_]git") }

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
    git -c core.longpaths=true clone $url $targetPath
    if ($LASTEXITCODE -ne 0) {
        $fallbackUrl = $url -replace "git@github\.com-perso:", "https://github.com/"
        Write-Host "  -> Repli HTTPS: $fallbackUrl" -ForegroundColor Yellow
        git -c core.longpaths=true clone $fallbackUrl $targetPath
    }
}

# --- Autres-Projets ---
Sync-Repo "git@github.com-perso:floSa/Atlas-Metiers-Roadmaps.git" "Autres-Projets\Atlas-Metiers-Roadmaps"
Sync-Repo "git@github.com-perso:floSa/Cardmarket-Wantlist-Optimizer.git" "Autres-Projets\Cardmarket-Wantlist-Optimizer"
Sync-Repo "git@github.com-perso:floSa/Planning-Usine-CPSAT.git" "Autres-Projets\Planning-Usine-CPSAT"
Sync-Repo "git@github.com-perso:floSa/PowerVision-S1-Backup.git" "Autres-Projets\PowerVision-S1-Backup"
Sync-Repo "git@github.com-perso:floSa/Reels-Instagram-Graph-MD.git" "Autres-Projets\Reels-Instagram-Graph-MD"
Sync-Repo "git@github.com-perso:floSa/Template-Services-Docker.git" "Autres-Projets\Template-Services-Docker"
Sync-Repo "git@github.com-perso:floSa/Test-Pre-Entretien-Technique.git" "Autres-Projets\Test-Pre-Entretien-Technique"

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
Sync-Repo "git@github.com-perso:floSa/Images-Collection-Clean.git" "Projet-ML-DL\Images-Collection-Clean"
Sync-Repo "git@github.com-perso:floSa/Notebooks-Cheat-Sheet.git" "Projet-ML-DL\Notebooks-Cheat-Sheet"
Sync-Repo "git@github.com-perso:floSa/Sales-Ops-Planning-POC.git" "Projet-ML-DL\Sales-Ops-Planning-POC"

# --- Projet-IA ---
Sync-Repo "git@github.com-perso:floSa/Agents-MCP-Orchestration.git" "Projet-IA\Agents-MCP-Orchestration"
Sync-Repo "git@github.com-perso:floSa/Data-Analyst-Agent.git" "Projet-IA\Data-Analyst-Agent"
Sync-Repo "git@github.com-perso:floSa/LLM-Service.git" "Projet-IA\LLM-Service"
Sync-Repo "git@github.com-perso:floSa/MCP-Maison.git" "Projet-IA\MCP-Maison"
Sync-Repo "git@github.com-perso:floSa/RAG-Agent-Chat.git" "Projet-IA\RAG-Agent-Chat"
Sync-Repo "git@github.com-perso:floSa/RAG-Eval-Bench.git" "Projet-IA\RAG-Eval-Bench"
Sync-Repo "git@github.com-perso:floSa/RAG-Ingestion-Pipeline.git" "Projet-IA\RAG-Ingestion-Pipeline"
Sync-Repo "git@github.com-perso:floSa/Traceable-Agent.git" "Projet-IA\Traceable-Agent"

# --- Musique ---
Sync-Repo "git@github.com-perso:floSa/Bibliotheque-Musicale.git" "Musique\Bibliotheque-Musicale"
Sync-Repo "git@github.com-perso:floSa/Classification-Genres-Musicaux.git" "Musique\Classification-Genres-Musicaux"
Sync-Repo "git@github.com-perso:floSa/Karaokit.git" "Musique\Karaokit"

# --- Productivite ---
Sync-Repo "git@github.com-perso:floSa/Aosis-Deck-Builder.git" "Productivite\Aosis-Deck-Builder"
Sync-Repo "git@github.com-perso:floSa/Boite-A-Outils.git" "Productivite\Boite-A-Outils"
Sync-Repo "git@github.com-perso:floSa/Brain-Kit.git" "Productivite\Brain-Kit"
Sync-Repo "git@github.com-perso:floSa/Catalogue-Comparateur-Solutions-IA.git" "Productivite\Catalogue-Comparateur-Solutions-IA"
Sync-Repo "git@github.com-perso:floSa/Dev-Brain.git" "Productivite\Dev-Brain"
Sync-Repo "git@github.com-perso:floSa/Fast-HTML-To-MD.git" "Productivite\Fast-HTML-To-MD"
Sync-Repo "git@github.com-perso:floSa/Outil-Dictee-Audio.git" "Productivite\Outil-Dictee-Audio"
Sync-Repo "git@github.com-perso:floSa/Veille-Repo.git" "Productivite\Veille-Repo"
Sync-Repo "git@github.com-perso:floSa/Mes-Skills.git" "Productivite\Mes-Skills"
Sync-Repo "git@github.com-perso:floSa/floSa.git" "Productivite\floSa"

# --- Tutoriels ---
Sync-Repo "git@github.com-perso:floSa/LMStudio-Bionic.git" "Tutoriels\LMStudio-Bionic"
Sync-Repo "git@github.com-perso:floSa/Tuto-Dagster.git" "Tutoriels\Tuto-Dagster"
Sync-Repo "git@github.com-perso:floSa/Tuto-MLflow.git" "Tutoriels\Tuto-MLflow"
Sync-Repo "git@github.com-perso:floSa/Tuto-OpenMetadata.git" "Tutoriels\Tuto-OpenMetadata"

# --- Projets hors référentiel : jamais supprimés, rangés dans _hors_git ---
# Un dossier inconnu, non vide et pas réellement dans Git est DÉPLACÉ dans _hors_git
# (nom suffixé de la date en cas de collision). Un dossier inconnu réellement poussé,
# ou dont le remote est injoignable, est seulement SIGNALÉ : à toi de l'ajouter au
# référentiel ou de le ranger.
Write-Host "`n--- Projets hors référentiel ---" -ForegroundColor Cyan
$script:Flagged = $false

# Un `git init` ne suffit pas : un projet n'est « dans Git » que s'il a un remote origin
# dont le dépôt existe ET dont la branche courante existe côté remote, sans commit en
# retard. Verdict : pousse | deplacer:<raison> | examiner:<raison>.
# Remote injoignable (hors ligne, droits) = examiner, jamais déplacé.
function Get-PushVerdict($d) {
    $url = git -C $d remote get-url origin 2>$null
    if (-not $url) { return "deplacer:git init sans remote" }
    git -C $d rev-parse --verify -q HEAD 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) { return "deplacer:aucun commit" }
    $br = git -C $d rev-parse --abbrev-ref HEAD 2>$null
    $heads = git -C $d ls-remote --heads origin 2>$null
    if ($LASTEXITCODE -ne 0) { return "examiner:remote injoignable ou inexistant ($url)" }
    if (-not ($heads | Where-Object { $_ -match "refs/heads/$([regex]::Escape($br))$" })) { return "deplacer:branche $br jamais poussée" }
    $orph = @(git -C $d rev-list --branches --not --remotes 2>$null).Count; $stash = @(git -C $d stash list 2>$null).Count
    if ($orph -gt 0 -or $stash -gt 0) { return "examiner:$orph commit(s) sur des branches jamais poussées, $stash stash(s)" }
    git -C $d fetch -q origin $br 2>$null
    $ahead = [int](git -C $d rev-list --count "origin/$br..HEAD" 2>$null)
    if ($ahead -gt 0) {
        if ($Push) { git -C $d push -q origin $br 2>$null; if ($LASTEXITCODE -eq 0) { return "pousse" } }
        return "examiner:$ahead commit(s) non poussés"
    }
    return "pousse"
}
function Find-Unknown($dir) {
    foreach ($item in (Get-ChildItem -Path $dir -Directory -Force | Sort-Object Name)) {
        $name = $item.Name
        if ($name.StartsWith(".") -or $name -eq "_hors_git" -or $name -eq "_hors-git") { continue }
        if ($item.LinkType) { continue }
        $rel = $item.FullName.Substring($BASE_DIR.Length).TrimStart('\')
        if ($script:Leaves.ContainsKey($rel)) { continue }
        if ($script:Groups.ContainsKey($rel)) { Find-Unknown $item.FullName; continue }
        $script:Flagged = $true
        $verdict = "deplacer:non versionné"
        if (Test-Path (Join-Path $item.FullName ".git")) {
            $verdict = Get-PushVerdict $item.FullName
        } elseif (Get-ChildItem -Path $item.FullName -Directory -Recurse -Depth 3 -Force -Filter ".git" -ErrorAction SilentlyContinue | Select-Object -First 1) {
            $verdict = "examiner:contient des dépôts git imbriqués"
        } elseif (-not (Get-ChildItem -Path $item.FullName -Force | Select-Object -First 1)) {
            continue
        }
        if ($verdict -like "examiner:*") {
            Write-Host "[À EXAMINER] $rel : $($verdict.Substring(9)), non déplacé" -ForegroundColor Yellow
        } elseif ($verdict -eq "pousse") {
            Write-Host "[À EXAMINER] $rel : dépôt poussé ($(git -C $item.FullName remote get-url origin)) mais absent du référentiel, non déplacé" -ForegroundColor Yellow
        } else {
            $dest = Join-Path $horsGitUnder $name
            if (Test-Path $dest) { $dest = "${dest}_$(Get-Date -Format 'yyyyMMdd-HHmmss')" }
            Move-Item -LiteralPath $item.FullName -Destination $dest
            Write-Host "[HORS-GIT] $rel ($($verdict.Substring(9))) -> _hors_git\$(Split-Path -Leaf $dest)" -ForegroundColor Yellow
        }
    }
}
Find-Unknown $BASE_DIR
if (-not $script:Flagged) { Write-Host "Rien à ranger : l'arborescence ne contient que le référentiel." -ForegroundColor Gray }

# Nettoyage
$oldDirs = @("apprentissage", "data-ml", "ia-agents", "infra", "jeux", "outils", "pro")
foreach ($od in $oldDirs) {
    $odPath = Join-Path $BASE_DIR $od
    if ((Test-Path $odPath) -and ((Get-ChildItem -Path $odPath -Force | Measure-Object).Count -eq 0)) {
        Remove-Item -Path $odPath -Force
    }
}

# --- Skills et plugins : installation / mise à jour ---
# Source des skills : Productivite\Mes-Skills (install.sh) + skills de projet de
# Productivite\Dev-Brain\.claude\skills. Windows refuse les liens symboliques sans
# droits admin : copies (--mode copy), donc ce script les rafraîchit à chaque passage.
# BMAD n'est pas ici : il s'installe projet par projet (voir le message final).
if (-not $NoSkills) {
    Write-Host "`n--- Skills et plugins ---" -ForegroundColor Cyan
    $skRepo = Join-Path $BASE_DIR "Productivite\Mes-Skills"
    $skTarget = if ($env:CLAUDE_SKILLS_DIR) { $env:CLAUDE_SKILLS_DIR } else { Join-Path $HOME ".claude\skills" }
    # bash de Git for Windows (et non celui de WSL, qui est dans le PATH de System32)
    $gitExe = (Get-Command git -ErrorAction SilentlyContinue).Source
    $bash = $null
    if ($gitExe) { $cand = Join-Path (Split-Path (Split-Path $gitExe)) "bin\bash.exe"; if (Test-Path $cand) { $bash = $cand } }
    if (-not (Test-Path (Join-Path $skRepo "install.sh"))) {
        Write-Host "  $skRepo\install.sh introuvable : skills non installés (dépôt Mes-Skills absent ?)" -ForegroundColor Yellow
    } elseif (-not $bash) {
        Write-Host "  bash de Git for Windows introuvable : skills non installés" -ForegroundColor Yellow
    } else {
        # --force : remplace l'ancienne copie par la version du dépôt (source de vérité).
        # Seuls les skills du dépôt sont touchés, pas les autres dossiers de la cible.
        # Sauvegarde avant remplacement : une copie locale modifiée n'est jamais perdue.
        $bakDir = Join-Path $BASE_DIR "_hors_git\sauvegarde-skills_$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        $hashes = { param($r) Get-ChildItem $r -Recurse -File -Force | Where-Object { $_.FullName -notmatch '__pycache__' } | ForEach-Object { $_.FullName.Substring($r.Length) + ':' + (Get-FileHash $_.FullName).Hash } | Sort-Object }
        function Save-IfDiffers($srcDir, $name) {
            $dst = Join-Path $skTarget $name
            if (-not (Test-Path $dst) -or (Get-Item $dst).LinkType) { return }
            if (Compare-Object @(& $hashes $srcDir) @(& $hashes $dst)) {
                New-Item -ItemType Directory -Force $bakDir | Out-Null
                Copy-Item $dst (Join-Path $bakDir $name) -Recurse
                Write-Host "  sauvegarde : $name -> $bakDir" -ForegroundColor Yellow
            }
        }
        foreach ($fam in "perso", "externes") {
            $famDir = Join-Path $skRepo "skills\$fam"
            if (Test-Path $famDir) { foreach ($sd in (Get-ChildItem $famDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") })) { Save-IfDiffers $sd.FullName $sd.Name } }
        }
        $env:HOME = $HOME
        $tgtArgs = if ($env:CLAUDE_SKILLS_DIR) { @("--target", $skTarget) } else { @() }
        & $bash (Join-Path $skRepo "install.sh") --mode copy --force @tgtArgs 2>&1 | ForEach-Object { "  $_" }
        $dbSk = Join-Path $BASE_DIR "Productivite\Dev-Brain\.claude\skills"
        if (Test-Path $dbSk) {
            foreach ($d in (Get-ChildItem $dbSk -Directory)) {
                if (-not (Test-Path (Join-Path $d.FullName "SKILL.md"))) { continue }
                $dst = Join-Path $skTarget $d.Name
                Save-IfDiffers $d.FullName $d.Name
                if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
                Copy-Item $d.FullName $dst -Recurse
                Write-Host "  ✓ $($d.Name) (Dev-Brain)"
            }
        }
        $outils = Join-Path $skRepo "outils-externes\install-outils.ps1"
        if (Test-Path $outils) {
            $plug = (& powershell -NoProfile -ExecutionPolicy Bypass -File $outils -Status 2>&1 | Out-String)
            $plug.TrimEnd() -split "`r?`n" | ForEach-Object { "  $_" }
            if ($plug -match '(i-have-adhd|ponytail)\s+Claude Code\s+absent') {
                Write-Host "  -> plugin(s) absent(s) : installation"
                & powershell -NoProfile -ExecutionPolicy Bypass -File $outils -Install claude 2>&1 | ForEach-Object { "  $_" }
            }
            Write-Host "  BMAD (par projet) : .\Productivite\Mes-Skills\outils-externes\install-outils.ps1 -Install bmad -Project <dossier>"
        }
        Write-Host "  Skills présents dans $skTarget :"
        Get-ChildItem $skTarget -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } | ForEach-Object { Write-Host "    - $($_.Name)" }
    }
}

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "  Terminé ! Arborescence Windows et dépôts synchronisés avec succès." -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green
