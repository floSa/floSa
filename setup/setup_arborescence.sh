#!/usr/bin/env bash
# ==============================================================================
# Script de reproduction et synchronisation automatique de l'arborescence (Linux / WSL / macOS)
# Usage :
#   bash setup_arborescence.sh [TARGET_DIR]
# Exemples :
#   bash setup_arborescence.sh ~/mes_projets
#   bash setup_arborescence.sh .
# ==============================================================================

set -uo pipefail

if [ -n "${1:-}" ]; then
    BASE_DIR="$1"
elif [ -d "$(dirname "$0")/../../../Productivite/floSa" ]; then
    BASE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
elif [ -d "$(dirname "$0")/../../setup" ]; then
    BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
else
    BASE_DIR="$(pwd)"
fi

mkdir -p "$BASE_DIR"
BASE_DIR="$(cd "$BASE_DIR" && pwd)"

echo "=== Gestion et synchronisation de l'arborescence dans $BASE_DIR ==="

# Gestion du dossier hors git (préservation absolue et lien symbolique)
if [ -d "$BASE_DIR/_hors-git" ] && [ ! -e "$BASE_DIR/_hors_git" ]; then
    ln -s "_hors-git" "$BASE_DIR/_hors_git"
elif [ -d "$BASE_DIR/_hors_git" ] && [ ! -e "$BASE_DIR/_hors-git" ]; then
    ln -s "_hors_git" "$BASE_DIR/_hors-git"
elif [ ! -d "$BASE_DIR/_hors-git" ] && [ ! -d "$BASE_DIR/_hors_git" ]; then
    mkdir -p "$BASE_DIR/_hors_git/docs"
fi

# Création des répertoires cibles
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

# Fonction pour réparer les chemins dans un .venv après déplacement
repair_venv() {
    local venv_dir="$1"
    local old_path="$2"
    local new_path="$3"
    local bin_dir="$venv_dir/bin"
    [ ! -d "$bin_dir" ] && return 0

    for act in activate activate.csh activate.fish activate.nu activate.ps1; do
        if [ -f "$bin_dir/$act" ]; then
            sed -i "s|$old_path|$new_path|g" "$bin_dir/$act" 2>/dev/null || true
        fi
    done

    for bin_file in "$bin_dir"/*; do
        if [ -f "$bin_file" ] && [ ! -L "$bin_file" ]; then
            if head -n 1 "$bin_file" | grep -q "$old_path" 2>/dev/null; then
                sed -i "1s|$old_path|$new_path|" "$bin_file" 2>/dev/null || true
            fi
        fi
    done
}

# Fonction intelligente : Détection -> Migration -> Clonage -> Pull
sync_repo() {
    local repo_url="$1"
    local target_rel="$2"
    local target_full="$BASE_DIR/$target_rel"
    local repo_name; repo_name="$(basename "$target_rel")"

    # 1. Si déjà présent à l'emplacement cible
    if [ -d "$target_full/.git" ]; then
        echo -n "[DÉJÀ EN PLACE] $target_rel ... "
        # Mise à jour si propre
        if [ -z "$(git -C "$target_full" status --porcelain 2>/dev/null)" ]; then
            git -C "$target_full" pull --ff-only -q 2>/dev/null && echo "pull OK" || echo "pull ignoré (divergence ou branche locale)"
        else
            echo "modifs locales détectées, pull ignoré"
        fi
        return 0
    fi

    # 2. Si le projet existe ailleurs dans BASE_DIR (migration d'ancienne arborescence)
    local found_dir=""
    while IFS= read -r match_dir; do
        if [ -d "$match_dir/.git" ] && [ "$match_dir" != "$target_full" ]; then
            # Ignorer _hors-git
            case "$match_dir" in
                *"_hors-git"*|*"_hors_git"*) continue ;;
            esac
            found_dir="$match_dir"
            break
        fi
    done < <(find "$BASE_DIR" -maxdepth 4 -type d -name "$repo_name" 2>/dev/null)

    # Cas particulier : Mes-Skills -> claude-skills
    if [ -z "$found_dir" ] && [ "$repo_name" = "claude-skills" ]; then
        while IFS= read -r match_dir; do
            if [ -d "$match_dir/.git" ]; then
                found_dir="$match_dir"
                break
            fi
        done < <(find "$BASE_DIR" -maxdepth 4 -type d -name "Mes-Skills" 2>/dev/null)
    fi

    if [ -n "$found_dir" ]; then
        echo "[MIGRATION] $found_dir -> $target_rel"
        mkdir -p "$(dirname "$target_full")"
        mv "$found_dir" "$target_full"
        if [ -d "$target_full/.venv" ]; then
            repair_venv "$target_full/.venv" "$found_dir" "$target_full"
        fi
        if [ -z "$(git -C "$target_full" status --porcelain 2>/dev/null)" ]; then
            git -C "$target_full" pull --ff-only -q 2>/dev/null || true
        fi
        return 0
    fi

    # 3. Si introuvable en local : clonage avec SSH et repli HTTPS
    echo "[CLONAGE] $repo_url -> $target_rel"
    mkdir -p "$(dirname "$target_full")"
    if ! git clone -q "$repo_url" "$target_full" 2>/dev/null; then
        local fallback_url="${repo_url/git@github.com-perso:/https:\/\/github.com\/}"
        echo "  -> Tentative repli HTTPS: $fallback_url"
        git clone -q "$fallback_url" "$target_full"
    fi
}

# --- Autres-Projets ---
sync_repo "git@github.com-perso:floSa/Atlas-Metiers-Roadmaps.git" "Autres-Projets/Atlas-Metiers-Roadmaps"
sync_repo "git@github.com-perso:floSa/Cardmarket-Wantlist-Optimizer.git" "Autres-Projets/Cardmarket-Wantlist-Optimizer"
sync_repo "git@github.com-perso:floSa/Planning-Usine-CPSAT.git" "Autres-Projets/Planning-Usine-CPSAT"
sync_repo "git@github.com-perso:floSa/PowerVision-S1-Backup.git" "Autres-Projets/PowerVision-S1-Backup"
sync_repo "git@github.com-perso:floSa/Reels-Instagram-Graph-MD.git" "Autres-Projets/Reels-Instagram-Graph-MD"
sync_repo "git@github.com-perso:floSa/Template-services-docker.git" "Autres-Projets/Template-Services-Docker"
sync_repo "git@github.com-perso:floSa/Test-pre-entretien-technique.git" "Autres-Projets/Test-Pre-Entretien-Technique"

# --- Jeu ---
sync_repo "git@github.com-perso:floSa/7Wonders-BoardGame.git" "Jeu/Board-Games/7Wonders-BoardGame"
sync_repo "git@github.com-perso:floSa/Dracula-VS-Van-Helsing-BoardGame.git" "Jeu/Board-Games/Dracula-VS-Van-Helsing-BoardGame"
sync_repo "git@github.com-perso:floSa/Sea-Salt-And-Paper-BoardGame.git" "Jeu/Board-Games/Sea-Salt-And-Paper-BoardGame"
sync_repo "git@github.com-perso:floSa/Toy-Battle-BoardGame.git" "Jeu/Board-Games/Toy-Battle-BoardGame"
sync_repo "git@github.com-perso:floSa/Courtisans-BoardGame.git" "Jeu/Courtisan/Courtisans-BoardGame"
sync_repo "git@github.com-perso:floSa/Courtisans-IA-Game.git" "Jeu/Courtisan/Courtisans-IA-Game"
sync_repo "git@github.com-perso:floSa/Crossy-Road-AI-Game.git" "Jeu/IA/Crossy-Road-AI-Game"
sync_repo "git@github.com-perso:floSa/Quiz-Geo.git" "Jeu/Quiz/Quiz-Geo"
sync_repo "git@github.com-perso:floSa/Quiz-Hist.git" "Jeu/Quiz/Quiz-Hist"
sync_repo "git@github.com-perso:floSa/Urban-Rivals-Game.git" "Jeu/Urban-Rivals/Urban-Rivals-Game"
sync_repo "git@github.com-perso:floSa/Urban-Rivals-Scraper.git" "Jeu/Urban-Rivals/Urban-Rivals-Scraper"

# --- Projet-ML-DL ---
sync_repo "git@github.com-perso:floSa/Analyse-Esperance-De-Vie-FR.git" "Projet-ML-DL/Analyse-Esperance-De-Vie-FR"
sync_repo "git@github.com-perso:floSa/Analyse-Habitudes-Alimentaires.git" "Projet-ML-DL/Analyse-Habitudes-Alimentaires"
sync_repo "git@github.com-perso:floSa/Analyse-Vente-Prosol.git" "Projet-ML-DL/Analyse-Vente-Prosol"
sync_repo "git@github.com-perso:floSa/Annotation-Images.git" "Projet-ML-DL/Annotation-Images"
sync_repo "git@github.com-perso:floSa/Annotation-Text-Streamlit.git" "Projet-ML-DL/Annotation-Text-Streamlit"
sync_repo "git@github.com-perso:floSa/Classification-Bulles.git" "Projet-ML-DL/Classification-Bulles"
sync_repo "git@github.com-perso:floSa/Defi-IA-2019.git" "Projet-ML-DL/Defis-IA/Defi-IA-2019"
sync_repo "git@github.com-perso:floSa/Defi-IA-2020.git" "Projet-ML-DL/Defis-IA/Defi-IA-2020"
sync_repo "git@github.com-perso:floSa/Defi-IA-2021.git" "Projet-ML-DL/Defis-IA/Defi-IA-2021"
sync_repo "git@github.com-perso:floSa/Defi-IA-2022.git" "Projet-ML-DL/Defis-IA/Defi-IA-2022"
sync_repo "git@github.com-perso:floSa/Defi-IA-2023.git" "Projet-ML-DL/Defis-IA/Defi-IA-2023"
sync_repo "git@github.com-perso:floSa/Detection-Pneumonie-Radio.git" "Projet-ML-DL/Detection-Pneumonie-Radio"
sync_repo "git@github.com-perso:floSa/Images-collection-clean.git" "Projet-ML-DL/Images-Collection-Clean"
sync_repo "git@github.com-perso:floSa/Notebooks-Cheat-Sheet.git" "Projet-ML-DL/Notebooks-Cheat-Sheet"
sync_repo "git@github.com-perso:floSa/sales-ops-planning-poc.git" "Projet-ML-DL/Sales-Ops-Planning-POC"

# --- Projet-IA ---
sync_repo "git@github.com-perso:floSa/Agents-MCP-Orchestration.git" "Projet-IA/Agents-MCP-Orchestration"
sync_repo "git@github.com-perso:floSa/data-analyst-agent.git" "Projet-IA/Data-Analyst-Agent"
sync_repo "git@github.com-perso:floSa/llm-service.git" "Projet-IA/LLM-Service"
sync_repo "git@github.com-perso:floSa/MCP_maison.git" "Projet-IA/MCP-Maison"
sync_repo "git@github.com-perso:floSa/rag-agent-chat.git" "Projet-IA/RAG-Agent-Chat"
sync_repo "git@github.com-perso:floSa/RAG-Eval-Bench.git" "Projet-IA/RAG-Eval-Bench"
sync_repo "git@github.com-perso:floSa/rag-ingestion-pipeline.git" "Projet-IA/RAG-Ingestion-Pipeline"
sync_repo "git@github.com-perso:floSa/traceable-agent.git" "Projet-IA/Traceable-Agent"

# --- Musique ---
sync_repo "git@github.com-perso:floSa/Bibliotheque-Musicale.git" "Musique/Bibliotheque-Musicale"
sync_repo "git@github.com-perso:floSa/Classification-Genres-Musicaux.git" "Musique/Classification-Genres-Musicaux"
sync_repo "git@github.com-perso:floSa/karaokit.git" "Musique/Karaokit"

# --- Productivite ---
sync_repo "git@github.com-perso:floSa/Boite-A-Outils.git" "Productivite/Boite-A-Outils"
sync_repo "git@github.com-perso:floSa/Brain-Kit.git" "Productivite/Brain-Kit"
sync_repo "git@github.com-perso:floSa/Catalogue-Comparateur-Solutions-IA.git" "Productivite/Catalogue-Comparateur-Solutions-IA"
sync_repo "git@github.com-perso:floSa/Dev-Brain.git" "Productivite/Dev-Brain"
sync_repo "git@github.com-perso:floSa/Fast-HTML-To-MD.git" "Productivite/Fast-HTML-To-MD"
sync_repo "git@github.com-perso:floSa/Outil-Dictee-Audio.git" "Productivite/Outil-Dictee-Audio"
sync_repo "git@github.com-perso:floSa/Veille-Repo.git" "Productivite/Veille-Repo"
sync_repo "git@github.com-perso:floSa/mes-skills.git" "Productivite/claude-skills"
sync_repo "git@github.com-perso:floSa/floSa.git" "Productivite/floSa"

# --- Tutoriels ---
sync_repo "git@github.com-perso:floSa/Tuto-Dagster.git" "Tutoriels/Tuto-Dagster"
sync_repo "git@github.com-perso:floSa/Tuto-MLflow.git" "Tutoriels/Tuto-MLflow"
sync_repo "git@github.com-perso:floSa/Tuto-openmetadata.git" "Tutoriels/Tuto-OpenMetadata"

# Nettoyage des anciens dossiers orphelins vides
for old_d in apprentissage data-ml ia-agents infra jeux outils pro; do
    if [ -d "$BASE_DIR/$old_d" ] && [ -z "$(ls -A "$BASE_DIR/$old_d" 2>/dev/null)" ]; then
        rmdir "$BASE_DIR/$old_d"
    fi
done

echo "=== Terminé ! Arborescence synchronisée avec succès. ==="
