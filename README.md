# 🤖 Drax AI Explorer

**Drax AI Explorer** is a Flutter-based mobile app that lets you explore and compare responses from multiple **OpenRouter AI models** in one place.  
You can either submit a single prompt to multiple models simultaneously or interact with an individual model of your choice.

---

## ✨ Features

- 🔹 **Multi-Model Responses** – Enter one prompt and view responses from multiple AI models side by side.  
- 🔹 **Single Model Mode** – Choose a specific model if you want to interact with it individually.  
- 🔹 **Supported Free Models (via OpenRouter)**:
  - `google/gemini-2.0-flash-exp:free`
  - `deepseek/deepseek-r1:free`
  - `meta-llama/llama-3.3-70b-instruct:free`
  - `mistralai/mistral-small-3.2-24b-instruct:free`
  - `qwen/qwen3-coder:free`
  - `openai/gpt-oss-20b:free`
  - `nvidia/llama-3.1-nemotron-ultra-253b-v1:free`
  - `meta-llama/llama-3.2-11b-vision-instruct:free`
  - `meta-llama/llama-3.2-3b-instruct:free`
- 🖼️ **Clean UI** – Chat-style interface with Material Design cards.  
- ⚡ **Fast Parallel Requests** – Multi-model queries are executed in parallel using `Future.wait`.

---

## 🛠️ Tech Stack

- **Flutter (Dart)** – Cross-platform mobile framework  
- **OpenRouter API** – Access to multiple free AI models  
- **HTTP package** – For making REST API calls  
- **Material Design** – For a clean and simple interface  

---

## 🚀 Getting Started

### 1. Clone Repository
```bash
git clone https://github.com/asad-lubnan/drax_ai.git
cd drax_ai
