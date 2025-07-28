# Quick Setup Guide for Bosch Graph2RAG

## 1. Choose Your Configuration

### Option A: Azure OpenAI (Cloud)
```bash
cp .env.azure.sample .env.azure
# Edit .env.azure with your Azure credentials
```

### Option B: Ollama (Local)
```bash
cp .env.ollama.sample .env.ollama
# Make sure Ollama is running on localhost:11434
```

## 2. Start the Application

### Docker (Recommended)
```bash
# Azure
docker-compose --env-file .env.azure up -d

# Ollama
docker-compose --env-file .env.ollama up -d
```

### Non-Docker
```bash
# Install
./install_local.sh

# Run with Azure
./start_local_server.sh azure

# Run with Ollama
./start_local_server.sh ollama
```

## 3. Access
- Azure: http://localhost:9622
- Ollama: http://localhost:9621

## 4. Upload Documents
Place files in `inputs/` folder or use the web UI.