#!/bin/bash
# Initialize Smartflow App for First Time

set -e

echo "================================"
echo "⚙️  SMARTFLOW SETUP"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}Setting up Smartflow App...${NC}"
echo ""

# 1. Backend Setup
echo -e "${BLUE}▶${NC} Backend Setup..."
if [ ! -d "$REPO_ROOT/backend/venv" ]; then
    cd "$REPO_ROOT/backend"
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    echo -e "${GREEN}✓${NC} Backend dependencies installed"
else
    echo -e "${GREEN}✓${NC} Backend venv already exists"
fi

# 2. Frontend Setup
echo ""
echo -e "${BLUE}▶${NC} Frontend Setup..."
if [ ! -d "$REPO_ROOT/frontend/node_modules" ]; then
    cd "$REPO_ROOT/frontend"
    npm install
    echo -e "${GREEN}✓${NC} Frontend dependencies installed"
else
    echo -e "${GREEN}✓${NC} Frontend modules already exist"
fi

# 3. WhatsApp Bridge Setup
echo ""
echo -e "${BLUE}▶${NC} WhatsApp Bridge Setup..."
if [ ! -d "$REPO_ROOT/whatsapp-bridge/node_modules" ]; then
    cd "$REPO_ROOT/whatsapp-bridge"
    npm install
    npm install --no-save puppeteer-extra puppeteer-extra-plugin-stealth
    echo -e "${GREEN}✓${NC} WhatsApp Bridge dependencies installed"
else
    echo -e "${GREEN}✓${NC} WhatsApp Bridge modules already exist"
fi

# 4. Create .env files if not exist
echo ""
echo -e "${BLUE}▶${NC} Configuration Files..."

if [ ! -f "$REPO_ROOT/backend/.env" ]; then
    cat > "$REPO_ROOT/backend/.env" << 'EOF'
# API Keys for AI Providers
OPENAI_API_KEY=
GEMINI_API_KEY=
OPENROUTER_API_KEY=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

# WhatsApp Bridge
WHATSAPP_BRIDGE_URL=http://localhost:3001

# Database
DATABASE_URL=sqlite+aiosqlite:///./smartflow.db

# Backend
DEBUG=True
FRONTEND_URL=http://localhost:3000
EOF
    echo -e "${GREEN}✓${NC} Created backend/.env"
else
    echo -e "${GREEN}✓${NC} backend/.env already exists"
fi

if [ ! -f "$REPO_ROOT/whatsapp-bridge/.env" ]; then
    cat > "$REPO_ROOT/whatsapp-bridge/.env" << 'EOF'
BACKEND_URL=http://localhost:8000
PORT=3001
NODE_ENV=development
EOF
    echo -e "${GREEN}✓${NC} Created whatsapp-bridge/.env"
else
    echo -e "${GREEN}✓${NC} whatsapp-bridge/.env already exists"
fi

echo ""
echo "================================"
echo -e "${GREEN}✅ SETUP COMPLETE!${NC}"
echo "================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Start all services:"
echo -e "   ${CYAN}./start-app.sh${NC}"
echo ""
echo "2. Or start services individually:"
echo -e "   Terminal 1: ${CYAN}cd backend && source venv/bin/activate && uvicorn main:app --reload${NC}"
echo -e "   Terminal 2: ${CYAN}cd frontend && npm run dev${NC}"
echo -e "   Terminal 3: ${CYAN}cd whatsapp-bridge && npm start${NC}"
echo ""
echo "3. Access the app:"
echo -e "   ${CYAN}Frontend:    http://localhost:3000${NC}"
echo -e "   ${CYAN}Backend:     http://localhost:8000${NC}"
echo -e "   ${CYAN}API Docs:    http://localhost:8000/docs${NC}"
echo ""
echo "For more info, see DEPLOYMENT_GUIDE.md"
echo ""
