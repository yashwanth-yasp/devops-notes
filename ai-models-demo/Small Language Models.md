---
date: 2025-09-10
Speaker: Richard Joseph
tags:
  - ust
  - ai
  - llm
---
# Small Language Models (SLMs) – Presentation Notes

## Introduction
- **Definition**: Compact versions of large language models (LLMs) built for **resource-limited environments** (smartphones, embedded systems, low-power devices).
- **Size Range**: ~1M–10B parameters (vs. hundreds of billions in LLMs).
- **Core Capabilities**: Text generation, summarization, translation, Q&A.
- **Note**: "Small" is relative — some call them "Small Large Language Models."

---

## How They’re Made Smaller
1. **Knowledge Distillation** – Train a smaller *student* model from a larger *teacher* model.
2. **Pruning** – Remove redundant or low-importance parameters.
3. **Quantization** – Lower numerical precision (e.g., float → int) to reduce size and speed up inference.

---

## Examples
| Model             | Parameters | Developer       | Key Feature                 |
| ----------------- | ---------- | --------------- | --------------------------- |
| Llama3.2-1B       | 1B         | Meta            | Optimized for edge devices  |
| Qwen2.5-1.5B      | 1.5B       | Alibaba         | Multilingual                |
| DeepSeek-R1-1.5B  | 1.5B       | DeepSeek        | Reasoning-focused           |
| SmolLM2-1.7B      | 1.7B       | HuggingFaceTB   | Specialized datasets        |
| Phi-3.5-Mini-3.8B | 3.8B       | Microsoft       | Reasoning & code generation |
| Gemma3-4B         | 4B         | Google DeepMind | Multilingual & multimodal   |

---

## Benefits
- Runs on laptops, mobiles, and edge devices.
- Lower energy use and operational costs.
- Faster inference for real-time applications.
- Enables private, offline AI.
- Easy to fine-tune for niche domains.

---

## Limitations
- Narrower scope; weaker generalization.
- Higher bias risk from smaller datasets.
- Less capable with complex reasoning.
- More prone to errors in ambiguous cases.

---

## Applications
- Chatbots & virtual assistants.
- Code generation (e.g., Phi-3.5 Mini).
- On-device translation.
- Summarization & content creation.
- Healthcare tools (symptom checkers, research).
- IoT & edge AI for smart devices.
- Education (tutoring, quizzes, feedback).

---

## Running SLMs on Devices

**Mobile – PocketPal AI**
- Offline AI with model swapping (Phi, Gemma, Qwen, etc.).
- Automatic memory management.
- Adjustable inference settings.
- Performance metrics (tokens/sec, ms/token).

**PC – Ollama**
- Run models locally (e.g., Llama3.2-1B).
- Optimized for consumer GPUs.
- Integrates into custom workflows.

---

## Fine-Tuning
- **Purpose**: Adapt models for domain-specific tasks.
- **Methods**:
  - Full fine-tuning – retrain all parameters.
  - LoRA (Low-Rank Adaptation) – fine-tune select layers.
  - Adapters & prompt tuning – add layers or optimize prompts.

---

## Conclusion
- SLMs deliver faster, cheaper, and more accessible AI.
- Ideal for on-device, private, and real-time use.
- Tools like PocketPal and Ollama, plus fine-tuning, make them highly adaptable.
- They bridge the gap between powerful AI and practical deployment.