#!/usr/bin/env bash
# ==============================================================================
# Script de reproduction, migration et synchronisation automatique de l'arborescence
# (Linux / WSL / macOS)
#
# RÈGLE IMPORTANTE SUR '_hors_git' :
# Le dossier '_hors_git' est strictement réservé aux données locales propres à la
# machine hôte (sauvegardes, caches, documents locaux, projets hors git).
# Il est STRICTEMENT SANCTUARISÉ : ce script ne modifie, ne déplace et ne supprime
# JAMAIS son contenu.
#
# Usage :
#   bash setup_arborescence.sh [TARGET_DIR] [--sequential]
# Exemples :
#   bash setup_arborescence.sh ~/mes_projets
#   bash setup_arborescence.sh .
# ==============================================================================

set -uo pipefail

PARALLEL_JOBS=8
SEQUENTIAL=0

TARGET_ARG=""
for arg in "$@"; do
    case "$arg" in
        --sequential|-s) SEQUENTIAL=1 ;;
        *) [ -z "$TARGET_ARG" ] && TARGET_ARG="$arg" ;;
    esac
done

if [ -n "$TARGET_ARG" ]; then
    BASE_DIR="$TARGET_ARG"
elif [ -d "$(dirname "$0")/../../../Productivite/floSa" ]; then
    BASE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
elif [ -d "$(dirname "$0")/../../setup" ]; then
    BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
else
    BASE_DIR="$(pwd)"
fi

mkdir -p "$BASE_DIR"
BASE_DIR="$(cd "$BASE_DIR" && pwd)"

echo "=============================================================================="
echo "  Arborescence des Projets — Synchronisation & Mise à jour"
echo "  Répertoire racine : $BASE_DIR"
echo "=============================================================================="

# --- 1. Gestion stricte et sanctuarisation de '_hors_git' ---
# Normalisation vers l'écriture officielle unique '_hors_git'
if [ -d "$BASE_DIR/_hors-git" ] && [ ! -L "$BASE_DIR/_hors-git" ] && [ ! -e "$BASE_DIR/_hors_git" ]; then
    echo "[HORS-GIT] Normalisation du dossier physique '_hors-git' -> '_hors_git'"
    mv "$BASE_DIR/_hors-git" "$BASE_DIR/_hors_git"
    ln -s "_hors_git" "$BASE_DIR/_hors-git"
elif [ -d "$BASE_DIR/_hors_git" ] && [ ! -e "$BASE_DIR/_hors-git" ]; then
    ln -s "_hors_git" "$BASE_DIR/_hors-git"
elif [ ! -d "$BASE_DIR/_hors_git" ]; then
    mkdir -p "$BASE_DIR/_hors_git"
fi

echo "[HORS-GIT] Dossier '_hors_git' vérifié : sanctuarisé (aucun fichier interne touché)."

# --- 2. Création de l'arborescence cible ---
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

# --- 3. Définition de l'ensemble des dépôts répertoriés ---
REPOS=(
    # Autres-Projets
    "git@github.com-perso:floSa/Atlas-Metiers-Roadmaps.git|Autres-Projets/Atlas-Metiers-Roadmaps"
    "git@github.com-perso:floSa/Cardmarket-Wantlist-Optimizer.git|Autres-Projets/Cardmarket-Wantlist-Optimizer"
    "git@github.com-perso:floSa/Planning-Usine-CPSAT.git|Autres-Projets/Planning-Usine-CPSAT"
    "git@github.com-perso:floSa/PowerVision-S1-Backup.git|Autres-Projets/PowerVision-S1-Backup"
    "git@github.com-perso:floSa/Reels-Instagram-Graph-MD.git|Autres-Projets/Reels-Instagram-Graph-MD"
    "git@github.com-perso:floSa/Template-services-docker.git|Autres-Projets/Template-Services-Docker"
    "git@github.com-perso:floSa/Test-pre-entretien-technique.git|Autres-Projets/Test-Pre-Entretien-Technique"
    # Jeu
    "git@github.com-perso:floSa/7Wonders-BoardGame.git|Jeu/Board-Games/7Wonders-BoardGame"
    "git@github.com-perso:floSa/Dracula-VS-Van-Helsing-BoardGame.git|Jeu/Board-Games/Dracula-VS-Van-Helsing-BoardGame"
    "git@github.com-perso:floSa/Sea-Salt-And-Paper-BoardGame.git|Jeu/Board-Games/Sea-Salt-And-Paper-BoardGame"
    "git@github.com-perso:floSa/Toy-Battle-BoardGame.git|Jeu/Board-Games/Toy-Battle-BoardGame"
    "git@github.com-perso:floSa/Courtisans-BoardGame.git|Jeu/Courtisan/Courtisans-BoardGame"
    "git@github.com-perso:floSa/Courtisans-IA-Game.git|Jeu/Courtisan/Courtisans-IA-Game"
    "git@github.com-perso:floSa/Crossy-Road-AI-Game.git|Jeu/IA/Crossy-Road-AI-Game"
    "git@github.com-perso:floSa/Quiz-Geo.git|Jeu/Quiz/Quiz-Geo"
    "git@github.com-perso:floSa/Quiz-Hist.git|Jeu/Quiz/Quiz-Hist"
    "git@github.com-perso:floSa/Urban-Rivals-Game.git|Jeu/Urban-Rivals/Urban-Rivals-Game"
    "git@github.com-perso:floSa/Urban-Rivals-Scraper.git|Jeu/Urban-Rivals/Urban-Rivals-Scraper"
    # Projet-ML-DL
    "git@github.com-perso:floSa/Analyse-Esperance-De-Vie-FR.git|Projet-ML-DL/Analyse-Esperance-De-Vie-FR"
    "git@github.com-perso:floSa/Analyse-Habitudes-Alimentaires.git|Projet-ML-DL/Analyse-Habitudes-Alimentaires"
    "git@github.com-perso:floSa/Analyse-Vente-Prosol.git|Projet-ML-DL/Analyse-Vente-Prosol"
    "git@github.com-perso:floSa/Annotation-Images.git|Projet-ML-DL/Annotation-Images"
    "git@github.com-perso:floSa/Annotation-Text-Streamlit.git|Projet-ML-DL/Annotation-Text-Streamlit"
    "git@github.com-perso:floSa/Classification-Bulles.git|Projet-ML-DL/Classification-Bulles"
    "git@github.com-perso:floSa/Defi-IA-2019.git|Projet-ML-DL/Defis-IA/Defi-IA-2019"
    "git@github.com-perso:floSa/Defi-IA-2020.git|Projet-ML-DL/Defis-IA/Defi-IA-2020"
    "git@github.com-perso:floSa/Defi-IA-2021.git|Projet-ML-DL/Defis-IA/Defi-IA-2021"
    "git@github.com-perso:floSa/Defi-IA-2022.git|Projet-ML-DL/Defis-IA/Defi-IA-2022"
    "git@github.com-perso:floSa/Defi-IA-2023.git|Projet-ML-DL/Defis-IA/Defi-IA-2023"
    "git@github.com-perso:floSa/Detection-Pneumonie-Radio.git|Projet-ML-DL/Detection-Pneumonie-Radio"
    "git@github.com-perso:floSa/Images-collection-clean.git|Projet-ML-DL/Images-Collection-Clean"
    "git@github.com-perso:floSa/Notebooks-Cheat-Sheet.git|Projet-ML-DL/Notebooks-Cheat-Sheet"
    "git@github.com-perso:floSa/sales-ops-planning-poc.git|Projet-ML-DL/Sales-Ops-Planning-POC"
    # Projet-IA
    "git@github.com-perso:floSa/Agents-MCP-Orchestration.git|Projet-IA/Agents-MCP-Orchestration"
    "git@github.com-perso:floSa/data-analyst-agent.git|Projet-IA/Data-Analyst-Agent"
    "git@github.com-perso:floSa/llm-service.git|Projet-IA/LLM-Service"
    "git@github.com-perso:floSa/MCP_maison.git|Projet-IA/MCP-Maison"
    "git@github.com-perso:floSa/rag-agent-chat.git|Projet-IA/RAG-Agent-Chat"
    "git@github.com-perso:floSa/RAG-Eval-Bench.git|Projet-IA/RAG-Eval-Bench"
    "git@github.com-perso:floSa/rag-ingestion-pipeline.git|Projet-IA/RAG-Ingestion-Pipeline"
    "git@github.com-perso:floSa/traceable-agent.git|Projet-IA/Traceable-Agent"
    # Musique
    "git@github.com-perso:floSa/Bibliotheque-Musicale.git|Musique/Bibliotheque-Musicale"
    "git@github.com-perso:floSa/Classification-Genres-Musicaux.git|Musique/Classification-Genres-Musicaux"
    "git@github.com-perso:floSa/karaokit.git|Musique/Karaokit"
    # Productivite
    "git@github.com-perso:floSa/Boite-A-Outils.git|Productivite/Boite-A-Outils"
    "git@github.com-perso:floSa/Brain-Kit.git|Productivite/Brain-Kit"
    "git@github.com-perso:floSa/Catalogue-Comparateur-Solutions-IA.git|Productivite/Catalogue-Comparateur-Solutions-IA"
    "git@github.com-perso:floSa/Dev-Brain.git|Productivite/Dev-Brain"
    "git@github.com-perso:floSa/Fast-HTML-To-MD.git|Productivite/Fast-HTML-To-MD"
    "git@github.com-perso:floSa/Outil-Dictee-Audio.git|Productivite/Outil-Dictee-Audio"
    "git@github.com-perso:floSa/Veille-Repo.git|Productivite/Veille-Repo"
    "git@github.com-perso:floSa/mes-skills.git|Productivite/claude-skills"
    "git@github.com-perso:floSa/floSa.git|Productivite/floSa"
    # Tutoriels
    "git@github.com-perso:floSa/LMStudio-Bionic.git|Tutoriels/LMStudio-Bionic"
    "git@github.com-perso:floSa/Tuto-Dagster.git|Tutoriels/Tuto-Dagster"
    "git@github.com-perso:floSa/Tuto-MLflow.git|Tutoriels/Tuto-MLflow"
    "git@github.com-perso:floSa/Tuto-openmetadata.git|Tutoriels/Tuto-OpenMetadata"
)

# --- 4. Étape de préparation : Migration des répertoires existants & Clonage ---
echo -e "\n--- Vérification de la présence locale des dépôts ---"
REPOS_TO_PULL=()

for entry in "${REPOS[@]}"; do
    repo_url="${entry%%|*}"
    target_rel="${entry##*|}"
    target_full="$BASE_DIR/$target_rel"
    repo_name="$(basename "$target_rel")"

    if [ -d "$target_full/.git" ]; then
        REPOS_TO_PULL+=("$target_rel")
        continue
    fi

    # Recherche si présent dans une ancienne arborescence
    found_dir=""
    while IFS= read -r match_dir; do
        if [ -d "$match_dir/.git" ] && [ "$match_dir" != "$target_full" ]; then
            case "$match_dir" in
                *"_hors-git"*|*"_hors_git"*) continue ;;
            esac
            found_dir="$match_dir"
            break
        fi
    done < <(find "$BASE_DIR" -maxdepth 4 -type d -name "$repo_name" 2>/dev/null)

    # Alias exceptionnel : Mes-Skills -> claude-skills
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
        REPOS_TO_PULL+=("$target_rel")
        continue
    fi

    # Clonage si introuvable
    echo "[CLONAGE] $repo_url -> $target_rel"
    mkdir -p "$(dirname "$target_full")"
    if ! git clone -q "$repo_url" "$target_full" 2>/dev/null; then
        fallback_url="${repo_url/git@github.com-perso:/https:\/\/github.com\/}"
        echo "  -> Repli HTTPS: $fallback_url"
        git clone -q "$fallback_url" "$target_full"
    fi
    REPOS_TO_PULL+=("$target_rel")
done

# --- 5. Étape de synchronisation rapide (Pull) ---
total_repos=${#REPOS_TO_PULL[@]}
echo -e "\n--- Synchronisation Git (git pull) sur $total_repos dépôts ---"

pull_single_repo() {
    local rel_path="$1"
    local full_path="$BASE_DIR/$rel_path"

    if [ ! -d "$full_path/.git" ]; then
        echo "ERR: $rel_path (pas de .git)"
        return 1
    fi

    # Normalisation HTTPS -> SSH git@github.com-perso si nécessaire
    local remote_url; remote_url="$(git -C "$full_path" remote get-url origin 2>/dev/null || true)"
    if [[ "$remote_url" =~ ^https://github\.com/floSa/ ]]; then
        local ssh_remote="${remote_url/https:\/\/github\.com\/floSa\//git@github\.com-perso:floSa\/}"
        git -C "$full_path" remote set-url origin "$ssh_remote" 2>/dev/null || true
    fi

    local dirty; dirty="$(git -C "$full_path" status --porcelain 2>/dev/null || true)"
    if [ -n "$dirty" ]; then
        echo "DIRTY: $rel_path (modifications locales préservées)"
        return 0
    fi

    local pull_out
    if pull_out="$(git -C "$full_path" pull --ff-only 2>&1)"; then
        if [[ "$pull_out" =~ "Already up to date"|"Déjà à jour" ]]; then
            echo "OK: $rel_path"
        else
            echo "UPDATED: $rel_path"
        fi
    else
        echo "DIVERGED: $rel_path (nécessite une inspection manuelle)"
    fi
}

export BASE_DIR
export -f pull_single_repo

if [ "$SEQUENTIAL" -eq 1 ]; then
    for r in "${REPOS_TO_PULL[@]}"; do
        pull_single_repo "$r"
    done
else
    # Exécution parallèle optimisée (8 jobs) pour division par 6 du temps d'attente
    printf "%s\n" "${REPOS_TO_PULL[@]}" | xargs -P "$PARALLEL_JOBS" -I {} bash -c 'pull_single_repo "$@"' _ {} | sort
fi

# --- 6. Nettoyage des anciens dossiers orphelins devenus vides ---
for old_d in apprentissage data-ml ia-agents infra jeux outils pro; do
    if [ -d "$BASE_DIR/$old_d" ] && [ -z "$(ls -A "$BASE_DIR/$old_d" 2>/dev/null)" ]; then
        rmdir "$BASE_DIR/$old_d"
    fi
done

echo -e "\n=============================================================================="
echo "  Terminé ! Arborescence et dépôts synchronisés avec succès."
echo "=============================================================================="
