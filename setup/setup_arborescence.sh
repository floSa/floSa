#!/usr/bin/env bash
# ==============================================================================
# Script de reproduction automatique de l'arborescence (Linux / WSL / macOS)
# Usage :
#   bash setup_arborescence.sh [TARGET_DIR]
# Exemples :
#   bash setup_arborescence.sh ~/mes_projets
#   bash setup_arborescence.sh .
# ==============================================================================

set -e

if [ -n "$1" ]; then
    BASE_DIR="$1"
elif [ -d "$(dirname "$0")/../../Productivite/floSa" ]; then
    BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
else
    BASE_DIR="$(pwd)"
fi

mkdir -p "$BASE_DIR"
BASE_DIR="$(cd "$BASE_DIR" && pwd)"

echo "=== Initialisation de l'arborescence dans $BASE_DIR ==="

mkdir -p "$BASE_DIR/_hors_git/docs"
mkdir -p "$BASE_DIR/Autres-Projets"
mkdir -p "$BASE_DIR/Jeu/Board-Games"
mkdir -p "$BASE_DIR/Jeu/Courtisan"
mkdir -p "$BASE_DIR/Jeu/IA"
mkdir -p "$BASE_DIR/Jeu/Quiz"
mkdir -p "$BASE_DIR/Jeu/Urban-Rivals"
mkdir -p "$BASE_DIR/Projet-ML-DL/Defis-IA"
mkdir -p "$BASE_DIR/Projet-IA"
mkdir -p "$BASE_DIR/Musique"
mkdir -p "$BASE_DIR/Productivite"
mkdir -p "$BASE_DIR/Tutoriels"

clone_repo() {
    local repo_url="$1"
    local target_dir="$2"
    if [ -d "$BASE_DIR/$target_dir/.git" ]; then
        echo "[DÉJÀ INSTALLÉ] $target_dir"
    else
        echo "[CLONAGE] $repo_url -> $target_dir"
        git clone "$repo_url" "$BASE_DIR/$target_dir" || git clone "${repo_url/git@github.com-perso:/https:\/\/github.com\/}" "$BASE_DIR/$target_dir"
    fi
}

# --- Autres-Projets ---
clone_repo "git@github.com-perso:floSa/Atlas-Metiers-Roadmaps.git" "Autres-Projets/Atlas-Metiers-Roadmaps"
clone_repo "git@github.com-perso:floSa/Cardmarket-Wantlist-Optimizer.git" "Autres-Projets/Cardmarket-Wantlist-Optimizer"
clone_repo "https://github.com/floSa/Planning-Usine-CPSAT.git" "Autres-Projets/Planning-Usine-CPSAT"
clone_repo "git@github.com-perso:floSa/Reels-Instagram-Graph-MD.git" "Autres-Projets/Reels-Instagram-Graph-MD"
clone_repo "https://github.com/floSa/Template-Services-Docker.git" "Autres-Projets/Template-Services-Docker"
clone_repo "git@github.com-perso:floSa/Test-Pre-Entretien-Technique.git" "Autres-Projets/Test-Pre-Entretien-Technique"

# --- Jeu ---
clone_repo "git@github.com-perso:floSa/7Wonders-BoardGame.git" "Jeu/Board-Games/7Wonders-BoardGame"
clone_repo "git@github.com-perso:floSa/Dracula-VS-Van-Helsing-BoardGame.git" "Jeu/Board-Games/Dracula-VS-Van-Helsing-BoardGame"
clone_repo "git@github.com-perso:floSa/Sea-Salt-And-Paper-BoardGame.git" "Jeu/Board-Games/Sea-Salt-And-Paper-BoardGame"
clone_repo "git@github.com-perso:floSa/Toy-Battle-BoardGame.git" "Jeu/Board-Games/Toy-Battle-BoardGame"
clone_repo "git@github.com-perso:floSa/Courtisans-BoardGame.git" "Jeu/Courtisan/Courtisans-BoardGame"
clone_repo "git@github.com-perso:floSa/Courtisans-IA-Game.git" "Jeu/Courtisan/Courtisans-IA-Game"
clone_repo "https://github.com/floSa/Crossy-Road-AI-Game.git" "Jeu/IA/Crossy-Road-AI-Game"
clone_repo "git@github.com-perso:floSa/Quiz-Geo.git" "Jeu/Quiz/Quiz-Geo"
clone_repo "git@github.com-perso:floSa/Quiz-Hist.git" "Jeu/Quiz/Quiz-Hist"
clone_repo "git@github.com-perso:floSa/Urban-Rivals-Game.git" "Jeu/Urban-Rivals/Urban-Rivals-Game"
clone_repo "https://github.com/floSa/Urban-Rivals-Scraper.git" "Jeu/Urban-Rivals/Urban-Rivals-Scraper"

# --- Projet-ML-DL ---
clone_repo "https://github.com/floSa/Analyse-Esperance-De-Vie-FR.git" "Projet-ML-DL/Analyse-Esperance-De-Vie-FR"
clone_repo "git@github.com-perso:floSa/Analyse-Habitudes-Alimentaires.git" "Projet-ML-DL/Analyse-Habitudes-Alimentaires"
clone_repo "https://github.com/floSa/Analyse-Vente-Prosol.git" "Projet-ML-DL/Analyse-Vente-Prosol"
clone_repo "https://github.com/floSa/Annotation-Images.git" "Projet-ML-DL/Annotation-Images"
clone_repo "git@github.com-perso:floSa/Annotation-Text-Streamlit.git" "Projet-ML-DL/Annotation-Text-Streamlit"
clone_repo "git@github.com-perso:floSa/Classification-Bulles.git" "Projet-ML-DL/Classification-Bulles"
clone_repo "git@github.com-perso:floSa/Defi-IA-2019.git" "Projet-ML-DL/Defis-IA/Defi-IA-2019"
clone_repo "git@github.com-perso:floSa/Defi-IA-2020.git" "Projet-ML-DL/Defis-IA/Defi-IA-2020"
clone_repo "git@github.com-perso:floSa/Defi-IA-2021.git" "Projet-ML-DL/Defis-IA/Defi-IA-2021"
clone_repo "git@github.com-perso:floSa/Defi-IA-2022.git" "Projet-ML-DL/Defis-IA/Defi-IA-2022"
clone_repo "git@github.com-perso:floSa/Defi-IA-2023.git" "Projet-ML-DL/Defis-IA/Defi-IA-2023"
clone_repo "https://github.com/floSa/Detection-Pneumonie-Radio.git" "Projet-ML-DL/Detection-Pneumonie-Radio"
clone_repo "git@github.com-perso:floSa/Notebooks-Cheat-Sheet.git" "Projet-ML-DL/Notebooks-Cheat-Sheet"
clone_repo "git@github.com-perso:floSa/Sales-Ops-Planning-POC.git" "Projet-ML-DL/Sales-Ops-Planning-POC"

# --- Projet-IA ---
clone_repo "git@github.com-perso:floSa/Agents-MCP-Orchestration.git" "Projet-IA/Agents-MCP-Orchestration"
clone_repo "https://github.com/floSa/Data-Analyst-Agent.git" "Projet-IA/Data-Analyst-Agent"
clone_repo "git@github.com-perso:floSa/LLM-Service.git" "Projet-IA/LLM-Service"
clone_repo "https://github.com/floSa/MCP-Maison.git" "Projet-IA/MCP-Maison"
clone_repo "https://github.com/floSa/RAG-Agent-Chat.git" "Projet-IA/RAG-Agent-Chat"
clone_repo "git@github.com-perso:floSa/RAG-Eval-Bench.git" "Projet-IA/RAG-Eval-Bench"
clone_repo "https://github.com/floSa/RAG-Ingestion-Pipeline.git" "Projet-IA/RAG-Ingestion-Pipeline"
clone_repo "git@github.com-perso:floSa/Traceable-Agent.git" "Projet-IA/Traceable-Agent"

# --- Musique ---
clone_repo "git@github.com-perso:floSa/Bibliotheque-Musicale.git" "Musique/Bibliotheque-Musicale"
clone_repo "git@github.com-perso:floSa/Classification-Genres-Musicaux.git" "Musique/Classification-Genres-Musicaux"
clone_repo "git@github.com-perso:floSa/Karaokit.git" "Musique/Karaokit"

# --- Productivite ---
clone_repo "https://github.com/floSa/Boite-A-Outils.git" "Productivite/Boite-A-Outils"
clone_repo "git@github.com-perso:floSa/Brain-Kit.git" "Productivite/Brain-Kit"
clone_repo "git@github.com-perso:floSa/Catalogue-Comparateur-Solutions-IA.git" "Productivite/Catalogue-Comparateur-Solutions-IA"
clone_repo "git@github.com-perso:floSa/Fast-HTML-To-MD.git" "Productivite/Fast-HTML-To-MD"
clone_repo "git@github.com-perso:floSa/Outil-Dictee-Audio.git" "Productivite/Outil-Dictee-Audio"
clone_repo "git@github.com-perso:floSa/Veille-Repo.git" "Productivite/Veille-Repo"
clone_repo "git@github.com-perso:floSa/Mes-Skills.git" "Productivite/claude-skills"
clone_repo "https://github.com/floSa/floSa.git" "Productivite/floSa"

# --- Tutoriels ---
clone_repo "git@github.com-perso:floSa/Tuto-Dagster.git" "Tutoriels/Tuto-Dagster"
clone_repo "git@github.com-perso:floSa/Tuto-MLflow.git" "Tutoriels/Tuto-MLflow"
clone_repo "git@github.com-perso:floSa/Tuto-OpenMetadata.git" "Tutoriels/Tuto-OpenMetadata"

echo "=== Terminé ! Arborescence reproduite avec succès. ==="
