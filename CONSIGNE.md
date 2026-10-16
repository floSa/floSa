# Consigne : mettre une machine à jour

À dire à Claude Code sur n'importe quelle machine (Windows, WSL, Linux, macOS) :

> Prends le repo floSa, suis CONSIGNE.md pour mettre à jour mes projets et mes skills.

Si `floSa` n'est pas encore sur la machine : `git clone git@github.com-perso:floSa/floSa.git`
(repli `https://github.com/floSa/floSa.git`), puis lis ce fichier.

## Règles, pour toute la consigne

- Réponds en français, sans émoji, court. Une tâche à la fois, un résultat clair.
- Ne supprime rien. Seule exception : un doublon que j'ai validé (étape 4).
- Interdits : `git reset --hard`, `git clean`, `git stash drop`, `git push --force`, `rm -rf`
  sur un projet, toute écriture dans le contenu existant de `_hors_git`.
- Commits : jamais de mention de Claude, ni `Co-Authored-By`, ni « Generated with Claude ».
  Identité git du dépôt inchangée, message court, sans émoji. Jamais de `git add -A` à l'aveugle.
- Le référentiel (`setup/ARBORESCENCE.txt`) est la vérité : un dossier = un dépôt GitHub perso
  (`floSa`), et **le dossier porte exactement le nom du dépôt**. Si ce n'est pas le cas,
  corrige `ARBORESCENCE.txt` et les deux scripts, committe et pousse dans `floSa`.

## 1. Trouver la racine

- Si le dossier courant est dans `Productivite/floSa`, la racine est deux niveaux au-dessus.
  S'il contient `Productivite/floSa` ou `_hors_git`, c'est la racine.
- Sinon : Windows `Documents\Projets` ; WSL, Linux, macOS souvent `~/mes-projets` ou
  `~/Projets`. Absente ou ambiguë : demande-moi le chemin, une seule fois.
- `Productivite/floSa` absent : clone-le dedans. Présent : `git pull --ff-only`, puis relis
  cette consigne si elle a changé.
- Sous WSL, les skills vont dans le `~/.claude` de WSL, distinct de celui de Windows.

## 2. Vérifier le référentiel

Confirme-moi que `setup/ARBORESCENCE.txt` contient la règle `_hors_git` (contenu existant
intouchable ; tout dossier hors référentiel qui n'est pas réellement dans Git y est rangé)
et la règle des noms. Sinon, dis-le avant d'aller plus loin.

## 3. Avant le script : ranger ce qui n'est pas réellement dans Git

Un projet n'est « dans Git » que si TOUT est vrai (un simple `git init` ne compte pas) :
remote `origin` sur mon GitHub ; dépôt existant (`git ls-remote`) ; branche courante présente
côté GitHub ; **tous** les commits poussés **sur toutes les branches**
(`git rev-list --branches --not --remotes` vide) ; aucun stash (`git stash list` vide).

Pour chaque dossier hors référentiel (cherche aussi les anciens emplacements, 4 niveaux) :

| Cas | Action |
|---|---|
| sans `.git`, ou `git init` sans remote / sans commit / branche jamais poussée | déplacer dans `_hors_git` |
| commits ou branches non poussés sur un dépôt qui existe côté GitHub | proposer `git push` (jamais `--force`), garder en place, dire s'il faut l'ajouter au référentiel |
| remote injoignable (hors ligne, droits) | ne pas déplacer, signaler |
| même dépôt qu'un dossier du référentiel (ancien nom) | doublon, voir étape 4 |

Montre le bilan en un tableau court (dossier, verdict, action), puis déplace. `_hors_git` est
créé vide s'il manque ; collision de nom : suffixe la date ; un déplacement, jamais une
suppression. Dépôts du référentiel : même contrôle en lecture seule (commits non poussés,
modifications non commitées, branche autre que main/master, remote cassé), sans les déplacer.

## 4. Doublons

Un doublon est un dossier hors référentiel qui est le même dépôt qu'un dossier du référentiel
(même remote, ou ancien nom). Ne le supprime qu'avec mon accord, et seulement après avoir
vérifié et montré : aucun commit absent de GitHub sur aucune branche, aucun stash, aucune
modification, aucun fichier local utile (`.env`, données, réglages Obsidian, `.brainkit-local`).
Recopie ce qui est local dans la copie du référentiel, garde un `git bundle --all` et les
stashs dans `_hors_git/sauvegarde-doublons_<date>`, puis supprime.

## 5. Lancer le script

- Windows : `powershell -NoProfile -ExecutionPolicy Bypass -File <racine>\Productivite\floSa\setup\setup_arborescence.ps1 -TargetDir <racine> -Push`
- Linux, WSL, macOS : `bash <racine>/Productivite/floSa/setup/setup_arborescence.sh <racine> --push`

Il clone ou met à jour (`pull --ff-only`) chaque dépôt du référentiel, migre les anciens
noms de dossier, pousse les commits déjà faits, range dans `_hors_git` ce qui a échappé à
l'étape 3, puis installe skills et plugins. Une copie locale de skill modifiée est
sauvegardée dans `_hors_git/sauvegarde-skills_<date>` avant d'être remplacée.

## 6. Ce que le script ne décide pas

- Modifications non commitées : montre la liste des fichiers (données, gros fichiers,
  sensibles) ; ne committe et ne pousse qu'après mon accord, fichiers choisis un par un.
- Remote cassé : corrige-le vers le bon nom si GitHub le confirme (`git ls-remote`),
  puis refais le pull.
- Clone qui échoue sous Windows (nom de fichier interdit, chemin trop long) : répare sur
  place (`core.longpaths`, sparse-checkout du fichier fautif), ne supprime rien, signale-le.

## 7. Skills et plugins (dans le `~/.claude` de cette machine)

- Vérifie : chaque skill listé a un `SKILL.md` (`aosis-deck-builder`, `generer-documentation`,
  `generer-tutoriel`, `jupytext-notebooks`, `veille-github`, `watch-md`, `watch`, plus
  `planifier-projet`, `enrichir-brain`, `cloturer-brain` de Dev-Brain) ; les plugins
  `i-have-adhd` et `ponytail` sont activés ; `install-outils --status` ne signale aucun écart.
- Node.js du système absent (pas celui de `/mnt/c` sous WSL) : dis-le, propose l'installation,
  ne la fais qu'avec mon accord.
- BMAD n'est pas global : `install-outils --install bmad --project <dossier>`, seulement dans
  les projets que je te nomme.

## 8. Rapport final

Dépôts mis à jour / déjà à jour / en échec, commits poussés, dossiers rangés dans `_hors_git`
(nouveau nom et raison), doublons traités, dépôts hors référentiel signalés, skills et plugins
présents, et ce qui attend ma décision. Rappelle de redémarrer Claude Code (ou `/reload-plugins`)
pour voir les skills.
