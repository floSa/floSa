# Consigne : mettre une machine à jour

À dire à Claude Code sur n'importe quelle machine (WSL, Linux, macOS, SSH distant, Windows) :

> Mets-moi à jour mes projets et mes skills en suivant CONSIGNE.md du repo floSa.

## Déroulé en 3 temps (toujours le même, sur toute machine)

1. **Vérifier d'abord, avant toute modification.** Lancer `setup/statut.sh` sur la racine de mes
   projets (bash : WSL, Linux, macOS, SSH, ou Git Bash sous Windows). Si des commits ne sont pas
   poussés, ou si des fichiers sont modifiés sans commit, le dire tout de suite, en tête, et
   s'arrêter : j'attends mes réponses (format « Présenter un problème »). Rien d'autre ne se fait
   avant.
2. **Mettre à jour.** Récupérer floSa, puis lancer le script `setup/` de la machine : tout ce qui est
   sans ambiguïté se fait sans question (pull, clones, renommages, rangement dans `_hors_git`).
3. **Conclure.** Refaire le contrôle, puis présenter le rapport final (format plus bas), sans
   répétition. Le rapport ne dit « à jour » que si le contrôle ne signale plus aucun problème.

Si `floSa` n'est pas sur la machine : `git clone git@github.com-perso:floSa/floSa.git`
(repli `https://github.com/floSa/floSa.git`) dans `Productivite/floSa`, puis lire ce fichier.

## Règles

- GitHub fait foi. La Source Unique de Vérité est `setup/projets.json` : un dossier = un dépôt
  GitHub perso (`floSa`), et le dossier porte exactement le nom du dépôt. L'arborescence
  `setup/ARBORESCENCE.txt` est régénérée automatiquement à partir de ce fichier JSON.
- Commits : aucune mention de Claude (ni `Co-Authored-By`, ni « Generated with »). Cela vaut
  pour les nouveaux commits. Les anciens commits ne sont ni signalés, ni modifiés.
- Après un commit, push immédiat. Jamais `--force`, jamais de réécriture d'historique,
  jamais `git reset --hard`, `git clean`, `git stash drop`.
- Rien n'est supprimé sans mon accord explicite. Le contenu de `_hors_git` ne change que sur
  ma demande.
- Jamais de `git add -A` à l'aveugle.
- Réponses en français, courtes, sans émoji, sans phrases de remplissage.

## Étapes, dans cet ordre

1. **Racine.** Dossier courant dans `Productivite/floSa` : la racine est deux niveaux au-dessus.
   Sinon : WSL/Linux/macOS souvent `~/mes_projets` ou `~/Projets`, Windows `Documents\Projets`.
   Absente ou ambiguë : demander le chemin, une seule fois.
2. **floSa.** `git pull --ff-only`, puis relire cette consigne si elle a changé.
3. **Ranger.** Tout dossier absent du référentiel (4 niveaux de profondeur, dépôts imbriqués
   compris) va dans `_hors_git`. Avant de déplacer, vérifier :
   - doublon : même remote qu'un projet du référentiel, ou ancien nom. Dans ce cas ne rien
     déplacer, le présenter dans le tableau ;
   - travail non poussé (commits sur n'importe quelle branche, stash, modifications). Dans ce
     cas ne rien déplacer, le présenter dans le tableau ;
   - sinon (sans `.git`, ou entièrement poussé) : déplacer. Collision de nom : suffixer la date.
   Un dossier retiré du référentiel pendant la mise à jour est traité de la même façon.
4. **Mettre à jour.** `setup/setup_arborescence.sh <racine> --push` (WSL, Linux, macOS, SSH) ou
   `setup\setup_arborescence.ps1 -TargetDir <racine> -Push` (Windows). Ce qui est sans ambiguïté
   se fait sans question : pull `--ff-only`, clones manquants, renommages vers le nom GitHub.
   Si le référentiel change pendant l'exécution, le relire et relancer.
5. **Contrôler.** `setup/statut.sh` (lecture seule), à lancer aussi sous Windows avec Git Bash.
   Le verdict vient des contrôles, jamais de mon impression : tant qu'un problème subsiste,
   ne jamais écrire « tout est à jour ».
6. **Skills et plugins.** Vérifier que chaque skill de `mes-skills` et de `Dev-Brain` a un
   `SKILL.md`, que `i-have-adhd` et `ponytail` sont activés (`claude plugin list`) et que
   `install-outils --status` ne signale aucun écart. Node.js du système absent (pas celui de
   `/mnt/c`) : le dire, ne l'installer qu'avec mon accord. BMAD : seulement dans les projets
   que je nomme.
7. **ARBORESCENCE.txt à la racine.** En dernière étape, copier `setup/ARBORESCENCE.txt` à la
   racine de mes projets, une seule fois, sous le nom `ARBORESCENCE.txt` (le dossier qui contient
   `Autres-Projets`, `Jeu`, `Productivite`, `_hors_git`, etc., pas dans chaque projet). Écraser la
   copie précédente : elle est toujours identique à celle de floSa, et c'est floSa qu'on modifie,
   jamais la copie. Cela me permet de l'ouvrir et de voir où se trouve chaque projet.

## Quoi contrôler dans chaque dépôt

Après `git fetch`, pour la branche courante ET toutes les autres branches locales :

- commits locaux absents de GitHub : `git rev-list --branches --not --remotes`
- commits de GitHub absents ici : `git rev-list <branche>..origin/<branche>`
- fichiers modifiés non commités : `git status --porcelain`
- stashs : `git stash list`
- remote cassé ou branche absente de GitHub : `git ls-remote --heads origin`
- fichiers appartenant à root (Docker) : `find <dossier> ! -user $USER`

Une seule connexion SSH partagée pour tous les dépôts (`ControlMaster`), deux essais, puis
« injoignable » dans le tableau.

## Règle de tri

- **Aucun fichier ne diffère** entre ma machine et GitHub (même contenu, historique réécrit ou
  branche de sauvegarde) : ne rien pousser.
- **Des fichiers diffèrent, ma machine est plus récente** : conseiller de pousser (commit des
  fichiers choisis un par un, puis push).
- **Des fichiers diffèrent, GitHub est plus récent, et seules les fins de ligne changent** : GitHub
  gagne. Sauvegarder d'abord une copie des fichiers dans `_hors_git/sauvegarde-modifs_<date>`.
- **Des fichiers diffèrent, GitHub est plus récent, et le contenu change des deux côtés** : ne pas
  conseiller, montrer les fichiers, me laisser trancher.

## Présenter un problème (format obligatoire)

Pas de tableau (illisible dans Claude Desktop). Un bloc par problème, court, sans ligne vide
inutile, sans mise en forme lourde :

```
Projet : RAG-Eval-Bench (branche tuto)
Problème : les deux côtés ont avancé
Machine : 28/09 au 29/09, 4 commits (tutoriel web pour élèves, chapitres 10 et 11)
GitHub : 29/09 au 15/10, 10 commits (reranker Qwen3, support GPU, modèles granite4.2 et gemma4)
Fichiers :
- retrieve.py, uv.lock (src/ragbench/rag), scripts/calibration_juge_externe.py
Conseil : pousser tuto. Oui : tutoriel sauvegardé, main ne bouge pas. Non : il reste sur cette machine.
```

- **Projet / Problème** : le nom du dossier (et la branche), puis le type en quelques mots.
- **Machine / GitHub** : date de début et de fin, nombre de commits (ou fichiers modifiés avec
  leur date), puis leur contenu entre parenthèses. Une seule ligne chacun.
- **Fichiers** : en puces, regroupés : `nom, nom, nom (chemin/relatif)`. Pas de CRC ni de
  détail technique. Au-delà de 10 : le nombre et les dossiers. Préciser « fins de ligne
  seulement » le cas échéant. Signaler en premier un fichier sensible (`.env`, clés) ou très gros.
- **Conseil** : une ligne, selon la règle de tri.

Je réponds par le nom du projet : « RAG-Eval-Bench oui, Atlas non ».

## Cas particuliers

- Fichiers appartenant à root (créés par Docker) : donner la commande `sudo` exacte, ne pas
  contourner.
- Clone qui échoue sous Windows (nom interdit, chemin trop long) : réparer sur place
  (`core.longpaths`, sparse-checkout), ne rien supprimer.
- Remote cassé : le corriger vers le bon nom si `git ls-remote` le confirme, puis refaire le pull.

## Rapport final

Trois blocs, dans cet ordre, visibles d'un coup d'œil, sans rien répéter ni détailler :

1. **Problèmes** (s'il y en a) : les blocs ci-dessus, en tête. Sinon, ne pas écrire ce bloc.
2. **Déplacés** : une ligne par projet rangé dans `_hors_git`, `Nom → _hors_git` (le chemin
   d'origine seulement s'il n'est pas évident). Aucune explication.
3. **État** : une ligne. `Tout est à jour : N projets, skills et plugins.` Ne pas lister les
   noms des skills, des plugins ni des projets à jour.

Exemple de sortie :

```
Déplacés
Citadel-BoardGame → _hors_git
Taketime-BoardGame → _hors_git

Tout est à jour : 59 projets, skills et plugins.
```

Rappeler de redémarrer Claude Code (ou `/reload-plugins`) seulement si des skills ou plugins ont
changé.
