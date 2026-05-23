# Project Sentinel: The First-Principles Life Advisor

> "What I cannot create, I do not understand." — Richard Feynman / Andrej Karpathy

**Sentinel** is a minimalist, local "Life-Kernel" built in Zig. It acts as a Chief Systems Officer for your life, managing mental RAM and providing first-principles engineering advice grounded in a curated mindset corpus.

## 1. The Architecture
Sentinel is built to be a **Software 2.0** tool. It treats time, attention, and learning as optimization problems.

*   **The Mindset Engine (Scripts):** A Python-based ingestion system that crawls and curates a local `CORPUS/` of Andrej Karpathy's blogs, transcripts, and tweets.
*   **The Life-Kernel (Zig):** A high-performance, minimalist CLI that manages mental context, scores decision signal, and implements AI-native "Attention" mechanisms to focus your workflow.

## 2. Overall Goals
1.  **Context Management:** Explicitly track and limit mental RAM to maximize deep work.
2.  **Zero-Level Mastery:** Implement AI concepts (Tokenizers, Vector Search, Attention) from scratch in Zig with zero dependencies.
3.  **High-Signal Partnership:** An advisor that challenges strategy using a locally-stored, data-grounded engineering worldview.

## 3. Workflow
1.  **Ingest:** Run `scripts/crawler.py` to populate the `CORPUS/`.
2.  **Build:** Compile the Zig kernel (`zig build`).
3.  **Sync:** Use `sentinel` to audit your learning path and vision.

---

## 4. The Zero-to-Hero Roadmap

### Milestone 0: The Mindset Crawler
*   **Goal:** Populate `CORPUS/` with high-signal data.
*   **Task:** Implement `scripts/crawler.py` to scrape `karpathy.ai` and YouTube transcripts.

### Milestone 1: The Context Kernel
*   **Goal:** Manage mental RAM.
*   **Task:** Implement `load`/`flush` commands in Zig to track focus.

### Milestone 2: The Signal Scorer
*   **Goal:** Audit decisions using Weights/Biases.
*   **Task:** Build a linear scoring function to filter noise from your vision.

### Milestone 3: The Attention Buffer
*   **Goal:** Build a "Focus Engine."
*   **Task:** Implement a minimalist Tokenizer and KVQ (Key-Value-Query) mechanism in Zig.

---

## 5. Engineering Mandates
*   **Zero Dependencies:** Only the Zig `std` library for the kernel.
*   **Explicit Memory:** Total control over RAM allocation.
*   **High-Signal Only:** Minimalism in both code and communication.
