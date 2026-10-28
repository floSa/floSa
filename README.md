# Florian Horellou — Ingénieur ML / IA & Data · ML, AI & Data Engineer

Conception de systèmes LLM de bout en bout, pensés pour tourner **on-premise** : RAG avancés, agents et orchestration multi-agents, le tout dockerisé.

**70 dépôts : 45 publics, présentés ci-dessous avec leurs liens, et 25 privés, décrits sans lien.**

[Français](#français) · [English summary](#english-summary)

---

## Français

### En quelques mots

Je conçois principalement des **systèmes LLM complets** : RAG au-delà du simple chunk (graphe de connaissances, RAG local), agents outillés et orchestration multi-agents via **MCP** et **LangGraph**, déployés sans dépendance au cloud pour garder la maîtrise de la donnée.

Autour de ce cœur : **ML/DL appliqué** (PyTorch, gradient boosting, séries temporelles), **MLOps** (MLflow, Docker) et l'ensemble de la chaîne data — collecte (scraping, annotation), modélisation, restitution applicative. Mes projets personnels me servent de terrain d'essai pour éprouver techniques et frameworks.

### Sommaire

- [Projets publics mis en avant](#projets-publics-mis-en-avant)
- [Défis IA](#défis-ia)
- [Autres projets publics](#autres-projets-publics)
- [Projets privés](#projets-privés)
- [Compétences et preuves](#compétences-et-preuves)
- [Contact](#contact)

---

### Projets publics mis en avant

#### LLM, RAG et agents

**[RAG-Ingestion-Pipeline](https://github.com/floSa/RAG-Ingestion-Pipeline)** — Pipeline d'ingestion PDF/HTML pour assistant RAG : extraction structurée via Docling, graphe de connaissances NebulaGraph, base vectorielle ChromaDB, médias sur MinIO, orchestration Dagster.
`Docling` · `NebulaGraph` · `ChromaDB` · `MinIO` · `Dagster` · `Docker`

**[RAG-Agent-Chat](https://github.com/floSa/RAG-Agent-Chat)** — Agent conversationnel qui consomme ce pipeline. Plutôt que d'injecter des chunks isolés, il exploite le graphe de connaissances pour reconstruire la section complète autour de chaque passage trouvé. Machine à états LangGraph avec sélection des sources par l'utilisateur.
`LangGraph` · `ChromaDB` · `NebulaGraph` · `Ollama` · `FastAPI`

**[RAG-Eval-Bench](https://github.com/floSa/RAG-Eval-Bench)** — Banc d'évaluation RAG on-premise : comparer des configurations entre elles sur des chiffres fiables.
`RAG` · `Évaluation` · `On-premise` · `Python`

**[Data-Analyst-Agent](https://github.com/floSa/Data-Analyst-Agent)** — Agent conversationnel sur données, on-premise : à partir d'un fichier (Excel/CSV) ou d'une base Postgres multi-tables, génère la requête (SQL avec jointures, ou DuckDB sur fichier) et répond en langage naturel.
`LangGraph` · `NL→SQL` · `DuckDB` · `PostgreSQL` · `Ollama`

**[Traceable-Agent](https://github.com/floSa/Traceable-Agent)** — Moteur d'investigation : une question complexe est décomposée en tâches atomiques, exécutées une par une dans un contexte LLM vierge, avec un fichier markdown pour seule mémoire.
`Agent` · `Décomposition de tâches` · `Traçabilité` · `Python`

**[Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration)** — Tutoriel d'orchestration multi-agents + MCP sur un fil rouge concret (une usine à la commande) : orchestrateur, sous-agents, outils exposés via MCP.
`Multi-agents` · `MCP` · `Ollama` · `Docker`

**[MCP-Maison](https://github.com/floSa/MCP-Maison)** — Socle réutilisable et entièrement dockerisé pour construire des agents ReAct s'appuyant sur des serveurs MCP, avec un petit LLM local.
`Agent ReAct` · `MCP` · `FastAPI` · `Ollama` · `Docker`

#### Outillage et développement assisté par IA

**[Dev-Brain](https://github.com/floSa/Dev-Brain)** — Base de connaissance technique versionnée (600+ fiches) couplée à deux skills Claude Code : `planifier-projet` propose un stack argumenté en début de projet, `enrichir-brain` capture les retours d'expérience en langage naturel. Chaque projet démarre sur les choix déjà faits, pas de zéro.
`Claude Code` · `Obsidian` · `Développement assisté par IA`

**[Brain-Kit](https://github.com/floSa/Brain-Kit)** — Noyau générique d'un second brain : un vault Obsidian de fichiers markdown qui se valide, se génère et se propage tout seul, sur n'importe quel sujet.
`Obsidian` · `Markdown` · `Python`

**[Veille-Repo](https://github.com/floSa/Veille-Repo)** — Catalogue des dépôts passés par le trending GitHub depuis septembre 2024 : chacun décrit, classé et résumé en une page, avec son schéma d'architecture.
`Veille` · `Catalogue` · `GitHub`

**[Catalogue-Comparateur-Solutions-IA](https://github.com/floSa/Catalogue-Comparateur-Solutions-IA)** — « Tandem » : référentiel ouvert de l'offre de développement assisté par IA, qui mesure modèles et harnais ensemble (classements, coût contre performance, tarifs et forfaits). [Page interactive](https://flosa.github.io/Catalogue-Comparateur-Solutions-IA/).
`Benchmarks` · `Dataviz` · `HTML`

**[Aosis-Deck-Builder](https://github.com/floSa/Aosis-Deck-Builder)** — Skill Claude qui génère des présentations PowerPoint à une charte graphique d'entreprise, à partir d'une spécification structurée : 17 mises en page modèles et une mise en page libre.
`Claude Skill` · `python-pptx` · `matplotlib`

#### ML/DL et data

**[Sales-Ops-Planning-POC](https://github.com/floSa/Sales-Ops-Planning-POC)** — POC de prévision des ventes (magasin × SKU × jour) pour une enseigne retail : moteur GBM Tweedie robuste aux ruptures, cascade de calcul jusqu'au CA net, dimensionnement des effectifs (ETP), analyse d'écarts prix/volume/mix et rolling forecast. Données 100 % synthétiques ; mission AOSIS Consulting.
`Prévision` · `GBM Tweedie` · `Séries temporelles` · `Simulation` · `Python`

**[Classification-Bulles](https://github.com/floSa/Classification-Bulles)** — Architecture micro-services de détection de bouchage industriel par analyse acoustique en temps réel : simulation d'usine, capteurs audio, prédictions MobileNetV2, tableau de bord Streamlit.
`PyTorch` · `Micro-services` · `Streamlit` · `Docker`

**[Detection-Pneumonie-Radio](https://github.com/floSa/Detection-Pneumonie-Radio)** — Aide au diagnostic : un modèle EfficientNet-B4 (transfer learning) classe une radiographie thoracique en normal / pneumonie, optimisé pour minimiser les faux négatifs, avec une interface Streamlit.
`PyTorch` · `EfficientNet` · `Transfer learning` · `Streamlit`

**[Karaokit](https://github.com/floSa/Karaokit)** — Karaoké maison, 100 % local : sépare la voix de la musique, récupère les paroles, les synchronise mot à mot et les affiche dans un lecteur web.
`Séparation de sources` · `Alignement forcé` · `ASR` · `Python`

**[Genealogie-Partis-France](https://github.com/floSa/Genealogie-Partis-France)** — Graphe de connaissances et frise interactive des partis politiques français depuis 1958 : scissions, fusions, changements de nom, personnes qui les ont fondés ou dirigés. Sources : Wikipédia, Wikidata, ParlGov, CHES.
`Graphe de connaissances` · `SQLite` · `JavaScript` · `Python`

---

### Défis IA

Le **Défi IA** est un concours annuel de data science qui réunit une vingtaine de grandes écoles et écoles d'ingénieurs francophones. J'ai participé aux éditions suivantes :

| Édition | Description |
|---|---|
| [2019](https://github.com/floSa/Defi-IA-2019) | Détection de fake news à partir du contenu des articles et du graphe social de partage (F1). |
| [2020](https://github.com/floSa/Defi-IA-2020) | Prédiction des upvotes de commentaires Reddit, en combinant text mining et network mining (MAE). |
| [2021](https://github.com/floSa/Defi-IA-2021) | Classification de biographies en 28 catégories de métiers, avec un axe équité hommes/femmes (Macro-F1). |
| [2022](https://github.com/floSa/Defi-IA-2022) | Prévision du cumul de pluie quotidien sur les stations du nord-ouest de la France — MeteoNet (MAPE). |
| [2023](https://github.com/floSa/Defi-IA-2023) | Pricing dynamique d'hôtels, dataset reconstitué via une API de requêtes limitée — « 1001 Nights » (RMSE). |

---

### Autres projets publics

- **Tutoriels exécutables** : [Tuto-MLflow](https://github.com/floSa/Tuto-MLflow) (MLflow + Docker, bonnes pratiques) · [Tuto-OpenMetadata](https://github.com/floSa/Tuto-OpenMetadata) (16 chapitres avec laboratoire Docker).
- **Infra réutilisable** : [Template-Services-Docker](https://github.com/floSa/Template-Services-Docker) (bases de données, Python, environnement CUDA).
- **Annotation et images** : [Annotation-Images](https://github.com/floSa/Annotation-Images) (exports COCO / YOLO / Pascal VOC) · [Annotation-Text-Streamlit](https://github.com/floSa/Annotation-Text-Streamlit) (NER) · [Images-Collection-Clean](https://github.com/floSa/Images-Collection-Clean) (extraction de cartes gradées par vision par ordinateur).
- **Analyse de données** : [Analyse-Esperance-De-Vie-FR](https://github.com/floSa/Analyse-Esperance-De-Vie-FR) · [Analyse-Habitudes-Alimentaires](https://github.com/floSa/Analyse-Habitudes-Alimentaires) · [Notebooks-Cheat-Sheet](https://github.com/floSa/Notebooks-Cheat-Sheet).
- **Collecte et optimisation** : [Cardmarket-Wantlist-Optimizer](https://github.com/floSa/Cardmarket-Wantlist-Optimizer) (scraping + optimisation MIP) · [Reels-Instagram-Graph-MD](https://github.com/floSa/Reels-Instagram-Graph-MD) (reels transformés en vault Obsidian).
- **Applications personnelles** : [Boite-A-Outils](https://github.com/floSa/Boite-A-Outils) (utilitaires Streamlit) · [Letterboxd-Perso](https://github.com/floSa/Letterboxd-Perso) (base de films, TMDb) · [Outil-Dictee-Audio](https://github.com/floSa/Outil-Dictee-Audio) (dictée vocale, Whisper local sur GPU) · [Fast-HTML-To-MD](https://github.com/floSa/Fast-HTML-To-MD) (documents vers Markdown) · [Atlas-Metiers-Roadmaps](https://github.com/floSa/Atlas-Metiers-Roadmaps) (parcours d'apprentissage pour 13 métiers IA/data).
- **Jeux et révision** : [Crossy-Road-AI-Game](https://github.com/floSa/Crossy-Road-AI-Game) (robots et IA apprenantes) · [Quiz-Geo](https://github.com/floSa/Quiz-Geo) · [Quiz-Hist](https://github.com/floSa/Quiz-Hist) (révision par répétition espacée).

---

### Projets privés

Dépôts non publics, décrits ici sans lien.

| Domaine | Ce qui a été fait | Technos |
|---|---|---|
| Jeux de société numériques (9) | Sept adaptations jouables hors-ligne dans le navigateur (7 Wonders, Dracula vs Van Helsing, Sea Salt & Paper, Toy Battle, Courtisans, Labyrinthe, Urban Rivals) et deux créations originales (Lumibois, Fil des Âges). IA sans triche, jusqu'à 5 niveaux. | React 19 · TypeScript · Vite |
| IA de jeu | Moteur de règles testé du jeu Courtisans, base d'une IA de type AlphaZero. | Python · MCTS · ResNet |
| Optimisation | Générateur de planning hebdomadaire d'usine : affectation de salariés à des postes selon compétences et disponibilités. | OR-Tools CP-SAT |
| Infra IA locale | Serveur LLM central partagé entre tous les projets : un modèle téléchargé une fois, chargé une fois en VRAM. | Ollama · Docker |
| Collecte de données | Scraper haute définition de cartes et pipeline NoSQL pour le jeu Urban Rivals. | Python · NoSQL |
| Apprentissage | Tutoriel Dagster sur un pipeline de données musicales partitionné ; manuels LM Studio pour faire tourner des LLM en local. | Dagster · LM Studio |
| Musique | Boîte à outils personnelle (albums à récupérer, artistes à découvrir) et classification de genres musicaux multi-services. | Python · Notebooks |
| Outillage personnel | Mes skills Claude Code synchronisés entre machines ; page HTML autonome pour conduire un pré-entretien technique. | Claude Code · HTML |
| Missions pour des clients | Automatisation de relances et recherche dans un référentiel d'établissements. Données non publiques. | Python · LLM |

---

### Compétences et preuves

- **LLM / IA générative** — RAG (graphe de connaissances, RAG local), agents ReAct, orchestration multi-agents, MCP, LangGraph, NL→SQL. Preuves : [RAG-Ingestion-Pipeline](https://github.com/floSa/RAG-Ingestion-Pipeline) · [RAG-Agent-Chat](https://github.com/floSa/RAG-Agent-Chat) · [Data-Analyst-Agent](https://github.com/floSa/Data-Analyst-Agent) · [Traceable-Agent](https://github.com/floSa/Traceable-Agent).
- **LLM local / on-premise** — Ollama, pgvector, ChromaDB, NebulaGraph, déploiement sans cloud. Preuves : [RAG-Eval-Bench](https://github.com/floSa/RAG-Eval-Bench) · [MCP-Maison](https://github.com/floSa/MCP-Maison) · LLM-Service (privé).
- **Deep Learning** — PyTorch, transfer learning (EfficientNet), CNN, audio (séparation de sources, alignement forcé, ASR), IA par self-play (MCTS + ResNet, privé). Preuves : [Detection-Pneumonie-Radio](https://github.com/floSa/Detection-Pneumonie-Radio) · [Classification-Bulles](https://github.com/floSa/Classification-Bulles) · [Karaokit](https://github.com/floSa/Karaokit).
- **Machine Learning et séries temporelles** — gradient boosting (XGBoost / LightGBM), scikit-learn, NLP supervisé. Preuves : [Sales-Ops-Planning-POC](https://github.com/floSa/Sales-Ops-Planning-POC) · [Défis IA](#défis-ia).
- **MLOps et architecture** — MLflow, Docker Compose, FastAPI, PostgreSQL, MongoDB, MinIO/S3. Preuves : [Tuto-MLflow](https://github.com/floSa/Tuto-MLflow) · [Template-Services-Docker](https://github.com/floSa/Template-Services-Docker) · [Classification-Bulles](https://github.com/floSa/Classification-Bulles).
- **Collecte de données et annotation** — Selenium, Playwright, BeautifulSoup, COCO / YOLO / Pascal VOC. Preuves : [Cardmarket-Wantlist-Optimizer](https://github.com/floSa/Cardmarket-Wantlist-Optimizer) · [Annotation-Images](https://github.com/floSa/Annotation-Images) · [Annotation-Text-Streamlit](https://github.com/floSa/Annotation-Text-Streamlit).
- **Analyse de données et dataviz** — pandas, EDA, sources publiques (INSEE, Eurostat, HMD), Streamlit. Preuves : [Analyse-Habitudes-Alimentaires](https://github.com/floSa/Analyse-Habitudes-Alimentaires) · [Analyse-Esperance-De-Vie-FR](https://github.com/floSa/Analyse-Esperance-De-Vie-FR) · [Genealogie-Partis-France](https://github.com/floSa/Genealogie-Partis-France).
- **Développement web** — React 19, TypeScript, Vite, applications hors-ligne. Preuves : [Quiz-Geo](https://github.com/floSa/Quiz-Geo) · [Quiz-Hist](https://github.com/floSa/Quiz-Hist) · jeux de société numériques (privés).
- **Capitalisation et développement assisté par IA** — mémoire technique versionnée, exploitée par un agent IA. Preuves : [Dev-Brain](https://github.com/floSa/Dev-Brain) · [Brain-Kit](https://github.com/floSa/Brain-Kit) · [Veille-Repo](https://github.com/floSa/Veille-Repo).

---

### Contact

- Email : florian_horellou@laposte.net
- LinkedIn : [florian-horellou](https://www.linkedin.com/in/florian-horellou/)
- GitHub : [floSa](https://github.com/floSa)

---

## English summary

**Florian Horellou — ML, AI & Data Engineer.** End-to-end LLM systems built to run **on-premise**: advanced RAG (knowledge graphs, local RAG), tool-using agents and multi-agent orchestration with **MCP** and **LangGraph**, fully dockerised, with no cloud dependency.

- **Public projects (45 repositories)**: [RAG-Ingestion-Pipeline](https://github.com/floSa/RAG-Ingestion-Pipeline) and [RAG-Agent-Chat](https://github.com/floSa/RAG-Agent-Chat) (knowledge-graph RAG), [RAG-Eval-Bench](https://github.com/floSa/RAG-Eval-Bench) (RAG evaluation), [Data-Analyst-Agent](https://github.com/floSa/Data-Analyst-Agent) (NL→SQL), [Traceable-Agent](https://github.com/floSa/Traceable-Agent), [Dev-Brain](https://github.com/floSa/Dev-Brain) (versioned technical memory for AI-assisted development), [Sales-Ops-Planning-POC](https://github.com/floSa/Sales-Ops-Planning-POC) (sales forecasting).
- **Défi IA**: five editions (2019–2023) of the annual francophone inter-school data-science challenge, listed [above](#défis-ia).
- **Private projects (25 repositories)**: offline browser adaptations of nine board games (React 19, TypeScript, Vite), an AlphaZero-style game AI, a factory-scheduling optimiser (OR-Tools CP-SAT), a shared local LLM server, and client work under confidentiality. Described in the [French section](#projets-privés).
- **Contact**: [LinkedIn](https://www.linkedin.com/in/florian-horellou/) · florian_horellou@laposte.net
