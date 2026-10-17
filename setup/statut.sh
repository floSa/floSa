#!/usr/bin/env bash
# Lecture seule : dit si tous les dépôts sont à jour avec GitHub (GitHub fait foi).
export GIT_SSH_COMMAND="ssh -o ControlMaster=auto -o ControlPath=/tmp/stat-ssh-%C -o ControlPersist=60"
ROOT="${1:-$(cd "$(dirname "$0")/../../.." && pwd)}"; bad=0; n=0
while read -r g; do r="${g%/.git}"; n=$((n+1))
  case "$r" in */references/*|*/_hors_git/*) continue;; esac
  { git -C "$r" fetch -q origin 2>/dev/null || { sleep 2; git -C "$r" fetch -q origin 2>/dev/null; }; } || { echo "INJOIGNABLE  $r"; bad=1; continue; }
  b=$(git -C "$r" branch --show-current)
  [ -n "$(git -C "$r" status --porcelain 2>/dev/null)" ] && { echo "MODIFS NON COMMITEES  $r"; bad=1; }
  [ -n "$(git -C "$r" rev-list "origin/$b..$b" 2>/dev/null)" ] && { echo "NON POUSSE  $r ($b)"; bad=1; }
  [ -n "$(git -C "$r" rev-list "$b..origin/$b" 2>/dev/null)" ] && { echo "EN RETARD SUR GITHUB  $r ($b)"; bad=1; }
done < <(find "$ROOT" -maxdepth 5 -name .git -not -path '*/_hors_git/*' -prune 2>/dev/null)
[ $bad = 0 ] && echo "A JOUR : $n dépôts identiques à GitHub." || echo "PAS A JOUR : voir ci-dessus."
