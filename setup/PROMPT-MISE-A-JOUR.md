# Prompt de mise à jour d'une machine

À coller dans une session Claude Code ouverte dans le dossier qui contient les projets,
sur n'importe quelle machine (Windows, WSL, Linux, macOS). Il vérifie d'abord que chaque
projet est réellement dans Git, range le reste dans `_hors_git`, remet l'arborescence et
tous les dépôts à jour, puis installe ou met à jour les skills.

Les scripts qu'il lance sont dans ce dossier : `setup_arborescence.ps1` (Windows) et
`setup_arborescence.sh` (Linux, WSL, macOS). Le référentiel des dépôts est dans
`ARBORESCENCE.txt`. Ils appliquent eux-mêmes la règle de l'étape 3 : le prompt la fait
d'abord à la main, avec toi, pour que rien ne soit déplacé à l'aveugle.

Sous WSL, la session Claude Desktop tourne dans WSL : les skills s'installent dans le
`~/.claude` de WSL, distinct de celui de Windows.

## Le prompt

```text
Remets cette machine à jour : projets hors Git, arborescence, dépôts, skills.
Réponds en français, sans émoji. Ne supprime rien, jamais.

1. Trouver l'arborescence
- Prends le dossier courant s'il contient _hors_git et Productivite/floSa ; sinon cherche
  la racine de mes projets (Windows : Documents\Projets ; WSL, Linux, macOS : souvent
  ~/mes-projets ou ~/Projets). Si elle est absente ou ambiguë, demande-moi le chemin,
  une seule fois.
- Si Productivite/floSa est absent, clone git@github.com-perso:floSa/floSa.git (repli
  https://github.com/floSa/floSa.git) dans Productivite/floSa. S'il existe, git pull
  --ff-only. Les scripts sont dans setup/ ; le référentiel est setup/ARBORESCENCE.txt.

2. Vérifier la consigne
- Lis setup/ARBORESCENCE.txt et confirme-moi qu'elle contient la règle _hors_git :
  contenu existant intouchable ; tout dossier hors référentiel qui n'est pas réellement
  dans Git y est rangé, jamais supprimé. Si la règle manque, dis-le avant d'aller plus loin.

3. AVANT le script : ranger ce qui n'est pas réellement dans Git
- Un projet n'est « dans Git » que si TOUTES ces conditions sont vraies. Un simple
  git init ne compte pas :
    a. il a un remote origin (mon GitHub, floSa) ;
    b. le dépôt existe côté GitHub (git ls-remote ou gh repo view) ;
    c. sa branche courante existe côté GitHub ;
    d. ses commits sont poussés (rien en avance sur origin).
- Pour chaque dossier de l'arborescence qui n'est PAS dans setup/ARBORESCENCE.txt
  (cherche aussi dans les anciens emplacements, jusqu'à 4 niveaux) :
    - dossier sans .git : à déplacer dans _hors_git ;
    - git init sans remote, aucun commit, ou branche jamais poussée : à déplacer dans
      _hors_git ;
    - commits en avance sur une branche qui existe côté GitHub : propose de les pousser
      (git push, jamais --force), puis garde le projet en place et dis-moi s'il faut
      l'ajouter au référentiel ;
    - remote injoignable (hors ligne, droits) : ne déplace pas, signale-le.
- Montre-moi ce bilan en un tableau court (dossier, verdict, action), puis déplace dans
  _hors_git ce qui est à déplacer. Collision de nom : suffixe la date. Je ne veux rien
  perdre : un déplacement, jamais une suppression.
- Même contrôle, en lecture seule, pour les dépôts du référentiel : commits non poussés,
  modifications non commitées, branche autre que main/master, remote cassé. Ne les déplace
  pas.

4. Lancer le script
- Windows : powershell -NoProfile -ExecutionPolicy Bypass -File <racine>\Productivite\floSa\setup\setup_arborescence.ps1 -TargetDir <racine> -Push
- Linux, WSL, macOS : bash <racine>/Productivite/floSa/setup/setup_arborescence.sh <racine> --push
- Il met chaque dépôt du référentiel à jour (pull --ff-only, clone s'il manque, migration
  depuis un ancien emplacement), pousse les commits déjà faits, refait le contrôle de
  l'étape 3 pour ce qui aurait échappé, puis installe les skills et plugins (étape 6).

5. Ce que le script ne décide pas à ma place
- Dépôts avec modifications non commitées : montre-moi la liste des fichiers (données,
  gros fichiers, fichiers sensibles). Ne commite et ne pousse qu'après mon accord, fichiers
  choisis un par un ; jamais de git add -A à l'aveugle.
- Remote cassé : corrige-le vers le bon nom de dépôt si GitHub le confirme (gh repo view),
  puis refais le pull.
- Commits : jamais de mention de Claude, ni Co-Authored-By, ni "Generated with Claude",
  dans le message ni dans le corps. Identité git du dépôt inchangée, message court,
  sans émoji.
- Interdits : git reset --hard, git clean, git stash drop, git push --force, rm -rf sur un
  projet, toute écriture dans le contenu existant de _hors_git.

6. Skills et plugins (dans le ~/.claude de cette machine)
- Le script installe les skills de Productivite/claude-skills (install.sh) et ceux de
  Productivite/Dev-Brain/.claude/skills dans ~/.claude/skills (copies sous Windows, liens
  symboliques ailleurs), puis les plugins i-have-adhd et ponytail avec
  claude-skills/outils-externes/install-outils.
- Vérifie ensuite : chaque dossier de ~/.claude/skills a un SKILL.md ; la liste correspond
  au README de claude-skills (aosis-deck-builder, generer-documentation, generer-tutoriel,
  jupytext-notebooks, veille-github, watch-md, watch) plus planifier-projet, enrichir-brain
  et cloturer-brain de Dev-Brain ; claude plugin list montre i-have-adhd et ponytail
  activés ; install-outils --status ne signale aucun écart.
- Si Node.js (celui du système, pas /mnt/c sous WSL) est absent, dis-le : les plugins
  s'installent mais leurs hooks échouent. Propose l'installation, ne la fais qu'avec mon
  accord.
- BMAD n'est pas global : il s'installe projet par projet avec
  install-outils --install bmad --project <dossier>. Ne l'installe que dans les projets
  que je te nomme.

7. Rapport final
- Dépôts mis à jour / déjà à jour / en échec, commits poussés, dossiers rangés dans
  _hors_git (avec leur nouveau nom et la raison), dépôts hors référentiel signalés, skills
  et plugins présents, et ce qui attend une décision de ma part.
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
