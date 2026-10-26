#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
update_arborescence.py
Générateur automatique de ARBORESCENCE.txt à partir de projets.json (Source Unique de Vérité).

Usage:
  python update_arborescence.py                # Régénère ARBORESCENCE.txt dans setup/ et à la racine si trouvée
  python update_arborescence.py --check        # Valide la cohérence de projets.json
  python update_arborescence.py --list-repos   # Affiche URL|PATH pour les scripts bash/powershell
  python update_arborescence.py --list-dirs    # Affiche les dossiers de catégories à créer
"""

import os
import sys
import json
import argparse
from pathlib import Path

# Encodage UTF-8 forcé sur stdout/stderr (utile sous Windows)
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

HEADER = """# ==============================================================================
# ARBORESCENCE DE PROJETS - RÉFÉRENTIEL (FLORIAN HORELLOU)
#
# RÈGLE STRICTE SUR _hors_git :
# Le dossier '_hors_git' est STRICTEMENT propre à chaque machine hôte.
# Il accueille les données locales, sauvegardes, caches de modèles et projets
# confidentiels ou non versionnés.
# Son contenu existant ne doit JAMAIS être modifié, déplacé ni supprimé par les
# scripts de synchronisation ou d'arborescence. Ils peuvent seulement y AJOUTER :
# tout dossier de l'arborescence absent de la liste ci-dessous ET pas réellement dans
# Git y est déplacé, jamais supprimé. « Réellement dans Git » = un remote origin dont
# le dépôt existe, dont la branche courante existe côté remote, sans commit en
# retard : un simple `git init` ne compte pas. Un dépôt hors liste réellement poussé,
# ou dont le remote est injoignable, n'est pas déplacé : il est signalé, pour être
# ajouté à la liste ou rangé à la main.
#
# NOMS : chaque dossier porte exactement le nom de son dépôt GitHub (floSa/<nom>).
# Un dossier existant sous un ancien nom (casse, tiret ou underscore) est migré par les
# scripts ; un doublon d'un dépôt du référentiel est signalé, jamais supprimé d'office.
#
# SKILLS : les scripts installent aussi les skills (~/.claude/skills) depuis
# Productivite/Mes-Skills et Productivite/Dev-Brain, ainsi que les plugins
# i-have-adhd et ponytail. BMAD, lui, s'installe projet par projet.
# ==============================================================================

Projets/
├── _hors_git/                                (SANCTUARISÉ - PROPRE À CHAQUE MACHINE)
│   ├── (données locales / sauvegardes spécifiques à l'hôte)
│"""

class TreeNode:
    def __init__(self, name, is_dir=True, url=None):
        self.name = name
        self.is_dir = is_dir
        self.url = url
        self.children = {}

def find_projets_json(explicit_path=None):
    if explicit_path and os.path.exists(explicit_path):
        return Path(explicit_path).resolve()
    
    script_dir = Path(__file__).resolve().parent
    candidates = [
        script_dir / "projets.json",
        script_dir / "setup" / "projets.json",
        script_dir.parent / "setup" / "projets.json",
        script_dir.parent.parent.parent / "Productivite" / "floSa" / "setup" / "projets.json",
        script_dir.parent.parent.parent / "projets.json",
    ]
    for c in candidates:
        if c.exists():
            return c.resolve()
    raise FileNotFoundError("Impossible de localiser 'projets.json'.")

def load_projets(json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        return json.load(f)

def build_tree(data):
    root = TreeNode("Projets", is_dir=True)
    for cat_path, repos in data.items():
        parts = [p.strip() for p in cat_path.replace("\\", "/").split("/") if p.strip()]
        curr = root
        for p in parts:
            if p not in curr.children:
                curr.children[p] = TreeNode(p, is_dir=True)
            curr = curr.children[p]
        for r in repos:
            if isinstance(r, dict):
                name = r["name"].strip()
                url = r.get("url", f"git@github.com-perso:floSa/{name}.git").strip()
            else:
                name = str(r).strip()
                url = f"git@github.com-perso:floSa/{name}.git"
            curr.children[name] = TreeNode(name, is_dir=False, url=url)
    return root

def render_tree_lines(root):
    lines = [
        "Projets/",
        "├── _hors_git/                                (SANCTUARISÉ - PROPRE À CHAQUE MACHINE)",
        "│   ├── (données locales / sauvegardes spécifiques à l'hôte)",
        "│"
    ]

    def walk(node, prefix):
        sorted_children = sorted(node.children.values(), key=lambda c: c.name)
        total = len(sorted_children)
        for i, child in enumerate(sorted_children):
            is_last = (i == total - 1)
            connector = "└── " if is_last else "├── "
            child_prefix = prefix + ("    " if is_last else "│   ")
            if child.is_dir:
                lines.append(f"{prefix}{connector}{child.name}/")
                walk(child, child_prefix)
            else:
                left = f"{prefix}{connector}{child.name}"
                pad = max(46 - len(left), 2)
                lines.append(f"{left}{' ' * pad}<- {child.url}")

    top_items = list(root.children.items())
    total_top = len(top_items)
    for i, (name, node) in enumerate(top_items):
        is_last = (i == total_top - 1)
        connector = "└── " if is_last else "├── "
        child_prefix = "    " if is_last else "│   "
        lines.append(f"{connector}{node.name}/")
        walk(node, child_prefix)
        if not is_last:
            lines.append("│")

    return lines

def generate_arborescence_content(data):
    root = build_tree(data)
    tree_lines = render_tree_lines(root)
    # Remplacer les 4 premières lignes car HEADER contient déjà Projets/ et _hors_git/
    return HEADER + "\n" + "\n".join(tree_lines[4:]) + "\n"

def get_repos_list(data):
    results = []
    for cat_path, repos in data.items():
        clean_cat = cat_path.replace("\\", "/").strip("/")
        for r in repos:
            if isinstance(r, dict):
                name = r["name"].strip()
                url = r.get("url", f"git@github.com-perso:floSa/{name}.git").strip()
            else:
                name = str(r).strip()
                url = f"git@github.com-perso:floSa/{name}.git"
            results.append((url, f"{clean_cat}/{name}"))
    return results

def get_dirs_list(data):
    dirs = set()
    for cat_path in data.keys():
        parts = [p.strip() for p in cat_path.replace("\\", "/").split("/") if p.strip()]
        for i in range(1, len(parts) + 1):
            dirs.add("/".join(parts[:i]))
    return sorted(list(dirs))

def check_projets(data):
    seen = {}
    duplicates = []
    for cat_path, repos in data.items():
        for r in repos:
            name = r["name"] if isinstance(r, dict) else str(r)
            if name in seen:
                duplicates.append((name, seen[name], cat_path))
            else:
                seen[name] = cat_path
    
    if duplicates:
        print("[ERREUR] Doublons détectés dans projets.json :", file=sys.stderr)
        for name, cat1, cat2 in duplicates:
            print(f"  - '{name}' présent dans '{cat1}' et dans '{cat2}'", file=sys.stderr)
        return False
    print(f"[OK] projets.json est valide : {len(seen)} dépôts uniques répartis sur {len(data)} catégories.")
    return True

def main():
    # Sortie LF/UTF-8 sur tous les OS (sinon Windows ajoute un CR aux noms lus par bash)
    sys.stdout.reconfigure(newline='\n', encoding='utf-8')
    parser = argparse.ArgumentParser(description="Générateur d'arborescence floSa")
    parser.add_argument("--json", help="Chemin vers projets.json", default=None)
    parser.add_argument("--check", action="store_true", help="Vérifier projets.json")
    parser.add_argument("--list-repos", action="store_true", help="Lister url|chemin_relatif")
    parser.add_argument("--list-dirs", action="store_true", help="Lister les catégories cibles")
    parser.add_argument("--target-dir", help="Dossier racine des projets pour mise à jour de ARBORESCENCE.txt", default=None)
    args = parser.parse_args()

    json_path = find_projets_json(args.json)
    data = load_projets(json_path)

    if args.check:
        ok = check_projets(data)
        sys.exit(0 if ok else 1)

    if args.list_repos:
        for url, rel_path in get_repos_list(data):
            print(f"{url}|{rel_path}")
        return

    if args.list_dirs:
        for d in get_dirs_list(data):
            print(d)
        return

    # Par défaut : régénération de ARBORESCENCE.txt
    if not check_projets(data):
        sys.exit(1)

    content = generate_arborescence_content(data)
    setup_dir = json_path.parent
    target_arbo = setup_dir / "ARBORESCENCE.txt"

    with open(target_arbo, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)
    print(f"[OK] {target_arbo} mis à jour avec succès.")

    # Si target-dir spécifié ou racine Projets détectée
    candidates_root = []
    if args.target_dir:
        candidates_root.append(Path(args.target_dir))
    else:
        # Essayer d'inférer la racine des projets (3 niveaux au dessus de setup/)
        # ex: C:\Users\flori\Documents\Projets\Productivite\floSa\setup -> C:\Users\flori\Documents\Projets
        inferred = setup_dir.parent.parent.parent
        if (inferred / "Productivite" / "floSa").exists():
            candidates_root.append(inferred)

    for root_dir in candidates_root:
        if root_dir.exists():
            root_arbo = root_dir / "ARBORESCENCE.txt"
            with open(root_arbo, "w", encoding="utf-8", newline="\n") as f:
                f.write(content)
            print(f"[OK] {root_arbo} synchronisé avec succès.")

if __name__ == "__main__":
    main()
