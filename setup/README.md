# Initialisation automatique de l'espace de travail

Ce dossier contient les fichiers de référence et les scripts permettant de recréer et synchroniser l'arborescence complète des projets sur n'importe quelle machine (Linux, WSL ou Windows).

---

> Pour tout faire d'un coup sur une machine, dire à Claude Code ou tout agent IA : « Prends le repo floSa, suis CONSIGNE.md pour mettre à jour mes projets et mes skills. » La consigne est à la racine du dépôt : [`CONSIGNE.md`](../CONSIGNE.md).

## Contenu

- **`projets.json`** : **Source Unique de Vérité (SSOT)**. Définit les catégories et la liste complète des dépôts GitHub associés (59 projets répertoriés). C'est le **seul fichier à modifier** pour ajouter ou déplacer un projet.
- **`update_arborescence.py`** : Script Python qui lit `projets.json` et régénère automatiquement `ARBORESCENCE.txt` avec un arbre ASCII propre, les connecteurs (`├──`, `└──`) et les liens SSH alignés.
- **`ARBORESCENCE.txt`** : Référentiel textuel généré automatiquement. Jamais modifié à la main.
- **`setup_arborescence.sh`** : Script Bash pour Linux, WSL ou macOS. Lit dynamiquement `projets.json`, régénère `ARBORESCENCE.txt`, gère la détection, la migration, la réparation des `.venv`, le `git pull` parallèle et le clonage si manquant.
- **`setup_arborescence.ps1`** : Script PowerShell pour Windows avec détection native de `projets.json`, régénération automatique de l'arborescence, migration et synchronisation.

---

## ➕ Ajouter un nouveau projet

Pour ajouter un nouveau projet au référentiel :
1. Ouvrir **`setup/projets.json`** et ajouter le nom du projet sous la catégorie voulue (ex: `"Mon-Nouveau-Projet"` sous `"Productivite"`).
2. Lancer `update_arborescence.py` ou exécuter `setup_arborescence.sh` / `setup_arborescence.ps1` : `ARBORESCENCE.txt` se met à jour automatiquement.
3. Commiter et pousser `floSa`. Sur n'importe quelle autre machine, un simple `git pull` suivi du script clonera et organisera le projet sans aucune intervention manuelle.

---

## 🔒 Règle stricte sur le dossier `_hors_git`

Le dossier `_hors_git` est **strictement sanctuarisé** :
- **Spécifique à la machine hôte** : il contient les données locales, documents personnels, sauvegardes, caches de modèles et expérimentations hors versioning Git propres au poste utilisé.
- **Intouchable** : les scripts d'arborescence ne modifient, ne déplacent et ne suppriment **jamais** son contenu.
- **Convention unique** : le nom `_hors_git` (avec underscore) est la norme sur tous les systèmes. Si un ancien dossier `_hors-git` existe, il est automatiquement préservé et lié.

---

## Utilisation

### Sur Linux / WSL / macOS :
```bash
# Pour cloner l'ensemble des projets dans un dossier cible (ex: ~/mes_projets) :
bash setup/setup_arborescence.sh ~/mes_projets

# Ou pour installer dans le dossier parent (niveau Projets) :
bash setup/setup_arborescence.sh
```

### Sur Windows (PowerShell) :
```powershell
# Pour cloner l'ensemble des projets dans un dossier cible :
powershell -ExecutionPolicy Bypass -File setup\setup_arborescence.ps1 -TargetDir "C:\Users\flori\Documents\Projets"

# Ou depuis le dossier parent :
.\setup\setup_arborescence.ps1
```
