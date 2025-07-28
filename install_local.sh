#!/bin/bash

# Bosch Graph2RAG Local Installation Script

echo "🔧 Bosch Graph2RAG Local Installation"
echo "====================================="

# Check Python version
PYTHON_CMD=""
for cmd in python3.11 python3.10 python3.12 python3; do
    if command -v $cmd &> /dev/null; then
        VERSION=$($cmd -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        if [ "$(echo "$VERSION >= 3.10" | bc)" -eq 1 ]; then
            PYTHON_CMD=$cmd
            break
        fi
    fi
done

if [ -z "$PYTHON_CMD" ]; then
    echo "❌ Error: Python 3.10 or higher is required"
    echo ""
    echo "To install Python 3.11 on macOS:"
    echo "  brew install python@3.11"
    echo ""
    echo "Or download from: https://www.python.org/downloads/"
    exit 1
fi

echo "✅ Found Python: $PYTHON_CMD (version $VERSION)"

# Create virtual environment
echo ""
echo "📦 Creating virtual environment..."
$PYTHON_CMD -m venv venv

# Activate virtual environment
echo "🐍 Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo ""
echo "📦 Upgrading pip..."
pip install --upgrade pip

# Install LightRAG
echo ""
echo "📦 Installing LightRAG and dependencies..."
pip install -e ".[api]"

# Install additional dependencies
echo ""
echo "📦 Installing additional dependencies..."
pip install nano-vectordb networkx
pip install openai ollama tiktoken
pip install pypdf2 python-docx python-pptx openpyxl
pip install textract  # For additional file format support

# Create necessary directories
echo ""
echo "📁 Creating directories..."
mkdir -p rag_storage inputs data/rag_storage data/inputs

# Create a simple test script
cat > test_installation.py << 'EOF'
#!/usr/bin/env python3
import sys
try:
    import lightrag
    print("✅ LightRAG imported successfully")
    from lightrag.api import lightrag_server
    print("✅ API server module available")
    print("\n🎉 Installation successful!")
    print("\nTo start the server, run:")
    print("  ./bosch_server.py")
    print("  # or")
    print("  ./start_local_server.sh")
except ImportError as e:
    print(f"❌ Import error: {e}")
    sys.exit(1)
EOF

chmod +x test_installation.py

# Test installation
echo ""
echo "🧪 Testing installation..."
python test_installation.py

# Create quick start guide
cat > QUICK_START.txt << 'EOF'
🚀 BOSCH GRAPH2RAG QUICK START
==============================

1. Activate virtual environment:
   source venv/bin/activate

2. Start with Azure configuration:
   ./bosch_server.py --config azure
   # Access at: http://localhost:9622

3. Start with Ollama configuration:
   ./bosch_server.py --config ollama
   # Access at: http://localhost:9621

4. Custom port:
   ./bosch_server.py --port 8080

5. Using shell script:
   ./start_local_server.sh azure
   # or
   ./start_local_server.sh ollama

6. Direct Python module:
   python -m lightrag.api.lightrag_server

Remember to:
- Have Ollama running if using Ollama config
- Set up your Azure credentials in .env.azure
- Clear browser cache to see branding changes

EOF

echo ""
echo "📄 Created QUICK_START.txt for reference"
echo ""
echo "✅ Installation complete!"
echo ""
echo "🚀 To start the server now, run:"
echo "   source venv/bin/activate"
echo "   ./bosch_server.py --config azure"