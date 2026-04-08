#!/bin/bash
# Start Smartflow App - All Services

set -e

echo "================================"
echo "🚀 SMARTFLOW APP - STARTUP"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to start service in background
start_service() {
    local name=$1
    local cmd=$2
    local port=$3
    
    echo -e "${BLUE}▶${NC} Starting $name..."
    eval "$cmd" &
    sleep 2
    
    # Check if port is open
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo -e "${GREEN}✓${NC} $name running on port $port"
    else
        echo -e "${YELLOW}⚠${NC} $name may not have started (port $port)"
    fi
}

# Kill any existing processes on ports
cleanup() {
    echo ""
    echo -e "${YELLOW}Cleaning up any existing processes...${NC}"
    lsof -ti:8000 | xargs kill -9 2>/dev/null || true
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    lsof -ti:3001 | xargs kill -9 2>/dev/null || true
    sleep 1
}

# Start services
cleanup

echo ""
echo "Starting services..."
echo ""

# Backend
start_service "Backend (FastAPI)" \
    "cd $(pwd)/backend && source venv/bin/activate && uvicorn main:app --reload --host 0.0.0.0 --port 8000" \
    8000

# Frontend
start_service "Frontend (Next.js)" \
    "cd $(pwd)/frontend && npm run dev -- -p 2020" \
    2020

# WhatsApp Bridge
start_service "WhatsApp Bridge" \
    "cd $(pwd)/whatsapp-bridge && npm start" \
    3001

echo ""
echo "================================"
echo -e "${GREEN}✅ ALL SERVICES STARTED${NC}"
echo "================================"
echo ""
echo "📱 Frontend:    ${BLUE}http://localhost:3000${NC}"
echo "🔧 Backend:     ${BLUE}http://localhost:8000${NC}"
echo "📖 API Docs:    ${BLUE}http://localhost:8000/docs${NC}"
echo "🤖 WhatsApp:    ${BLUE}http://localhost:3001${NC}"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Keep script running
wait
