# Bosch Graph2RAG

A powerful knowledge graph RAG system that combines traditional RAG approaches with graph-based knowledge representation.

## 🚀 Quick Start

### Prerequisites
- Python 3.10+ (for non-Docker installation)
- Docker & Docker Compose (for Docker installation)
- Azure OpenAI or Ollama for LLM/Embeddings

### Configuration

1. Copy `.env.sample` to `.env`:
```bash
cp .env.sample .env
```

2. Edit `.env` and add your API keys:
   - For **Azure OpenAI**: Update `LLM_BINDING_HOST`, `LLM_BINDING_API_KEY`, `EMBEDDING_BINDING_HOST`, `EMBEDDING_BINDING_API_KEY`
   - For **Ollama** (local): Ensure Ollama is running on `http://localhost:11434`

## 🐳 Docker Installation (Recommended)

### Using Pre-configured Environments

**Azure OpenAI:**
```bash
docker-compose --env-file .env.azure up -d
```
Access at: http://localhost:9622

**Ollama (Local):**
```bash
docker-compose --env-file .env.ollama up -d
```
Access at: http://localhost:9621

### Using Custom Configuration
```bash
docker-compose up -d
```

## 💻 Non-Docker Installation

### Automatic Installation
```bash
./install_local.sh
```

### Manual Installation
```bash
# Create virtual environment
python3.10 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -e ".[api]"

# Start server
python -m lightrag.api.lightrag_server
```

### Start Server with Configuration

**Azure:**
```bash
./start_local_server.sh azure
```

**Ollama:**
```bash
./start_local_server.sh ollama
```

## 📁 Project Structure
```
LightRAG/
├── .env.sample          # Configuration template
├── .env.azure           # Azure configuration (create from .env.sample)
├── .env.ollama          # Ollama configuration (create from .env.sample)
├── inputs/              # Document upload directory
├── rag_storage/         # Knowledge graph storage
├── docker-compose.yml   # Docker configuration
└── README.md           # This file
```

## 🔧 Environment Variables

Key variables to configure in `.env`:

| Variable | Description | Example |
|----------|-------------|---------|
| `LLM_BINDING` | LLM provider | `azure_openai` or `ollama` |
| `LLM_MODEL` | Model name | `gpt-4` or `qwen2:latest` |
| `LLM_BINDING_HOST` | LLM endpoint | Azure endpoint or `http://localhost:11434` |
| `LLM_BINDING_API_KEY` | API key | Your Azure API key (empty for Ollama) |
| `EMBEDDING_MODEL` | Embedding model | `text-embedding-3-large` or `nomic-embed-text` |
| `WEBUI_TITLE` | UI branding | `Bosch Graph2RAG` |

## 📚 Usage

1. **Upload Documents**: Place files in the `inputs/` directory or use the web UI
2. **Process Documents**: The system automatically extracts entities and relationships
3. **Query**: Use natural language queries to retrieve information
4. **Visualize**: View the knowledge graph in the web UI

## 🛠️ Troubleshooting

### Port Already in Use
```bash
# Change port in .env
PORT=9623
```

### Azure Connection Issues
- Verify API keys and endpoints
- Check deployment names match your Azure configuration
- Ensure API versions are correct

### Ollama Connection Issues
```bash
# Start Ollama
ollama serve

# Pull required models
ollama pull qwen2:latest
ollama pull nomic-embed-text
```

## 📝 Notes

- Document processing may take time depending on size and complexity
- Azure endpoints for LLM and embeddings can be different
- Clear browser cache if branding doesn't update
- Check `lightrag.log` for detailed error messages