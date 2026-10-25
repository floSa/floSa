# Consigne : mettre une machine à jour

À dire à Claude Code sur n'importe quelle machine (WSL, Linux, macOS, SSH distant, Windows) :

> Mets-moi à jour mes projets et mes skills en suivant CONSIGNE.md du repo floSa.

## Déroulé en 3 temps (toujours le même, sur toute machine)

1. **Récupérer et exécuter.** Récupérer le repo floSa, puis suivre dans l'ordre : l'arborescence
   (`setup/ARBORESCENCE.txt`), le script (`setup/`), puis cette consigne. Ce qui est sans
   ambiguïté se fait sans question.
2. **S'arrêter au premier blocage.** Dès qu'un point demande mon choix (travail non poussé, fichiers
   modifiés, doublon, dossier hors référentiel, fichiers de root, injoignable), arrêter, ne rien
   décider à ma place, et me présenter le tableau des problèmes (format plus bas). J'attends mes
   réponses.
3. **Conclure après mes choix.** Appliquer mes réponses, refaire le contrôle, puis écrire
   exactement : « Tous tes projets, tous tes skills et tous tes plugins sont à jour. » Cette phrase
   n'est écrite que si le contrôle ne signale plus aucun problème. Sinon, retour à l'étape 2.

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
5. **Contrôler.** `setup/statut.sh` (lecture seule). Sous Windows, faire les mêmes contrôles
   avec les commandes git de la section suivante. Le verdict vient des contrôles, jamais de
   mon impression : tant qu'un problème subsiste, ne jamais écrire « tout est OK ».
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

Un seul tableau, une ligne par problème. Chaque cellule est une liste à puces (`<br>•`). Pas de
phrase, pas de numéro. Colonnes, dans cet ordre :

| Projet | Problème | Ta machine | GitHub | Fichiers | Conseil |
|---|---|---|---|---|---|

- **Projet** : nom du dossier, puis la branche entre parenthèses.
- **Problème** : le type en quelques mots (les deux côtés ont avancé ; fichiers modifiés non
  commités ; branche locale absente de GitHub ; en retard sur GitHub ; doublon ; dossier hors
  référentiel ; fichiers de root ; injoignable).
- **Ta machine** : date de début et date de fin du problème, nombre de commits en plus (ou
  fichiers modifiés avec leur date et heure), puis ce que font ces commits, en puces.
- **GitHub** : mêmes informations, pour GitHub.
- **Fichiers** : les fichiers concernés, un par puce. Au-delà de 10 : le nombre et les dossiers,
  la liste complète dans un fichier à part. Préciser contenu ou fins de ligne seulement.
  Signaler en premier les fichiers sensibles (`.env`, clés) ou très gros.
- **Conseil** : ce que je conseille en gras, puis ce que provoque le oui et ce que provoque le
  non, selon la règle de tri.

Je réponds par le nom du projet : « RAG-Eval-Bench oui, Atlas non ».

Exemple de ligne :

| Projet | Problème | Ta machine | GitHub | Fichiers | Conseil |
|---|---|---|---|---|---|
| **RAG-Eval-Bench**<br>(branche `tuto`) | Les deux côtés ont avancé chacun de leur côté | • Du 28/09 au 29/09<br>• 4 commits en plus :<br>• tutoriel web pour élèves<br>• chapitres 10 et 11 (mesures GPU) | • Du 29/09 au 15/10<br>• 10 commits en plus :<br>• reranker Qwen3<br>• support GPU<br>• modèles granite4.2, gemma4 | • 15 fichiers touchés des deux côtés<br>• dont `retrieve.py`, `uv.lock` | • **Pousser `tuto`**<br>• Oui : tutoriel sauvegardé, `main` ne bouge pas<br>• Non : il n'existe que sur cette machine |

## Cas particuliers

- Fichiers appartenant à root (créés par Docker) : donner la commande `sudo` exacte, ne pas
  contourner.
- Clone qui échoue sous Windows (nom interdit, chemin trop long) : réparer sur place
  (`core.longpaths`, sparse-checkout), ne rien supprimer.
- Remote cassé : le corriger vers le bon nom si `git ls-remote` le confirme, puis refaire le pull.

## Rapport final

- Tout est aligné : la phrase « Tous tes projets, tous tes skills et tous tes plugins sont à
  jour. », suivie de `N dépôts alignés sur GitHub`, du nombre de skills et des plugins activés.
- Sinon : le tableau des problèmes, rien d'autre. Ce qui a été fait sans question tient en une
  ligne avant le tableau (par exemple « 4 dépôts mis à jour, 1 rangé dans `_hors_git` »).
- Rappeler de redémarrer Claude Code (ou `/reload-plugins`) pour voir les skills.
