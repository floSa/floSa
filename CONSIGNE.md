# Consigne : mettre une machine à jour

À dire à Claude Code (ou tout assistant de code) sur n'importe quelle machine (WSL, Linux, macOS,
SSH distant, Windows) :

> Mets-moi à jour mes projets et mes skills en suivant CONSIGNE.md du repo floSa.

Si `floSa` n'est pas sur la machine : `git clone git@github.com-perso:floSa/floSa.git`
(repli `https://github.com/floSa/floSa.git`) dans `Productivite/floSa`, puis lire ce fichier.

## Règles

- GitHub fait foi. La source de vérité est `setup/projets.json` : un dossier = un dépôt GitHub
  perso (`floSa`), et le dossier porte exactement le nom du dépôt. `setup/ARBORESCENCE.txt` en est
  régénéré automatiquement.
- Commits : aucune mention de Claude (ni `Co-Authored-By`, ni « Generated with »). Cela vaut pour
  les nouveaux commits ; les anciens ne sont ni signalés ni modifiés. Message court, sans émoji.
- Jamais `--force`, jamais de réécriture d'historique, jamais `git reset --hard`, `git clean`,
  `git stash drop`, jamais `git add -A` à l'aveugle.
- Rien n'est supprimé sans mon accord explicite. Le contenu de `_hors_git` ne change que sur ma
  demande.
- Réponses en français, courtes, sans émoji, sans phrases de remplissage, sans répétition.

## Déroulé, toujours le même

1. **Racine.** Dossier courant dans `Productivite/floSa` : la racine est deux niveaux au-dessus.
   Sinon : WSL/Linux/macOS souvent `~/mes_projets` ou `~/Projets`, Windows `Documents\Projets`.
   Absente ou ambiguë : demander le chemin, une seule fois.
2. **Contrôler d'abord, avant toute modification.** `git pull --ff-only` sur floSa, puis
   `setup/statut.sh <racine>` (bash : WSL, Linux, macOS, SSH, ou Git Bash sous Windows).
3. **Régler le travail non poussé**, sans me demander (voir plus bas), puis **présenter les
   divergences** et attendre mes réponses. Rien d'autre ne se fait tant qu'une divergence est en
   attente.
4. **Mettre à jour.** `bash setup/setup_arborescence.sh <racine> --push` (WSL, Linux, macOS, SSH,
   et Windows avec Git Bash : un seul script, le `.ps1` n'est plus maintenu). Il fait : pull
   `--ff-only` en parallèle, clones manquants, renommage automatique des dossiers dont le dépôt a
   été renommé sur GitHub (détecté par la redirection de GitHub), rangement dans `_hors_git`,
   skills et plugins, `ARBORESCENCE.txt` à la racine. Il affiche déjà le rapport final compact
   (`--verbose` pour le détail). Régler ce qu'il marque « À régler », puis le relancer.
5. **Contrôler de nouveau**, puis présenter le rapport final. Le verdict vient du contrôle, jamais
   de mon impression : tant qu'un problème subsiste, ne pas écrire « tout est à jour ».

## Commandes de contrôle (par dépôt, après `git fetch`, toutes les branches locales)

- Commits locaux absents de GitHub : `git rev-list --branches --not --remotes`
- Commits de GitHub absents ici : `git rev-list <branche>..origin/<branche>`
- Fichiers modifiés : `git status --porcelain`. Contenu réellement changé ou seulement les fins de
  ligne : `git diff -w --ignore-cr-at-eol --shortstat`
- Fichiers changés des deux côtés depuis le point commun : intersection de
  `git diff --name-only $(git merge-base HEAD origin/<branche>) HEAD` et de la même commande
  avec `origin/<branche>` : si elle n'est pas vide, c'est une divergence
- Stashs : `git stash list`. Branche absente de GitHub : `git ls-remote --heads origin`
- Fichiers de root : `find <dossier> ! -user $USER`

## Ce qui se règle sans me demander

- **Travail non poussé.** Des commits locaux, ou des fichiers dont le contenu a vraiment changé,
  que GitHub n'a pas, alors que GitHub n'a pas touché à ces fichiers : commiter (fichiers choisis
  un par un, sauf `.env`, clés, très gros fichiers, qui sont signalés) puis pousser, avant toute
  autre opération. Une ligne dans le rapport : `Projet : travail poussé (N fichiers)`.
- **En retard.** GitHub a du nouveau et rien de local : `pull --ff-only`.
- **Faux changement.** Fichiers marqués modifiés mais dont seules les fins de ligne changent :
  copie dans `_hors_git/sauvegarde-modifs_<date>`, puis restauration depuis GitHub. Non affiché.
- **Projet jamais poussé ou hors référentiel.** Tout dossier absent de `projets.json` (4 niveaux de
  profondeur, dépôts imbriqués compris), qu'il soit sans `.git`, sans remote, sans commit ou déjà
  sur GitHub, va dans `_hors_git`. Collision de nom : suffixer la date. Ce n'est pas un problème,
  c'est un déplacement : une ligne `Nom → _hors_git`.
- **Gros dossier local.** Un dossier listé dans le `.gitignore` du projet est ignoré partout : Git
  ne le pousse pas, ne le signale pas, et un `pull` ne le supprime pas. S'il est présent, il reste ;
  s'il manque, tant pis. Si un gros dossier n'est pas dans le `.gitignore`, ajouter la ligne au
  `.gitignore`, commiter et pousser. Jamais signalé.
- **Doublon d'un projet du référentiel** (même remote, ancien nom). Garder la version la plus
  récente dans le dossier du référentiel (recopier ce qui est plus récent : données locales,
  journaux, `.env`), puis ranger l'autre copie dans `_hors_git`.

## Ce qui s'affiche : trois problèmes seulement

### 1. Divergence
Même projet modifié sur deux machines : le travail local n'est pas poussé ET GitHub a reçu depuis
des changements sur les mêmes fichiers. C'est le cas le plus grave.

**Faire une enquête avant de poser la question :**
1. Trouver le dernier point où les deux versions étaient identiques.
2. Lire ce qui s'est passé depuis, des deux côtés (messages de commits et changements de code).
3. L'expliquer en fonctionnalités, pas en fichiers : « ici on a fait X », « là-bas on a fait Y ».
4. Dire si les deux travaux se marchent dessus (même zone de code) ou sont indépendants.

**Trois choix, toujours les mêmes :**
- **Garder la machine** : GitHub reçoit cette version ; l'autre est conservée dans une sauvegarde.
- **Garder GitHub** : la machine est remplacée ; son travail est sauvegardé d'abord.
- **Mélanger** : indépendants, fusion des deux. Qui se chevauchent : expliquer chaque point de
  désaccord en clair et proposer de garder la version qui a le plus de choses, puis d'ajouter les
  fonctionnalités qui manquent.

Avant toute fusion : sauvegarde de l'état local (`git bundle --all`) dans
`_hors_git/sauvegarde-divergence_<date>`. Fusion par un commit de fusion, sans réécrire l'historique,
puis push.

### 2. Autre
Cas rares, une phrase d'explication : fichiers appartenant à root (créés par Docker : donner la
commande `sudo` exacte, ne pas contourner), GitHub injoignable (une connexion SSH partagée, deux
essais), remote cassé (le corriger vers le bon nom si `git ls-remote` le confirme), clone qui échoue
sous Windows (`core.longpaths`, sparse-checkout, ne rien supprimer).

### 3. Skills et plugins
Chaque skill de `Mes-Skills` et de `Dev-Brain` doit avoir un `SKILL.md` ; `i-have-adhd` et `ponytail`
doivent être activés (`claude plugin list`) ; `install-outils --status` ne doit signaler aucun écart.
Node.js du système absent (pas celui de `/mnt/c`) : le dire, ne l'installer qu'avec mon accord. BMAD :
seulement dans les projets que je nomme.

## Format d'une divergence

Pas de tableau (illisible dans Claude Desktop). Un bloc, court, sans ligne vide inutile :

```
DIVERGENCE : RAG-Eval-Bench (tuto)
Cette machine : tu as écrit un tutoriel web pour des élèves (28 et 29/09), avec les chapitres sur les mesures GPU.
GitHub : un autre poste a ajouté un reranker plus performant, le support GPU et de nouveaux modèles (29/09 au 15/10).
Chevauchement : les deux touchent à la façon de chercher les documents (retrieve.py).
Conseil : mélanger. Le tutoriel et le code GPU sont deux travaux différents. Je garde le code de GitHub (plus avancé) et j'ajoute ton tutoriel dessus.
Choix : garder la machine / garder GitHub / mélanger
```

Je réponds par le nom du projet et le choix : « RAG-Eval-Bench mélanger ».
Fichiers : seulement s'ils aident, regroupés `nom, nom (chemin/relatif)` ; au-delà de 4, `N fichiers
dans <dossier>` avec la taille si elle dépasse 100 Mo. Un fichier sensible ou très gros est signalé
en premier.

## Rapport final

Le rapport est celui du script (`setup_arborescence.sh`, dernière exécution) : l'afficher tel quel,
mot pour mot, sans rien ajouter ni reformuler, sauf l'explication des divergences. Trois blocs :

1. **Problèmes** (s'il y en a) : les divergences, puis « Autre ». Sinon, ne pas écrire ce bloc.
2. **Réglé** : une ligne par action. `Nom → _hors_git` pour un déplacement, `Nom : travail poussé
   (N fichiers)` pour un push. Aucune explication.
3. **État** : une ligne. `Tout est à jour : N projets, skills et plugins.` Ne pas lister les noms.

```
Réglé
Citadel-BoardGame → _hors_git
Taketime-BoardGame → _hors_git
Bibliotheque-Musicale : travail poussé (2 fichiers)

Tout est à jour : 59 projets, skills et plugins.
```

Rappeler de redémarrer Claude Code (ou `/reload-plugins`) seulement si des skills ou plugins ont
changé.
