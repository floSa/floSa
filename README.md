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

**Deep Learning** — PyTorch, transfer learning (EfficientNet), CNN, IA par self-play (MCTS + ResNet).
Preuves : [Courtisans_Game](https://github.com/floSa/Courtisans_Game) · classification_bubbles · image_detection_pneumonia

**Machine Learning & séries temporelles** — gradient boosting (XGBoost / LightGBM), scikit-learn, NLP supervisé.
Preuves : Prosol (prévision de ventes) · Défi IA 2020 & 2021 (NLP, Kaggle).

**MLOps & reproductibilité** — MLflow, Docker, environnements de services réutilisables.
Preuves : mlflow_tuto · Template-services-docker.

**Architecture & micro-services** — Docker Compose, FastAPI, PostgreSQL, MongoDB, MinIO/S3, services temps réel.
Preuves : classification_bubbles (détection acoustique temps réel) · [MCP_maison](https://github.com/floSa/MCP_maison).

**Collecte de données & scraping** — Selenium, BeautifulSoup, structuration de données web. Compétence éprouvée sur plusieurs projets personnels.

**Annotation & datasets** — outils d'annotation, exports COCO / YOLO / Pascal VOC, NER.
Preuves : Annotation-Images · Annotation-Text-Streamlit.

**Analyse de données & dataviz** — pandas, EDA, sources publiques (INSEE, Eurostat, HMD), applications Streamlit multi-pages.
Preuves : food-habits-analysis · esperance_de_vie_FR.

**Veille & capitalisation technique / dev assisté par IA** — mémoire technique structurée, versionnée, exploitée par un agent IA comme contexte de développement.
Preuves : [DevBrain](https://github.com/floSa/DevBrain).

### Projets phares

**[rag-ingestion-pipeline](https://github.com/floSa/rag-ingestion-pipeline)** — Pipeline d'ingestion PDF/HTML pour assistant RAG : extraction structurée via Docling, graphe de connaissances NebulaGraph, base vectorielle ChromaDB, médias sur MinIO, orchestration Dagster.
`Docling` · `NebulaGraph` · `ChromaDB` · `MinIO` · `Dagster` · `Docker`

**[rag-agent-chat](https://github.com/floSa/rag-agent-chat)** — Agent conversationnel qui consomme ce pipeline. Plutôt que d'injecter des chunks isolés, il exploite le graphe de connaissances pour reconstruire la section complète autour de chaque passage trouvé. Machine à états LangGraph avec sélection des sources par l'utilisateur.
`LangGraph` · `ChromaDB` · `NebulaGraph` · `Ollama` · `FastAPI`

**[DevBrain](https://github.com/floSa/DevBrain)** — Base de connaissance technique versionnée (600+ fiches : services, outils, patterns, concepts, retours d'expérience) couplée à deux skills Claude Code. Au lancement d'un projet, `planifier-projet` interroge le brain et propose un stack sourcé — 2-3 candidats argumentés par brique — au lieu de repartir de zéro. En cours de route, `enrichir-brain` capture en langage naturel ("ajoute Qdrant au brain") chaque nouvel outil ou retour d'expérience, câble les liens et régénère l'index. Chaque projet démarre sur les choix — et les erreurs — déjà faits.
`Claude Code` · `Obsidian` · `Développement assisté par IA` · `Gestion de connaissance`

**[data-analyst-agent](https://github.com/floSa/data-analyst-agent)** — Agent conversationnel sur données, on-premise : à partir d'un fichier (Excel/CSV) ou d'une base Postgres multi-tables, génère la requête (SQL avec jointures, ou DuckDB sur fichier) et répond en langage naturel.
`LangGraph` · `NL→SQL` · `DuckDB` · `PostgreSQL` · `Ollama`

**[Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration)** — Tutoriel d'orchestration multi-agents + MCP sur un fil rouge concret (une usine à la commande) : orchestrateur, sous-agents, outils exposés via MCP.
`Multi-agents` · `MCP` · `Ollama` · `Docker`

**[MCP_maison](https://github.com/floSa/MCP_maison)** — Socle réutilisable et entièrement dockerisé pour construire des agents ReAct s'appuyant sur des serveurs MCP, avec un petit LLM local.
`Agent ReAct` · `MCP` · `FastAPI` · `Ollama` · `Docker`

**[Courtisans_Game](https://github.com/floSa/Courtisans_Game)** — Implémentation du jeu de cartes Courtisans avec une IA inspirée d'AlphaZero (MCTS + ResNet) et une interface pour jouer contre elle.
`PyTorch` · `MCTS` · `ResNet` · `Streamlit`

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

**Deep Learning** — PyTorch, transfer learning (EfficientNet), CNN, self-play AI (MCTS + ResNet).
Evidence: [Courtisans_Game](https://github.com/floSa/Courtisans_Game) · classification_bubbles · image_detection_pneumonia

**Machine Learning & time series** — gradient boosting (XGBoost / LightGBM), scikit-learn, supervised NLP.
Evidence: Prosol (sales forecasting) · Défi IA 2020 & 2021 (NLP, Kaggle).

**MLOps & reproducibility** — MLflow, Docker, reusable service environments.
Evidence: mlflow_tuto · Template-services-docker.

**Architecture & micro-services** — Docker Compose, FastAPI, PostgreSQL, MongoDB, MinIO/S3, real-time services.
Evidence: classification_bubbles (real-time acoustic detection) · [MCP_maison](https://github.com/floSa/MCP_maison).

**Data collection & scraping** — Selenium, BeautifulSoup, structuring web data. Proven across several personal projects.

**Annotation & datasets** — annotation tools, COCO / YOLO / Pascal VOC exports, NER.
Evidence: Annotation-Images · Annotation-Text-Streamlit.

**Data analysis & dataviz** — pandas, EDA, public data sources (INSEE, Eurostat, HMD), multi-page Streamlit apps.
Evidence: food-habits-analysis · esperance_de_vie_FR.

**Technical knowledge management / AI-assisted development** — structured, versioned technical memory used by an AI agent as development context.
Evidence: [DevBrain](https://github.com/floSa/DevBrain).

### Featured projects

**[rag-ingestion-pipeline](https://github.com/floSa/rag-ingestion-pipeline)** — PDF/HTML ingestion pipeline for a RAG assistant: structured extraction with Docling, NebulaGraph knowledge graph, ChromaDB vector store, media on MinIO, Dagster orchestration.
`Docling` · `NebulaGraph` · `ChromaDB` · `MinIO` · `Dagster` · `Docker`

**[rag-agent-chat](https://github.com/floSa/rag-agent-chat)** — Conversational agent consuming that pipeline. Instead of injecting isolated chunks, it uses the knowledge graph to rebuild the full section around each retrieved passage. LangGraph state machine with user-driven source selection.
`LangGraph` · `ChromaDB` · `NebulaGraph` · `Ollama` · `FastAPI`

**[DevBrain](https://github.com/floSa/DevBrain)** — Versioned technical knowledge base (600+ notes: services, tools, patterns, concepts, lessons learned) paired with two custom Claude Code skills. At project kickoff, `planifier-projet` queries the brain and proposes a sourced stack — 2-3 argued candidates per building block — instead of starting from scratch. Along the way, `enrichir-brain` captures new tools or lessons learned in natural language ("add Qdrant to the brain"), wires the links, and regenerates the index. Every project builds on choices — and mistakes — already made.
`Claude Code` · `Obsidian` · `AI-assisted development` · `Knowledge management`

**[data-analyst-agent](https://github.com/floSa/data-analyst-agent)** — On-premise conversational agent over data: from a file (Excel/CSV) or a multi-table Postgres database, it generates the query (SQL with joins, or DuckDB over a file) and answers in natural language.
`LangGraph` · `NL→SQL` · `DuckDB` · `PostgreSQL` · `Ollama`

**[Agents-MCP-Orchestration](https://github.com/floSa/Agents-MCP-Orchestration)** — Multi-agent + MCP orchestration tutorial built around a concrete example (a made-to-order factory): orchestrator, sub-agents, tools exposed through MCP.
`Multi-agents` · `MCP` · `Ollama` · `Docker`

**[MCP_maison](https://github.com/floSa/MCP_maison)** — Reusable, fully dockerised foundation for building ReAct agents backed by MCP servers, with a small local LLM.
`ReAct agent` · `MCP` · `FastAPI` · `Ollama` · `Docker`

**[Courtisans_Game](https://github.com/floSa/Courtisans_Game)** — Implementation of the Courtisans card game with an AlphaZero-inspired AI (MCTS + ResNet) and an interface to play against it.
`PyTorch` · `MCTS` · `ResNet` · `Streamlit`

### Contact

- Email: florian_horellou@laposte.net
- LinkedIn: [florian-horellou](https://www.linkedin.com/in/florian-horellou/)
- GitHub: [floSa](https://github.com/floSa)
