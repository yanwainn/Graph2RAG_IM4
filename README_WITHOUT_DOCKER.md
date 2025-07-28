# 🚀 Running Bosch Graph2RAG Without Docker

This guide shows how to run LightRAG (branded as Bosch Graph2RAG) directly on your system without Docker.

## 📋 Prerequisites

### 1. Python Environment
- Python 3.10 or higher (Required! Python 3.9 won't work)
- pip package manager

### 2. Check Python Version
```bash
python --version
# or
python3 --version
```

If you have Python 3.9, you need to upgrade. On macOS:
```bash
# Install Python 3.10+ using Homebrew
brew install python@3.11

# Or use pyenv
pyenv install 3.11.0
pyenv local 3.11.0
```

## 🛠️ Installation Steps

### Step 1: Create Virtual Environment
```bash
# Navigate to LightRAG directory
cd /Users/waiyan/Downloads/GraphRAG/LightRAG

# Create virtual environment with Python 3.11
python3.11 -m venv venv

# Activate virtual environment
source venv/bin/activate  # On macOS/Linux
# or
venv\Scripts\activate  # On Windows
```

### Step 2: Install LightRAG from Source
```bash
# Install in editable mode with API support
pip install -e ".[api]"

# Install additional dependencies
pip install nano-vectordb networkx
pip install openai ollama tiktoken
pip install pypdf2 python-docx python-pptx openpyxl
```

### Step 3: Set Environment Variables
```bash
# For Azure configuration
export OPENAI_API_KEY="your-key-here"
export AZURE_OPENAI_API_KEY="50uJP6x0w8glx4EAK1UOD5yMKeuwSKa8NwIr0O22P0K7FKsSCVpCJQQJ99BGACHYHv6XJ3w3AAAAACOGa9C0"
export AZURE_OPENAI_ENDPOINT="https://onem-mdie0igu-eastus2.cognitiveservices.azure.com/"

# For embedding endpoint
export AZURE_EMBEDDING_API_KEY="3wWYJT2YDT7krlIFpkLZwKhJYyCo9PXSEAcrtTjUcPEzXpkdHcdeJQQJ99BGACHYHv6XJ3w3AAABACOG2rCc"
export AZURE_EMBEDDING_ENDPOINT="https://clonewriter23.openai.azure.com/"

# Load from .env file
source .env.azure  # For Azure
# or
source .env.ollama  # For Ollama
```

## 🚀 Running the Server

### Method 1: Direct Server Launch
```bash
# Activate virtual environment first
source venv/bin/activate

# Run the server
python -m lightrag.api.lightrag_server
```

### Method 2: Custom Launch Script
Create `run_server.py`:
```python
#!/usr/bin/env python3
import os
import sys
from lightrag.api.lightrag_server import main

# Set branding
os.environ['WEBUI_TITLE'] = 'Bosch Graph2RAG'
os.environ['WEBUI_DESCRIPTION'] = 'Bosch Knowledge Graph RAG System'

# Configure paths
os.environ['WORKING_DIR'] = './rag_storage'
os.environ['INPUT_DIR'] = './inputs'

# Run server
if __name__ == "__main__":
    main()
```

Then run:
```bash
python run_server.py
```

### Method 3: Using Environment File
```bash
# Load environment variables
set -a  # Enable auto-export
source .env.azure
set +a  # Disable auto-export

# Run server
python -m lightrag.api.lightrag_server
```

## 🎨 Applying Bosch Branding (Without Docker)

### Option 1: Environment Variables
Add to your `.env` or export:
```bash
export WEBUI_TITLE="Bosch Graph2RAG"
export WEBUI_DESCRIPTION="Bosch Knowledge Graph RAG System"
export APP_NAME="Bosch Graph2RAG"
export BRAND_NAME="Bosch Graph2RAG"
```

### Option 2: Modify Source Files
```bash
# Find and replace in source
find lightrag/ -type f -name "*.py" -exec sed -i '' 's/LightRAG/Bosch Graph2RAG/g' {} +
```

### Option 3: Custom Wrapper Script
Create `bosch_graph2rag_server.py`:
```python
import os
import sys
from pathlib import Path

# Monkey-patch branding before imports
os.environ['WEBUI_TITLE'] = 'Bosch Graph2RAG'
os.environ['WEBUI_DESCRIPTION'] = 'Bosch Knowledge Graph RAG System'

# Import and modify constants
import lightrag.api.lightrag_server as server

# Override any hardcoded values
if hasattr(server, 'APP_NAME'):
    server.APP_NAME = 'Bosch Graph2RAG'

# Run the server
if __name__ == "__main__":
    server.main()
```

## 📁 Directory Structure
```
LightRAG/
├── venv/                    # Python virtual environment
├── lightrag/                # Source code
├── rag_storage/            # Data storage
├── inputs/                 # Input documents
├── .env.azure              # Azure configuration
├── .env.ollama             # Ollama configuration
├── run_server.py           # Custom launch script
└── bosch_graph2rag_server.py  # Branded wrapper
```

## 🔧 Configuration Files

### Create `.env.local` for local development:
```bash
# Server Configuration
HOST=0.0.0.0
PORT=9621
WEBUI_TITLE='Bosch Graph2RAG'
WEBUI_DESCRIPTION='Bosch Knowledge Graph RAG System'

# Azure Configuration
LLM_BINDING=azure_openai
LLM_MODEL=gpt-4
AZURE_OPENAI_API_KEY=50uJP6x0w8glx4EAK1UOD5yMKeuwSKa8NwIr0O22P0K7FKsSCVpCJQQJ99BGACHYHv6XJ3w3AAAAACOGa9C0
AZURE_OPENAI_ENDPOINT=https://onem-mdie0igu-eastus2.cognitiveservices.azure.com/
AZURE_OPENAI_DEPLOYMENT=gpt-4.1
AZURE_OPENAI_API_VERSION=2024-12-01-preview

# Embedding Configuration
EMBEDDING_BINDING=azure_openai
EMBEDDING_MODEL=text-embedding-3-large
EMBEDDING_DIM=3072
AZURE_EMBEDDING_API_KEY=3wWYJT2YDT7krlIFpkLZwKhJYyCo9PXSEAcrtTjUcPEzXpkdHcdeJQQJ99BGACHYHv6XJ3w3AAABACOG2rCc
AZURE_EMBEDDING_ENDPOINT=https://clonewriter23.openai.azure.com/
AZURE_EMBEDDING_DEPLOYMENT=text-embedding-3-large

# Storage
WORKING_DIR=./rag_storage
INPUT_DIR=./inputs
```

## 🚀 Quick Start Commands

```bash
# 1. Setup environment
cd /Users/waiyan/Downloads/GraphRAG/LightRAG
python3.11 -m venv venv
source venv/bin/activate

# 2. Install dependencies
pip install -e ".[api]"

# 3. Load configuration
source .env.local

# 4. Run server
python -m lightrag.api.lightrag_server

# Server will be available at http://localhost:9621
```

## 🐛 Troubleshooting

### Python Version Issues
```bash
# Check Python version
python --version

# If wrong version, use explicit path
/usr/local/bin/python3.11 -m venv venv
```

### Missing Dependencies
```bash
# Install all dependencies
pip install -r requirements.txt
pip install ".[api]"
```

### Port Already in Use
```bash
# Change port
export PORT=9622
python -m lightrag.api.lightrag_server
```

### Module Not Found
```bash
# Ensure you're in the right directory
cd /Users/waiyan/Downloads/GraphRAG/LightRAG

# Reinstall in editable mode
pip install -e .
```

## 🎯 Running as a Service

### macOS (launchd)
Create `~/Library/LaunchAgents/com.bosch.graph2rag.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.bosch.graph2rag</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/waiyan/Downloads/GraphRAG/LightRAG/venv/bin/python</string>
        <string>-m</string>
        <string>lightrag.api.lightrag_server</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/waiyan/Downloads/GraphRAG/LightRAG</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>WEBUI_TITLE</key>
        <string>Bosch Graph2RAG</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

Then:
```bash
launchctl load ~/Library/LaunchAgents/com.bosch.graph2rag.plist
```

### Linux (systemd)
Create `/etc/systemd/system/bosch-graph2rag.service`:
```ini
[Unit]
Description=Bosch Graph2RAG Server
After=network.target

[Service]
Type=simple
User=youruser
WorkingDirectory=/path/to/LightRAG
Environment="PATH=/path/to/LightRAG/venv/bin"
Environment="WEBUI_TITLE=Bosch Graph2RAG"
ExecStart=/path/to/LightRAG/venv/bin/python -m lightrag.api.lightrag_server
Restart=always

[Install]
WantedBy=multi-user.target
```

## 📝 Summary

Running without Docker gives you:
- ✅ Direct control over the Python environment
- ✅ Easier debugging and development
- ✅ No Docker overhead
- ✅ Simple branding through environment variables
- ❌ Manual dependency management
- ❌ Platform-specific setup

Choose Docker for production, native for development!