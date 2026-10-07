# Initialisation automatique de l'espace de travail

Ce dossier contient les fichiers de référence et les scripts permettant de recréer l'arborescence complète des projets sur n'importe quelle machine (Linux, WSL ou Windows).

---

## Contenu

- **`ARBORESCENCE.txt`** : Référentiel textuel de l'organisation des dossiers et de la liste complète des dépôts GitHub associés (57 projets répertoriés).
- **`setup_arborescence.sh`** : Script Bash pour Linux, WSL ou macOS. Gère la détection intelligente, la migration de dossiers existants sans réinstallation, la réparation automatique des `.venv`, la synchronisation `git pull` et le clonage si manquant.
- **`setup_arborescence.ps1`** : Script PowerShell pour Windows avec détection automatique, migration et synchronisation.

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
