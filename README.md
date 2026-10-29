# Ingénieur IA / ML / MLOps — Data Scientist et Data Engineer

70 dépôts GitHub.

[Français](#français) · [English](#english)

---

## Français

Je conçois des **systèmes agentiques complets** : de l'ingestion pipeline, RAG (graphe de connaissances), Agent Loop, **MCP**, à l'orchestration de multi-agents avec **LangGraph**, cela déployé **on-premise** pour garder la maîtrise de l'applicatif et des données.

Data scientist depuis 2016 en **machine learning et le deep learning** appliqués : (Méthodes ensembliste, gradient boosting, séries temporelles, vision, audio), le **MLOps** (MLflow, Docker) et l'ensemble de la chaîne data — collecte (scraping, annotation), modélisation, restitution applicative. Mes projets personnels me servent de terrain d'essai pour éprouver techniques et frameworks.

Je maîtrise l'approche agentique, intelligente et structurée du développement : j'écris et j'utilise des **skills**, je m'appuie sur des méthodes et sur une base de connaissance versionnée, pour capitaliser sur choix déjà faits et la veille constante des nouveautées.

Ingénieur IA depuis début 2024. Je ne partage ici mes **projets personnels**.

---

### Projets publics

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

**[Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration)** — Socle d'orchestration multi-agents + MCP sur un fil rouge concret (une usine à la commande) : orchestrateur, sous-agents, outils exposés via MCP.
`Multi-agents` · `MCP` · `Ollama` · `Docker`

**[MCP-Maison](https://github.com/floSa/MCP-Maison)** — Socle réutilisable et entièrement dockerisé pour construire des agents ReAct s'appuyant sur des serveurs MCP, avec un petit LLM local.
`Agent ReAct` · `MCP` · `FastAPI` · `Ollama` · `Docker`

**LLM-Service** (privé) — Serveur LLM central partagé entre tous mes projets : un modèle téléchargé une fois, chargé une fois en VRAM.
`Ollama` · `Docker`

#### Outillage et développement assisté par IA

**[Dev-Brain](https://github.com/floSa/Dev-Brain)** — Base de connaissance technique versionnée (600+ fiches) couplée à deux skills Claude Code : `planifier-projet` propose un stack argumenté en début de projet, `enrichir-brain` capture les retours d'expérience en langage naturel. Chaque projet démarre sur les choix déjà faits, pas de zéro.
`Claude Code` · `Antigravity` · `Cursor` · `DeepSeek` · `Obsidian` · `Développement assisté par IA`

**[Brain-Kit](https://github.com/floSa/Brain-Kit)** — Noyau générique d'un second brain : un vault Obsidian de fichiers markdown qui se valide, se génère et se propage tout seul, sur n'importe quel sujet.
`Obsidian` · `Markdown` · `Python`

**[Veille-Repo](https://github.com/floSa/Veille-Repo)** — Catalogue des dépôts passés par le trending GitHub depuis septembre 2024 : chacun décrit, classé et résumé en une page, avec son schéma d'architecture.
`Veille` · `Catalogue` · `GitHub`

**[Catalogue-Comparateur-Solutions-IA](https://github.com/floSa/Catalogue-Comparateur-Solutions-IA)** — Comparateur de solutions IA : référentiel ouvert qui couvre à la fois les LLM, les SLM, les modèles d'OCR, les harnais et les passerelles, avec benchmarks, classements, coût contre performance, tarifs et forfaits. [Page interactive](https://flosa.github.io/Catalogue-Comparateur-Solutions-IA/).
`Benchmarks` · `Dataviz` · `HTML`

**[Atlas-Metiers-Roadmaps](https://github.com/floSa/Atlas-Metiers-Roadmaps)** — Parcours d'apprentissage pour 13 métiers IA/data.
`Roadmaps` · `Métiers IA/data`

**Annotation** — Annoter, c'est étiqueter des données brutes (des objets dans une image, des entités dans un texte) pour construire les jeux d'entraînement d'un modèle supervisé. **[Annotation-Images](https://github.com/floSa/Annotation-Images)** annote des images, avec exports COCO / YOLO / Pascal VOC ; **[Annotation-Text-Streamlit](https://github.com/floSa/Annotation-Text-Streamlit)** annote du texte pour la reconnaissance d'entités nommées (NER).
`COCO` · `YOLO` · `Pascal VOC` · `Streamlit` · `NER`

**Skills**  — Claude Code, Antigravity, et autres harness, synchronisés entre mes machines.


**Test-Pre-Entretien-Technique** (privé) — application autonome pour conduire un pré-entretien technique dans les milieu de la data.

#### ML, deep learning, data et optimisation

**[Sales-Ops-Planning-POC](https://github.com/floSa/Sales-Ops-Planning-POC)** — Prévision des ventes (magasin × SKU × jour) pour une enseigne retail : moteur GBM Tweedie robuste aux ruptures, cascade de calcul jusqu'au CA net, dimensionnement des effectifs (ETP), analyse d'écarts prix/volume/mix et rolling forecast. Données 100 % synthétiques ; mission AOSIS Consulting.
`Prévision` · `GBM Tweedie` · `Séries temporelles` · `Simulation` · `Python`

**[Classification-Bulles](https://github.com/floSa/Classification-Bulles)** — Architecture micro-services de détection de bouchage industriel par analyse acoustique en temps réel : simulation d'usine, capteurs audio, prédictions MobileNetV2, tableau de bord Streamlit.
`PyTorch` · `Micro-services` · `Streamlit` · `Docker`

**[Detection-Pneumonie-Radio](https://github.com/floSa/Detection-Pneumonie-Radio)** — Aide au diagnostic : un modèle EfficientNet-B4 (transfer learning) classe une radiographie thoracique en normal / pneumonie, optimisé pour minimiser les faux négatifs, avec une interface Streamlit.
`PyTorch` · `EfficientNet` · `Transfer learning` · `Streamlit`

**Bibliotheque-Musicale** (privé) — Boîte à outils musicale personnelle, en douze services : inventaire de la discothèque (base SQLite et page web de recherche), détection des albums manquants à récupérer, découverte d'artistes en croisant Last.fm, Spotify, Qobuz et Deezer, et classification de genres musicaux.
`Python` · `SQLite`

**Planning-Usine-CPSAT** — Générateur de planning hebdomadaire d'usine : affectation de salariés à des postes selon compétences et disponibilités.
`OR-Tools CP-SAT`

**[Cardmarket-Wantlist-Optimizer](https://github.com/floSa/Cardmarket-Wantlist-Optimizer)** — Optimise l'achat d'une wantlist Cardmarket parmi une sélection de vendeurs : des paniers qui minimisent le coût total, cartes et frais de port compris.
`Scraping` · `Optimisation`

**Analyse de données** — **[Analyse-Esperance-De-Vie-FR](https://github.com/floSa/Analyse-Esperance-De-Vie-FR)** : application Streamlit qui analyse l'espérance de vie en France (1816–2025) et la compare au reste de l'Europe, à partir de séries publiques (INSEE, Eurostat, Our World in Data, Wikidata). **[Analyse-Habitudes-Alimentaires](https://github.com/floSa/Analyse-Habitudes-Alimentaires)** : analyse d'une enquête de 1 681 répondants sur les habitudes alimentaires et leurs déterminants sociologiques, avec application Streamlit et notebooks.
`Streamlit` · `EDA` · `Notebooks`

**[Notebooks-Cheat-Sheet](https://github.com/floSa/Notebooks-Cheat-Sheet)** — Collection de 44 cheat-sheets data science en notebooks Jupyter : structures Python, EDA, machine learning, deep learning, NLP, séries temporelles et bases de données.
`Jupyter` · `Data science`

**Défi IA** — Participation au Défi IA annuel, compétition de data science entre écoles d'ingénieurs francophones. Cinq éditions :

| Édition | Sujet |
|---|---|
| **[Defi-IA-2019](https://github.com/floSa/Defi-IA-2019)** | Détection de fake news à partir du contenu des articles et du graphe social de partage (F1). |
| **[Defi-IA-2020](https://github.com/floSa/Defi-IA-2020)** | Prédiction des upvotes de commentaires Reddit, en combinant text mining et network mining (MAE). |
| **[Defi-IA-2021](https://github.com/floSa/Defi-IA-2021)** | Classification de biographies en 28 catégories de métiers, avec un axe équité hommes/femmes (Macro-F1). |
| **[Defi-IA-2022](https://github.com/floSa/Defi-IA-2022)** | Prévision du cumul de pluie quotidien sur les stations du nord-ouest de la France, MeteoNet (MAPE). |
| **[Defi-IA-2023](https://github.com/floSa/Defi-IA-2023)** | Pricing dynamique d'hôtels, dataset reconstitué via une API de requêtes limitée, « 1001 Nights » (RMSE). |

#### MLOps, infrastructure et tutoriels

**[Tuto-MLflow](https://github.com/floSa/Tuto-MLflow)** — MLflow + Docker, bonnes pratiques.
`MLflow` · `Docker`

**[Tuto-OpenMetadata](https://github.com/floSa/Tuto-OpenMetadata)** — 16 chapitres avec laboratoire Docker.
`OpenMetadata` · `Docker`

**[Tuto-Dagster](https://github.com/floSa/Tuto-Dagster)** — L'orchestrateur Dagster et ses Software-Defined Assets, sur un pipeline de données musicales partitionné.
`Dagster` · `Python`

**[LMStudio-Bionic](https://github.com/floSa/LMStudio-Bionic)** — Manuels pratiques pour faire tourner des LLM en local avec LM Studio et son application agent Bionic, vérifiés par l'essai.
`LM Studio` · `LLM local`

**[Template-Services-Docker](https://github.com/floSa/Template-Services-Docker)** — Infra réutilisable : bases de données, Python, environnement CUDA.
`Docker` · `CUDA`

#### Jeux de société et IA de jeu

Je développe aussi des **jeux de société avec une IA intégrée**.

**7Wonders**, **Dracula-VS-Van-Helsing**, **Sea-Salt-And-Paper**, **Toy-Battle**, **Labyrinthe** (privé) — Adaptations jouables hors-ligne dans le navigateur. IA sans triche, jusqu'à 5 niveaux.
`React 19` · `TypeScript` · `Vite`

**Courtisans** (privé) — Adaptation jouable hors-ligne, avec un moteur de règles testé qui sert de base à une IA de type AlphaZero : elle apprend par self-play (apprentissage par renforcement).
`React 19` · `Python` · `MCTS` · `ResNet`

**Urban-Rivals** (privé) — Adaptation jouable hors-ligne, avec un scraper haute définition des cartes et un pipeline NoSQL.
`React 19` · `Python` · `NoSQL`

**Harmonies** (Lumibois) et **Timelinetwist** (Fil des Âges) (privé) — Deux créations originales.
`React 19` · `TypeScript` · `Vite`

**[Crossy-Road-AI-Game](https://github.com/floSa/Crossy-Road-AI-Game)** — Robots et IA apprenantes.

**Quiz** — Jeux de quiz avec révision par répétition espacée : **[Quiz-Geo](https://github.com/floSa/Quiz-Geo)** pour la géographie, **[Quiz-Hist](https://github.com/floSa/Quiz-Hist)** pour l'histoire.

#### Autres projets de développement

**[Karaokit](https://github.com/floSa/Karaokit)** — Karaoké maison, 100 % local : sépare la voix de la musique, récupère les paroles, les synchronise mot à mot et les affiche dans un lecteur web.
`Séparation de sources` · `Alignement forcé` · `ASR` · `Python`

**[Genealogie-Partis-France](https://github.com/floSa/Genealogie-Partis-France)** — Graphe de connaissances et frise interactive des partis politiques français depuis 1958 : scissions, fusions, changements de nom, personnes qui les ont fondés ou dirigés. Sources : Wikipédia, Wikidata, ParlGov, CHES.
`Graphe de connaissances` · `SQLite` · `JavaScript` · `Python`

**[Boite-A-Outils](https://github.com/floSa/Boite-A-Outils)** — Outils sur la modifications / édition / conversion / compression / doublons / renommage en masse de fichiers audio, images, vidéo, PDF ...

**[Letterboxd-Perso](https://github.com/floSa/Letterboxd-Perso)** — Accès à la base de données TMDb, avec annotation des films, favoris et watchlist.

**[Outil-Dictee-Audio](https://github.com/floSa/Outil-Dictee-Audio)** — Dictée vocale to Texte (speech to text) local sur GPU sur base de modèle Whisper 
`Whisper` · `GPU`

**[Fast-HTML-To-MD](https://github.com/floSa/Fast-HTML-To-MD)** — Extraction de page HTML vers Markdown, après nettoyage en gardant images, Schémas, Formules et Tableaux

---

### Contact

- Email : florian_horellou@laposte.net
- LinkedIn : [florian-horellou](https://www.linkedin.com/in/florian-horellou/)
- GitHub : [floSa](https://github.com/floSa)

---

## English

**AI / ML / MLOps Engineer — Data Scientist and Data Engineer.**

I mainly design **complete agentic systems**: data ingestion, RAG (knowledge graphs, local RAG), agent loops, **MCP** and multi-agent orchestration with **LangGraph**. I deploy them **on-premise** to keep control of the application, not only of the data.

Around that core: applied machine learning and deep learning (PyTorch, gradient boosting, time series, vision, audio), MLOps (MLflow, Docker) and the whole data chain — collection, annotation, modelling, application delivery. I take an agentic, structured approach to development: I write and use **skills**, and rely on a versioned knowledge base so that every project starts from choices already made.

Data scientist since 2016, AI engineer since early 2024. I only share personal projects here; I cannot present my professional work. A project cited without a link is not public.

**LLM, RAG and agents** — [RAG-Ingestion-Pipeline](https://github.com/floSa/RAG-Ingestion-Pipeline) and [RAG-Agent-Chat](https://github.com/floSa/RAG-Agent-Chat) (knowledge-graph RAG), [RAG-Eval-Bench](https://github.com/floSa/RAG-Eval-Bench) (on-premise RAG evaluation), [Data-Analyst-Agent](https://github.com/floSa/Data-Analyst-Agent) (NL→SQL), [Traceable-Agent](https://github.com/floSa/Traceable-Agent) (task decomposition), [Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration) and [MCP-Maison](https://github.com/floSa/MCP-Maison) (multi-agent and MCP foundations), **LLM-Service** (private, a shared local LLM server for all my projects).

**Tooling and AI-assisted development** — [Dev-Brain](https://github.com/floSa/Dev-Brain) (versioned technical memory with Claude Code skills, usable from Antigravity, Cursor and others), [Brain-Kit](https://github.com/floSa/Brain-Kit), [Veille-Repo](https://github.com/floSa/Veille-Repo) (catalogue of GitHub trending repositories), [Catalogue-Comparateur-Solutions-IA](https://github.com/floSa/Catalogue-Comparateur-Solutions-IA) (open comparison of AI solutions: LLMs, SLMs, OCR models, harnesses and gateways, with benchmarks and pricing), [Atlas-Metiers-Roadmaps](https://github.com/floSa/Atlas-Metiers-Roadmaps), annotation tools, **Mes-Skills** (private, my own Claude Code skills).

**ML, deep learning, data and optimisation** — [Sales-Ops-Planning-POC](https://github.com/floSa/Sales-Ops-Planning-POC) (retail sales forecasting), [Classification-Bulles](https://github.com/floSa/Classification-Bulles) (acoustic anomaly detection), [Detection-Pneumonie-Radio](https://github.com/floSa/Detection-Pneumonie-Radio) (chest X-ray classification), **Planning-Usine-CPSAT** (factory scheduling with OR-Tools CP-SAT). I took part in five editions (2019–2023) of the annual **Défi IA**, a data-science challenge between francophone engineering schools: [2019](https://github.com/floSa/Defi-IA-2019) · [2020](https://github.com/floSa/Defi-IA-2020) · [2021](https://github.com/floSa/Defi-IA-2021) · [2022](https://github.com/floSa/Defi-IA-2022) · [2023](https://github.com/floSa/Defi-IA-2023).

**MLOps and tutorials** — [Tuto-MLflow](https://github.com/floSa/Tuto-MLflow), [Tuto-OpenMetadata](https://github.com/floSa/Tuto-OpenMetadata), [Tuto-Dagster](https://github.com/floSa/Tuto-Dagster), [LMStudio-Bionic](https://github.com/floSa/LMStudio-Bionic) (hands-on manuals for running LLMs locally), [Template-Services-Docker](https://github.com/floSa/Template-Services-Docker).

**Board games and game AI** — Offline browser adaptations of seven board games and two original creations, with cheat-free AI up to five levels (React 19, TypeScript, Vite) (private); **Courtisans**, an AlphaZero-style AI trained by self-play with MCTS and a ResNet (reinforcement learning) (private); [Crossy-Road-AI-Game](https://github.com/floSa/Crossy-Road-AI-Game).

**Other development projects** — [Karaokit](https://github.com/floSa/Karaokit) (local karaoke with source separation and forced alignment), [Genealogie-Partis-France](https://github.com/floSa/Genealogie-Partis-France) (knowledge graph of French political parties), [Letterboxd-Perso](https://github.com/floSa/Letterboxd-Perso), [Outil-Dictee-Audio](https://github.com/floSa/Outil-Dictee-Audio) and others.

**Contact** — [LinkedIn](https://www.linkedin.com/in/florian-horellou/) · florian_horellou@laposte.net
