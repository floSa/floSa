# Mise à jour sur la machine Windows (complète CONSIGNE.md)

Dire à Claude Code : « Mets-moi à jour mes projets en suivant CONSIGNE.md et CONSIGNE-WINDOWS.md du repo floSa. »

Racine : `C:\Users\FLORIAN\Documents\_Documents\Codes_Projes_Dev` (floSa est dans `Productivite\floSa`).
Shell : Git Bash (le `.ps1` n'est plus maintenu).

## Commandes

```bash
cd /c/Users/FLORIAN/Documents/_Documents/Codes_Projes_Dev/Productivite/floSa
git pull --ff-only
bash setup/statut.sh /c/Users/FLORIAN/Documents/_Documents/Codes_Projes_Dev
bash setup/setup_arborescence.sh /c/Users/FLORIAN/Documents/_Documents/Codes_Projes_Dev --push
bash setup/statut.sh /c/Users/FLORIAN/Documents/_Documents/Codes_Projes_Dev
```

## Règle spécifique à cette machine : Test_music est figé

`_hors_git\Test_music` (remote `floSa/Music-Pacer`) est en cours de travail ici. Il ne doit ni être
déplacé, ni renommé, ni mis à jour (`pull`, `checkout`, restauration), ni commité/poussé automatiquement,
même si `Music-Pacer` apparaît un jour dans `projets.json` (migration du projet ailleurs) :
- ne pas appliquer la règle « doublon d'un projet du référentiel » ;
- ne pas le ranger, le fusionner, ni lancer la règle « faux changement » dessus ;
- s'il y a une divergence ou une migration à traiter, la signaler dans le rapport et attendre ma décision.

## Un seul dossier hors Git : `_hors_git`

`_hors-git` (avec tiret) ne doit pas exister sous Windows : le script ne crée plus d'alias (un lien
impossible devenait une copie de 37 Go). Si `_hors-git` réapparaît, comparer avec `_hors_git`, puis le
supprimer s'il ne contient rien d'unique : c'est un doublon, pas besoin de me demander.
Le dossier `sauvegarde-ancien-hors-git_*` dans `_hors_git` est l'ancienne version, à supprimer quand je le dis.

## Plugins

La commande `claude` n'est pas dans le PATH de Git Bash : le script signale « plugins non vérifiés ».
Vérifier `claude plugin list` depuis PowerShell/Claude Code, ou le noter dans le rapport.
