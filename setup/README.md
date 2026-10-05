# Initialisation automatique de l'espace de travail

Ce dossier contient les fichiers de référence et les scripts permettant de recréer l'arborescence complète des projets sur n'importe quelle machine (Linux, WSL ou Windows).

---

## Contenu

- **`ARBORESCENCE.txt`** : Référentiel textuel de l'organisation des dossiers et de la liste complète des dépôts GitHub associés (56 projets répertoriés).
- **`setup_arborescence.sh`** : Script Bash pour Linux, WSL ou macOS. Gère la détection intelligente, la migration de dossiers existants sans réinstallation, la réparation automatique des `.venv`, la synchronisation `git pull` et le clonage si manquant.
- **`setup_arborescence.ps1`** : Script PowerShell pour Windows avec détection automatique, migration et synchronisation.

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
