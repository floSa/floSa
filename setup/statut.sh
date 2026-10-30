#!/usr/bin/env bash
# Contrôle en lecture seule : tous les projets du référentiel sont-ils identiques à GitHub ?
# Rapide : liste lue dans projets.json (pas de parcours du disque), fetch en parallèle.
# Usage : bash statut.sh [RACINE]
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${1:-$(cd "$SCRIPT_DIR/../../.." && pwd)}"
PY="$(command -v python3 || command -v python)"
export ROOT
export GIT_SSH_COMMAND="ssh -o ControlMaster=auto -o ControlPath=/tmp/stat-ssh-%C -o ControlPersist=60"

if [ -n "$PY" ]; then
    LIST="$("$PY" "$SCRIPT_DIR/update_arborescence.py" --list-repos 2>/dev/null | tr -d '\r' | cut -d'|' -f2)"
else
    LIST="$(find "$ROOT" -maxdepth 5 -name .git -not -path '*/_hors_git/*' -prune 2>/dev/null | sed "s|^$ROOT/||; s|/\.git$||")"
fi

check_one() {
    local r="$1" d="$ROOT/$1" b
    [ -d "$d/.git" ] || return 0
    git -C "$d" fetch -q origin 2>/dev/null || { sleep 2; git -C "$d" fetch -q origin 2>/dev/null; } || { echo "INJOIGNABLE  $r"; return 0; }
    b="$(git -C "$d" branch --show-current)"
    local ahead behind dirty=0 real=0
    ahead="$(git -C "$d" rev-list --count "origin/$b..$b" 2>/dev/null || echo 0)"
    behind="$(git -C "$d" rev-list --count "$b..origin/$b" 2>/dev/null || echo 0)"
    if [ -n "$(git -C "$d" status --porcelain -uno 2>/dev/null)" ]; then
        dirty=1
        git -C "$d" diff -w --ignore-cr-at-eol --quiet 2>/dev/null || real=1
    fi
    if { [ "$ahead" -gt 0 ] || [ "$real" -eq 1 ]; } && [ "$behind" -gt 0 ]; then echo "DIVERGENCE  $r ($b)"
    elif [ "$ahead" -gt 0 ]; then echo "NON POUSSE  $r ($b, $ahead commits)"
    elif [ "$real" -eq 1 ]; then echo "MODIFS NON COMMITEES  $r"
    elif [ "$behind" -gt 0 ]; then echo "EN RETARD SUR GITHUB  $r ($b, $behind commits)"
    elif [ "$dirty" -eq 1 ]; then echo "FAUX CHANGEMENT (fins de ligne)  $r"
    fi
}
export -f check_one

n="$(echo "$LIST" | grep -c .)"
OUT="$(echo "$LIST" | xargs -P 8 -I {} bash -c 'check_one "$@"' _ {} | sort)"
[ -n "$OUT" ] && echo "$OUT"
if [ -z "$OUT" ]; then echo "A JOUR : $n dépôts identiques à GitHub."; else echo "PAS A JOUR : voir ci-dessus."; fi
