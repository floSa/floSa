# Prompt de mise à jour d'une machine

À coller dans une session Claude Code ouverte sur n'importe quelle machine (Windows,
WSL, Linux, macOS). Il remet à jour l'arborescence des projets, range ce qui est hors
Git sans rien supprimer, et installe ou met à jour les skills.

Les scripts qu'il lance sont dans ce dossier : `setup_arborescence.ps1` (Windows) et
`setup_arborescence.sh` (Linux, WSL, macOS). Le référentiel des dépôts est dans
`ARBORESCENCE.txt`.

Sous WSL, la session Claude Desktop tourne dans WSL : lancer ce prompt dans une session
ouverte sur un projet WSL, pour que les skills s'installent dans le `~/.claude` de WSL.

## Le prompt

```text
Remets cette machine à jour : arborescence des projets, projets hors Git, skills.
Réponds en français, sans émoji. Ne supprime rien, jamais.

1. Trouver l'arborescence
- Cherche le dossier racine des projets : celui qui contient _hors_git et
  Productivite/floSa (Windows : Documents\Projets ; WSL ou Linux : souvent ~/mes-projets
  ou ~/Projets). S'il n'existe pas ou est ambigu, demande-moi le chemin, une seule fois.
- Si Productivite/floSa est absent, clone git@github.com-perso:floSa/floSa.git (repli
  https://github.com/floSa/floSa.git) dans Productivite/floSa. Fais un git pull --ff-only
  dessus pour avoir les scripts à jour.

2. Vérifier la consigne
- Lis setup/ARBORESCENCE.txt et confirme-moi qu'elle contient la règle _hors_git :
  contenu existant intouchable, tout dossier non versionné hors référentiel y est rangé,
  jamais supprimé. Si la règle manque ou diffère, dis-le avant d'aller plus loin.

3. État des lieux avant de lancer quoi que ce soit (lecture seule)
- Liste les dossiers de l'arborescence absents du référentiel (ARBORESCENCE.txt) :
  non versionnés, ou dépôts git hors liste.
- Pour chaque dépôt : commits non poussés, modifications non commitées, branche autre
  que main/master, remote cassé (dépôt introuvable, ancien nom).
- Montre-moi ce bilan en un tableau court.

4. Lancer le script
- Windows : powershell -NoProfile -ExecutionPolicy Bypass -File Productivite\floSa\setup\setup_arborescence.ps1 -TargetDir <racine> -Push
- Linux, WSL, macOS : bash Productivite/floSa/setup/setup_arborescence.sh <racine> --push
- Le script met à jour chaque dépôt (pull --ff-only), pousse les commits déjà faits,
  range dans _hors_git les dossiers non versionnés hors référentiel (renommés avec la date
  en cas de collision) et signale les dépôts git hors référentiel sans les déplacer.
  Il installe aussi les skills et les plugins (étape 6).

5. Ce que le script ne décide pas à ma place
- Dépôts avec modifications non commitées : montre-moi la liste des fichiers (dossiers
  de données, gros fichiers, fichiers sensibles repérés). Ne commite et ne pousse qu'après
  mon accord, fichiers choisis un par un ; jamais de git add -A à l'aveugle.
- Dépôts git hors référentiel : pousse leurs commits non poussés s'ils ont un remote, puis
  demande-moi : les ajouter au référentiel (ARBORESCENCE.txt et les deux scripts) ou les
  ranger dans _hors_git.
- Remote cassé : corrige-le vers le bon nom de dépôt si GitHub le confirme (gh repo view),
  puis refais le pull.
- Commits : jamais de mention de Claude, ni Co-Authored-By, ni "Generated with Claude",
  dans le message ni dans le corps. Identité git du dépôt inchangée, message court,
  sans émoji.
- Interdits : git reset --hard, git clean, git stash drop, git push --force, rm -rf sur un
  projet, toute écriture dans le contenu existant de _hors_git.

6. Skills et plugins
- Le script installe les skills de Productivite/claude-skills et de
  Productivite/Dev-Brain/.claude/skills dans ~/.claude/skills (copies sous Windows, liens
  symboliques ailleurs), puis les plugins i-have-adhd et ponytail via
  claude-skills/outils-externes/install-outils.
- Vérifie ensuite : liste des dossiers de ~/.claude/skills, chacun avec un SKILL.md ;
  claude plugin list (i-have-adhd et ponytail activés) ; comparaison des skills installés
  avec leur source (diff) si la machine copie au lieu de lier.
- Si Node.js est absent (WSL, Linux), dis-le : les plugins s'installent mais leurs hooks
  échoueront. Propose l'installation, ne la fais qu'avec mon accord.
- BMAD n'est pas global : il s'installe projet par projet avec
  install-outils --install bmad --project <dossier>. Ne l'installe que dans les projets
  que je te nomme.

7. Rapport final
- Dépôts mis à jour / déjà à jour / en échec, commits poussés, dossiers rangés dans
  _hors_git (avec leur nouveau nom), dépôts hors référentiel signalés, skills et plugins
  présents, et ce qui attend une décision de ma part.
- Rappelle qu'il faut redémarrer Claude Code (ou /reload-plugins) pour voir les skills.
```

## Options des scripts

| Option | Windows | Linux, WSL, macOS | Effet |
|---|---|---|---|
| Dossier racine | `-TargetDir <dossier>` | premier argument | racine de l'arborescence |
| Pousser | `-Push` | `--push` | pousse les commits déjà faits, ne commite jamais |
| Sans skills | `-NoSkills` | `--no-skills` | saute l'étape skills et plugins |
| Séquentiel | (déjà séquentiel) | `--sequential` | un dépôt à la fois |

Variable `CLAUDE_SKILLS_DIR` : change le dossier cible des skills (par défaut
`~/.claude/skills`).
