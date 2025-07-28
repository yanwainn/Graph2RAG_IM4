#!/usr/bin/env python3
"""
Bosch Graph2RAG Server Launcher
Run LightRAG with Bosch branding without Docker
"""

import os
import sys
import argparse
from pathlib import Path

def setup_environment(config='azure'):
    """Set up environment variables based on configuration"""
    
    # Set Bosch branding
    os.environ['WEBUI_TITLE'] = 'Bosch Graph2RAG'
    os.environ['WEBUI_DESCRIPTION'] = 'Bosch Knowledge Graph RAG System'
    os.environ['APP_NAME'] = 'Bosch Graph2RAG'
    os.environ['BRAND_NAME'] = 'Bosch Graph2RAG'
    
    # Load configuration
    env_file = f'.env.{config}'
    if Path(env_file).exists():
        print(f"📋 Loading configuration from {env_file}")
        with open(env_file, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    # Remove quotes if present
                    value = value.strip().strip('"').strip("'")
                    os.environ[key] = value
    
    # Set default directories
    os.environ.setdefault('WORKING_DIR', './rag_storage')
    os.environ.setdefault('INPUT_DIR', './inputs')
    
    # Create directories if they don't exist
    Path(os.environ['WORKING_DIR']).mkdir(exist_ok=True)
    Path(os.environ['INPUT_DIR']).mkdir(exist_ok=True)

def main():
    parser = argparse.ArgumentParser(description='Bosch Graph2RAG Server')
    parser.add_argument('--config', choices=['azure', 'ollama'], default='azure',
                        help='Configuration to use (default: azure)')
    parser.add_argument('--port', type=int, help='Override port number')
    parser.add_argument('--host', default='0.0.0.0', help='Host to bind to')
    
    args = parser.parse_args()
    
    print("🚀 Bosch Graph2RAG Server Launcher")
    print("==================================")
    
    # Setup environment
    setup_environment(args.config)
    
    # Override port if specified
    if args.port:
        os.environ['PORT'] = str(args.port)
    
    # Display configuration
    print(f"\n📊 Configuration:")
    print(f"   - Config: {args.config}")
    print(f"   - Port: {os.environ.get('PORT', '9621')}")
    print(f"   - LLM: {os.environ.get('LLM_MODEL', 'default')}")
    print(f"   - Working Dir: {os.environ.get('WORKING_DIR')}")
    
    # Import and run the server
    try:
        print(f"\n🌐 Starting server at http://localhost:{os.environ.get('PORT', '9621')}")
        print("   Press Ctrl+C to stop\n")
        
        # Import here to ensure environment is set first
        from lightrag.api import lightrag_server
        
        # Run the server
        import uvicorn
        uvicorn.run(
            "lightrag.api.lightrag_server:app",
            host=args.host,
            port=int(os.environ.get('PORT', '9621')),
            reload=False
        )
        
    except ImportError as e:
        print(f"\n❌ Error: {e}")
        print("\n📦 Please install LightRAG first:")
        print("   pip install -e '.[api]'")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\n\n👋 Server stopped")
        sys.exit(0)

if __name__ == "__main__":
    main()