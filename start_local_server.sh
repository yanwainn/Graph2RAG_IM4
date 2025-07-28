#!/bin/bash

# Bosch Graph2RAG Local Server Launcher (Without Docker)
# This script runs LightRAG directly on your system

echo "🚀 Starting Bosch Graph2RAG (Local Installation)"
echo "=============================================="

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
REQUIRED_VERSION="3.10"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "❌ Error: Python $REQUIRED_VERSION or higher is required (found $PYTHON_VERSION)"
    echo "Please install Python 3.10+ first"
    exit 1
fi

# Configuration selection
CONFIG=${1:-azure}
echo "📋 Using configuration: $CONFIG"

# Set working directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "🔧 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🐍 Activating virtual environment..."
source venv/bin/activate

# Check if LightRAG is installed
if ! python -c "import lightrag" 2>/dev/null; then
    echo "📦 Installing LightRAG..."
    pip install -e ".[api]"
    pip install nano-vectordb networkx
    pip install openai ollama tiktoken
    pip install pypdf2 python-docx python-pptx openpyxl
fi

# Load configuration
case $CONFIG in
    azure)
        echo "☁️  Loading Azure configuration..."
        source .env.azure
        export PORT=9622
        ;;
    ollama)
        echo "🦙 Loading Ollama configuration..."
        source .env.ollama
        export PORT=9621
        ;;
    *)
        echo "❌ Invalid configuration: $CONFIG"
        echo "Usage: ./start_local_server.sh [azure|ollama]"
        exit 1
        ;;
esac

# Override with Bosch branding
export WEBUI_TITLE="Bosch Graph2RAG"
export WEBUI_DESCRIPTION="Bosch Knowledge Graph RAG System"
export APP_NAME="Bosch Graph2RAG"
export BRAND_NAME="Bosch Graph2RAG"

# Create necessary directories
mkdir -p rag_storage inputs

# Display configuration
echo ""
echo "📊 Configuration:"
echo "   - Python: $(python --version)"
echo "   - Port: $PORT"
echo "   - Working Dir: $WORKING_DIR"
echo "   - LLM: $LLM_MODEL"
echo ""
echo "🌐 Starting server at http://localhost:$PORT"
echo "   Press Ctrl+C to stop"
echo ""

# Run the server
python -m lightrag.api.lightrag_server