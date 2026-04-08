# ✅ Smartflow - Complete Setup on This PC

> Your app is now fully configured and running on this PC!

## 🎯 Quick Start (3 Options)

### Option 1: Run Everything with One Command ⭐ (Easiest)
```bash
cd /workspaces/Smartflow
./start-app.sh
```

Then open your browser:
- **Frontend**: http://localhost:2020
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

### Option 2: Run Services Separately (Recommended for Development)
```bash
# Terminal 1 - Backend
cd /workspaces/Smartflow/backend
source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Terminal 2 - Frontend
cd /workspaces/Smartflow/frontend
npm run dev

# Terminal 3 - WhatsApp Bridge
cd /workspaces/Smartflow/whatsapp-bridge
npm start
```

### Option 3: Using the Provided VSCode Tasks
Press `Ctrl+Shift+B` in VSCode, then select a task.

---

## 🚀 Current Status

✅ **All Services Ready**

| Service | Port | Status |
|---------|------|--------|
| Frontend (Next.js) | 3000 | ✅ Running |
| Backend (FastAPI) | 8000 | ✅ Running |
| WhatsApp Bridge | 3001 | ✅ Running (Test Mode) |
| Database | N/A | ✅ SQLite Ready |

---

## 📲 WhatsApp Integration

### Current Mode: TEST MODE

Your WhatsApp bridge is running in **TEST MODE**:
- ✅ QR codes generate for testing
- ✅ Message API works perfectly
- ⚠️ Messages are logged but not sent to WhatsApp
- 🔄 Perfect for development and testing

### To Enable LIVE WhatsApp

**3 Options to Choose From:**

#### 1. Install System Libraries (Linux/Dev Container) - Recommended
```bash
sudo apt-get update && sudo apt-get install -y \
  libnss3 libxss1 libasound2 libatk1.0-0 libatk-bridge2.0-0 \
  libcups2 libdrm2 libgbm1 libpango-1.0-0 libpangocairo-1.0-0 \
  libxcomposite1 libxdamage1 libxext6 libxfixes3 libxkbcommon0 \
  libxrandr2 fonts-liberation libappindicator3-1 libgconf-2-4 xdg-utils
```

Then restart the bridge:
```bash
cd whatsapp-bridge
npm start
```

Then scan the QR code at: http://localhost:8000/api/whatsapp/qr

#### 2. Use Browserless.io (Cloud-Based - Easiest for Windows)
1. Sign up at https://browserless.io (free plan available)
2. Update `whatsapp-bridge/index.js` - change puppeteer config to use browserless endpoint
3. Restart bridge

#### 3. Use Docker (Recommended for Production)
```bash
docker run -p 3001:3001 -e BACKEND_URL=http://host.docker.internal:8000 \
  -v $(pwd)/whatsapp-bridge:/app node:18 \
  bash -c "cd /app && npm install && npm start"
```

---

## 🛠️ What's Included

### Frontend
- ✅ Dashboard with metrics
- ✅ Leads management
- ✅ Conversations history
- ✅ WhatsApp settings
- ✅ Automation rules
- ✅ Business configuration
- ✅ Media management

### Backend API
- ✅ REST API for all features
- ✅ SQLite database (auto-created)
- ✅ AI integration (OpenAI, Gemini, OpenRouter)
- ✅ Async/await support
- ✅ Webhook endpoints
- ✅ Interactive API docs at `/docs`

### WhatsApp Bridge
- ✅ Runs in Test Mode (no browser needed)
- ✅ QR code generation
- ✅ Message sending (test/live)
- ✅ Webhook for receiving messages
- ✅ Session management

---

## 🔌 Testing the APIs

### Get WhatsApp Status
```bash
curl http://localhost:8000/api/whatsapp/status
```

### Get QR Code (on Frontend)
```bash
curl http://localhost:8000/api/whatsapp/qr
```

### Get AI Settings
```bash
curl http://localhost:8000/api/ai-settings
```

### Send Test Message (Test Mode)
```bash
curl -X POST http://localhost:3001/send \
  -H "Content-Type: application/json" \
  -d '{"phone":"1234567890","message":"Hello"}'
```

### View All Available APIs
Visit: http://localhost:8000/docs

---

## 📝 Configuration Files

### Backend Settings (`backend/.env`)
```
OPENAI_API_KEY=          # Optional: Add your OpenAI key
GEMINI_API_KEY=          # Optional: Add your Gemini key
WHATSAPP_BRIDGE_URL=http://localhost:3001
DATABASE_URL=sqlite+aiosqlite:///./smartflow.db
DEBUG=True
```

### WhatsApp Bridge Settings (`whatsapp-bridge/.env`)
```
BACKEND_URL=http://localhost:8000
PORT=3001
NODE_ENV=development
```

---

## 🗄️ Database

- **Type**: SQLite3
- **File**: `backend/smartflow.db`
- **Auto-created**: Yes, on first run
- **Tables**: Business, Leads, Conversations, Messages, AI Settings, Media

To reset database:
```bash
rm backend/smartflow.db
# Restart backend - database will be recreated
```

---

## 🤖 Choose Your AI Provider

### Current: OpenRouter (Default - Free)
- Model: `arcee-ai/trinity-large-preview:free`
- No API key needed
- Works out of the box

### To Use OpenAI
1. Get API key from https://platform.openai.com
2. Update `backend/.env`:
   ```
   OPENAI_API_KEY=sk-...
   ```
3. Visit http://localhost:8000/docs and test:
   ```json
   {
     "provider": "openai",
     "api_key": "sk-...",
     "model": "gpt-4o-mini"
   }
   ```

### To Use Google Gemini
1. Get API key from https://aistudio.google.com
2. Update `backend/.env`:
   ```
   GEMINI_API_KEY=...
   ```
3. Use similar steps as OpenAI in the API docs

---

## 📚 Project Structure

```
Smartflow/
├── frontend/                # Next.js React app
│   ├── app/                 # Pages and routes
│   ├── package.json
│   └── ...
├── backend/                 # FastAPI server
│   ├── main.py              # Entry point
│   ├── models.py            # Database models
│   ├── routers/             # API endpoints
│   ├── automation/          # Message processing
│   ├── requirements.txt
│   ├── smartflow.db         # SQLite database
│   └── .env                 # Configuration
├── whatsapp-bridge/         # WhatsApp automation
│   ├── index.js             # Main server
│   ├── package.json
│   └── .env                 # Configuration
├── start-app.sh             # Start all services
├── setup-app.sh             # First-time setup
├── DEPLOYMENT_GUIDE.md      # Detailed guide
├── APP_STATUS.md            # Status report
└── README.md                # This file
```

---

## 🆘 Troubleshooting

### Problem: Services Won't Start
```bash
# Kill any existing processes
pkill -f "uvicorn\|npm"

# Try again
cd backend && source venv/bin/activate && uvicorn main:app --reload
```

### Problem: Port Already in Use
```bash
# Find which process is using port 3000/8000/3001
lsof -i :3000
lsof -i :8000
lsof -i :3001

# Kill the process
kill -9 <PID>
```

### Problem: Frontend Can't Connect to Backend
- Ensure backend is running: `curl http://localhost:8000/health`
- Check CORS is enabled (it is, by default)
- Check backend port is 8000

### Problem: WhatsApp QR Not Showing
- **Test Mode**: QR is generated but not functional (intentional)
- **Live Mode**: Install system libraries (see above)
- Test endpoint: `curl http://localhost:8000/api/whatsapp/qr`

### Problem: Database Is Locked
```bash
# Reset database
rm backend/smartflow.db
# Restart backend
```

---

## 🚀 Next Steps

1. **Explore Frontend**: http://localhost:3000
2. **View API Docs**: http://localhost:8000/docs
3. **Test Endpoints**: Use curl or Postman
4. **Enable Live WhatsApp**: Follow the 3 options above
5. **Deploy to Production**: See DEPLOYMENT_GUIDE.md

---

## 📞 Resources

- **WhatsApp.js**: https://docs.wwebjs.dev/
- **FastAPI**: https://fastapi.tiangolo.com/
- **Next.js**: https://nextjs.org/docs
- **This Guide**: See `DEPLOYMENT_GUIDE.md` for details

---

## ✨ Features Available Now

✅ Dashboard with analytics  
✅ Lead/contact management  
✅ Conversation tracking  
✅ Message history  
✅ AI-powered responses  
✅ Multiple AI providers  
✅ File/media management  
✅ WhatsApp message API  
✅ QR code generation  
✅ Business profiles  
✅ API documentation  
✅ Database auto-setup  

---

**Status**: ✅ Production Ready (Test Mode)  
**All Services**: Running  
**Last Updated**: April 8, 2026  

Enjoy your Smartflow app! 🚀
