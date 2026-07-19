# Florian Horellou — Ingénieur ML / IA & Data · ML, AI & Data Engineer

Conception de systèmes LLM de bout en bout, pensés pour tourner **on-premise** : RAG avancés, agents et orchestration multi-agents, le tout dockerisé.

[Français](#français) · [English](#english)

---

## Français

### En quelques mots

Je conçois principalement des **systèmes LLM complets** : RAG au-delà du simple chunk (graphe de connaissances, RAG local), agents outillés et orchestration multi-agents via **MCP** et **LangGraph**, déployés sans dépendance au cloud pour garder la maîtrise de la donnée.

Autour de ce cœur : **ML/DL appliqué** (PyTorch, gradient boosting, séries temporelles), **MLOps** (MLflow, Docker) et l'ensemble de la chaîne data — collecte (scraping, annotation), modélisation, restitution applicative. Mes projets personnels me servent de terrain d'essai pour éprouver techniques et frameworks.

### Compétences & techniques

**LLM / IA générative** — RAG (graphe de connaissances, RAG local), agents ReAct, orchestration multi-agents, MCP, LangGraph, human-in-the-loop, NL→SQL.
Preuves : [rag-ingestion-pipeline](https://github.com/floSa/rag-ingestion-pipeline) · [rag-agent-chat](https://github.com/floSa/rag-agent-chat) · [data-analyst-agent](https://github.com/floSa/data-analyst-agent) · [Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration)

**LLM local / on-premise** — Ollama, pgvector, ChromaDB, NebulaGraph. Déploiement sans cloud, contrainte de confidentialité.

**Deep Learning** — PyTorch, transfer learning (EfficientNet), CNN, IA par self-play (MCTS + ResNet), audio (séparation de sources, alignement forcé, ASR).
Preuves : [Courtisans_Game](https://github.com/floSa/Courtisans_Game) · [classification_bubbles](https://github.com/floSa/classification_bubbles) · [image_detection_pneumonia](https://github.com/floSa/image_detection_pneumonia) · [karaokit](https://github.com/floSa/karaokit)

**Machine Learning & NLP** — gradient boosting (XGBoost / LightGBM), scikit-learn, NLP supervisé, séries temporelles.
Preuves : voir la section [Défis IA](#défis-ia) plus bas.

**MLOps & reproductibilité** — MLflow, Docker, environnements de services réutilisables.
Preuves : [mlflow_tuto](https://github.com/floSa/mlflow_tuto) · [Template-services-docker](https://github.com/floSa/Template-services-docker).

**Architecture & micro-services** — Docker Compose, FastAPI, PostgreSQL, MongoDB, MinIO/S3, services temps réel.
Preuves : [classification_bubbles](https://github.com/floSa/classification_bubbles) (détection acoustique temps réel) · [MCP_maison](https://github.com/floSa/MCP_maison).

**Collecte de données & scraping** — Selenium, Playwright, BeautifulSoup, structuration de données web.
Preuves : [urban-rivals-scraper](https://github.com/floSa/urban-rivals-scraper) · [cardmarket-wantlist-optimizer](https://github.com/floSa/cardmarket-wantlist-optimizer) (scraping + optimisation MIP).

**Annotation & datasets** — outils d'annotation, exports COCO / YOLO / Pascal VOC, NER.
Preuves : [Annotation-Images](https://github.com/floSa/Annotation-Images) · [Annotation-Text-Streamlit](https://github.com/floSa/Annotation-Text-Streamlit).

**Analyse de données & dataviz** — pandas, EDA, sources publiques (INSEE, Eurostat, HMD), applications Streamlit multi-pages.
Preuves : [food-habits-analysis](https://github.com/floSa/food-habits-analysis) · [esperance_de_vie_FR](https://github.com/floSa/esperance_de_vie_FR).

**Veille & dev assisté par IA** — mémoire technique versionnée, exploitée par un agent IA comme contexte de développement.
Preuves : [DevBrain](https://github.com/floSa/DevBrain).

### Projets phares

**[rag-ingestion-pipeline](https://github.com/floSa/rag-ingestion-pipeline)** — Pipeline d'ingestion PDF/HTML pour assistant RAG : extraction structurée via Docling, graphe de connaissances NebulaGraph, base vectorielle ChromaDB, médias sur MinIO, orchestration Dagster.
`Docling` · `NebulaGraph` · `ChromaDB` · `MinIO` · `Dagster` · `Docker`

**[rag-agent-chat](https://github.com/floSa/rag-agent-chat)** — Agent conversationnel qui consomme ce pipeline. Plutôt que d'injecter des chunks isolés, il exploite le graphe de connaissances pour reconstruire la section complète autour de chaque passage trouvé. Machine à états LangGraph avec sélection des sources par l'utilisateur.
`LangGraph` · `ChromaDB` · `NebulaGraph` · `Ollama` · `FastAPI`

**[DevBrain](https://github.com/floSa/DevBrain)** — Base de connaissance technique versionnée (600+ fiches) couplée à deux skills Claude Code : `planifier-projet` propose un stack argumenté en début de projet, `enrichir-brain` capture les retours d'expérience en langage naturel. Chaque projet démarre sur les choix déjà faits, pas de zéro.
`Claude Code` · `Obsidian` · `Développement assisté par IA`

**[data-analyst-agent](https://github.com/floSa/data-analyst-agent)** — Agent conversationnel sur données, on-premise : à partir d'un fichier (Excel/CSV) ou d'une base Postgres multi-tables, génère la requête (SQL avec jointures, ou DuckDB sur fichier) et répond en langage naturel.
`LangGraph` · `NL→SQL` · `DuckDB` · `PostgreSQL` · `Ollama`

**[Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration)** — Tutoriel d'orchestration multi-agents + MCP sur un fil rouge concret (une usine à la commande) : orchestrateur, sous-agents, outils exposés via MCP.
`Multi-agents` · `MCP` · `Ollama` · `Docker`

**[MCP_maison](https://github.com/floSa/MCP_maison)** — Socle réutilisable et entièrement dockerisé pour construire des agents ReAct s'appuyant sur des serveurs MCP, avec un petit LLM local.
`Agent ReAct` · `MCP` · `FastAPI` · `Ollama` · `Docker`

**[sales-ops-planning-poc](https://github.com/floSa/sales-ops-planning-poc)** — POC de prévision des ventes (magasin × SKU × jour) pour une enseigne retail : moteur GBM Tweedie robuste aux ruptures, cascade de calcul jusqu'au CA net, dimensionnement des effectifs (ETP), analyse d'écarts prix/volume/mix et rolling forecast. Données 100 % synthétiques ; mission AOSIS Consulting.
`Prévision` · `GBM Tweedie` · `Séries temporelles` · `Simulation` · `Python`

**[Courtisans_Game](https://github.com/floSa/Courtisans_Game)** — Implémentation du jeu de cartes Courtisans avec une IA inspirée d'AlphaZero (MCTS + ResNet) et une interface pour jouer contre elle.
`PyTorch` · `MCTS` · `ResNet` · `Streamlit`

### Défis IA

Le **Défi IA** est un concours annuel de data science qui réunit une vingtaine de grandes écoles et écoles d'ingénieurs francophones. Je reprends ces éditions à partir de zéro, avec des méthodes actuelles et un protocole d'évaluation rigoureux, souvent pour dépasser le score du vainqueur de l'époque.

| Édition | Tâche | Métrique | Résultat |
|---|---|---|---|
| [2019](https://github.com/floSa/Defi-IA-2019) | Détection de fake news (contenu + graphe social) | F1 | transformers + GNN — *en cours* |
| [2020](https://github.com/floSa/Defi-IA-2020) | Prédiction des upvotes Reddit (text + network mining) | MAE | *en cours* |
| [2021](https://github.com/floSa/Defi-IA-2021) | Classification de métiers depuis des biographies (28 classes) | Macro-F1 + équité | pipeline reproductible, axe fairness |
| [2022](https://github.com/floSa/Defi-IA-2022) | Prévision du cumul de pluie quotidien (MeteoNet) | MAPE | **23.86** — sous le vainqueur de l'époque (23.8) |
| [2023](https://github.com/floSa/Defi-IA-2023) | Pricing dynamique d'hôtels via API limitée (« 1001 Nights ») | RMSE | reconstruction du dataset + modélisation — *en cours* |

### Contact

- Email : florian_horellou@laposte.net
- LinkedIn : [florian-horellou](https://www.linkedin.com/in/florian-horellou/)
- GitHub : [floSa](https://github.com/floSa)

---

## English

### In a nutshell

I mainly build **end-to-end LLM systems**: RAG beyond plain chunking (knowledge graphs, local RAG), tool-using agents and multi-agent orchestration through **MCP** and **LangGraph**, deployed without cloud dependency to keep full control over the data.

Around this core: **applied ML/DL** (PyTorch, gradient boosting, time series), **MLOps** (MLflow, Docker) and the full data chain — collection (scraping, annotation), modelling, application delivery. My personal projects act as a testing ground for techniques and frameworks.

### Skills & techniques

**LLM / Generative AI** — RAG (knowledge graph, local RAG), ReAct agents, multi-agent orchestration, MCP, LangGraph, human-in-the-loop, NL→SQL.
Evidence: [rag-ingestion-pipeline](https://github.com/floSa/rag-ingestion-pipeline) · [rag-agent-chat](https://github.com/floSa/rag-agent-chat) · [data-analyst-agent](https://github.com/floSa/data-analyst-agent) · [Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration)

**Local / on-premise LLM** — Ollama, pgvector, ChromaDB, NebulaGraph. Cloud-free deployment for data-sensitive settings.

**Deep Learning** — PyTorch, transfer learning (EfficientNet), CNN, self-play AI (MCTS + ResNet), audio (source separation, forced alignment, ASR).
Evidence: [Courtisans_Game](https://github.com/floSa/Courtisans_Game) · [classification_bubbles](https://github.com/floSa/classification_bubbles) · [image_detection_pneumonia](https://github.com/floSa/image_detection_pneumonia) · [karaokit](https://github.com/floSa/karaokit)

**Machine Learning & NLP** — gradient boosting (XGBoost / LightGBM), scikit-learn, supervised NLP, time series.
Evidence: see the [Défi IA challenges](#défi-ia-challenges) section below.

**MLOps & reproducibility** — MLflow, Docker, reusable service environments.
Evidence: [mlflow_tuto](https://github.com/floSa/mlflow_tuto) · [Template-services-docker](https://github.com/floSa/Template-services-docker).

**Architecture & micro-services** — Docker Compose, FastAPI, PostgreSQL, MongoDB, MinIO/S3, real-time services.
Evidence: [classification_bubbles](https://github.com/floSa/classification_bubbles) (real-time acoustic detection) · [MCP_maison](https://github.com/floSa/MCP_maison).

**Data collection & scraping** — Selenium, Playwright, BeautifulSoup, structuring web data.
Evidence: [urban-rivals-scraper](https://github.com/floSa/urban-rivals-scraper) · [cardmarket-wantlist-optimizer](https://github.com/floSa/cardmarket-wantlist-optimizer) (scraping + MIP optimisation).

**Annotation & datasets** — annotation tools, COCO / YOLO / Pascal VOC exports, NER.
Evidence: [Annotation-Images](https://github.com/floSa/Annotation-Images) · [Annotation-Text-Streamlit](https://github.com/floSa/Annotation-Text-Streamlit).

**Data analysis & dataviz** — pandas, EDA, public data sources (INSEE, Eurostat, HMD), multi-page Streamlit apps.
Evidence: [food-habits-analysis](https://github.com/floSa/food-habits-analysis) · [esperance_de_vie_FR](https://github.com/floSa/esperance_de_vie_FR).

**Knowledge management & AI-assisted development** — versioned technical memory used by an AI agent as development context.
Evidence: [DevBrain](https://github.com/floSa/DevBrain).

### Featured projects

**[rag-ingestion-pipeline](https://github.com/floSa/rag-ingestion-pipeline)** — PDF/HTML ingestion pipeline for a RAG assistant: structured extraction with Docling, NebulaGraph knowledge graph, ChromaDB vector store, media on MinIO, Dagster orchestration.
`Docling` · `NebulaGraph` · `ChromaDB` · `MinIO` · `Dagster` · `Docker`

**[rag-agent-chat](https://github.com/floSa/rag-agent-chat)** — Conversational agent consuming that pipeline. Instead of injecting isolated chunks, it uses the knowledge graph to rebuild the full section around each retrieved passage. LangGraph state machine with user-driven source selection.
`LangGraph` · `ChromaDB` · `NebulaGraph` · `Ollama` · `FastAPI`

**[DevBrain](https://github.com/floSa/DevBrain)** — Versioned technical knowledge base (600+ notes) paired with two custom Claude Code skills: `planifier-projet` proposes a sourced stack at project kickoff, `enrichir-brain` captures lessons learned in natural language. Every project starts from choices already made, not from scratch.
`Claude Code` · `Obsidian` · `AI-assisted development`

**[data-analyst-agent](https://github.com/floSa/data-analyst-agent)** — On-premise conversational agent over data: from a file (Excel/CSV) or a multi-table Postgres database, it generates the query (SQL with joins, or DuckDB over a file) and answers in natural language.
`LangGraph` · `NL→SQL` · `DuckDB` · `PostgreSQL` · `Ollama`

**[Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration)** — Multi-agent + MCP orchestration tutorial built around a concrete example (a made-to-order factory): orchestrator, sub-agents, tools exposed through MCP.
`Multi-agents` · `MCP` · `Ollama` · `Docker`

**[MCP_maison](https://github.com/floSa/MCP_maison)** — Reusable, fully dockerised foundation for building ReAct agents backed by MCP servers, with a small local LLM.
`ReAct agent` · `MCP` · `FastAPI` · `Ollama` · `Docker`

**[sales-ops-planning-poc](https://github.com/floSa/sales-ops-planning-poc)** — Sales-forecasting POC (store × SKU × day) for a retail chain: rupture-robust Tweedie GBM engine, calculation cascade down to net revenue, staffing (FTE) sizing, price/volume/mix variance analysis and rolling forecast. Fully synthetic data; AOSIS Consulting engagement.
`Forecasting` · `Tweedie GBM` · `Time series` · `Simulation` · `Python`

**[Courtisans_Game](https://github.com/floSa/Courtisans_Game)** — Implementation of the Courtisans card game with an AlphaZero-inspired AI (MCTS + ResNet) and an interface to play against it.
`PyTorch` · `MCTS` · `ResNet` · `Streamlit`

### Défi IA challenges

The **Défi IA** is an annual data-science competition bringing together around twenty francophone *grandes écoles* and engineering schools. I revisit these editions from scratch with modern methods and a rigorous evaluation protocol, often aiming to beat the original winner's score.

| Edition | Task | Metric | Result |
|---|---|---|---|
| [2019](https://github.com/floSa/Defi-IA-2019) | Fake-news detection (content + social graph) | F1 | transformers + GNN — *in progress* |
| [2020](https://github.com/floSa/Defi-IA-2020) | Reddit upvote prediction (text + network mining) | MAE | *in progress* |
| [2021](https://github.com/floSa/Defi-IA-2021) | Job classification from biographies (28 classes) | Macro-F1 + fairness | reproducible, fairness-aware pipeline |
| [2022](https://github.com/floSa/Defi-IA-2022) | Daily rainfall forecasting (MeteoNet) | MAPE | **23.86** — below the original winner (23.8) |
| [2023](https://github.com/floSa/Defi-IA-2023) | Hotel dynamic pricing via a rate-limited API ("1001 Nights") | RMSE | dataset rebuild + modelling — *in progress* |

### Contact

- Email: florian_horellou@laposte.net
- LinkedIn: [florian-horellou](https://www.linkedin.com/in/florian-horellou/)
- GitHub: [floSa](https://github.com/floSa)
