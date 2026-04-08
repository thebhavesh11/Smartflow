# Smartflow App - Complete Setup & Deployment Guide

## ✅ Current Status - All Services Running

| Component | Status | Port | Access |
|-----------|--------|------|--------|
| **Frontend (Next.js)** | ✅ Running | 3000 | http://localhost:3000 |
| **Backend (FastAPI)** | ✅ Running | 8000 | http://localhost:8000 |
| **WhatsApp Bridge** | ✅ Running (Test Mode) | 3001 | http://localhost:3001 |
| **API Documentation** | ✅ Available | 8000 | http://localhost:8000/docs |

---

## 🚀 Quick Start (What's Already Running)

```bash
# Backend API
http://localhost:8000

# Frontend Dashboard
http://localhost:3000

# Test WhatsApp Bridge QR
curl http://localhost:8000/api/whatsapp/qr

# Test Send Message (Test Mode)
curl -X POST http://localhost:3001/send \
  -H "Content-Type: application/json" \
  -d '{"phone":"1234567890","message":"Hello"}'
```

---

## 🔧 System Configuration

### Files Created/Updated

```
backend/.env                    ✅ Created
whatsapp-bridge/.env           ✅ Created
whatsapp-bridge/index.js       ✅ Updated (Test Mode Support)
APP_STATUS.md                  ✅ Created
DEPLOYMENT_GUIDE.md            ✅ This file
```

### Current Environment Variables

#### Backend (`backend/.env`)
```
OPENAI_API_KEY=
GEMINI_API_KEY=
OPENROUTER_API_KEY=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
WHATSAPP_BRIDGE_URL=http://localhost:3001
DATABASE_URL=sqlite+aiosqlite:///./smartflow.db
DEBUG=True
```

#### WhatsApp Bridge (`whatsapp-bridge/.env`)
```
BACKEND_URL=http://localhost:8000
PORT=3001
NODE_ENV=development
```

---

## 📱 WhatsApp Integration

### Current Mode: TEST MODE ⚠️

The WhatsApp bridge is running in **TEST MODE** because system libraries for Chromium are missing.

In TEST MODE:
- ✅ API endpoints are fully functional
- ✅ QR codes are generated for testing
- ✅ Messages are logged but not actually sent
- ✅ Perfect for frontend/backend development
- ❌ Messages won't actually reach WhatsApp

```json
{
  "success": true,
  "mode": "TEST",
  "message": "Message logged (test mode - not actually sent)"
}
```

### To Enable LIVE MODE (Real WhatsApp)

You have THREE options:

#### Option 1: Install System Libraries (Recommended for Linux/Dev Containers)

```bash
sudo apt-get update && sudo apt-get install -y \
  libnss3 \
  libxss1 \
  libasound2 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libgbm1 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libxcomposite1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxkbcommon0 \
  libxrandr2 \
  fonts-liberation \
  libappindicator3-1 \
  libgconf-2-4 \
  xdg-utils

# Restart bridge after installing
cd whatsapp-bridge && npm start
```

Then scan the QR code in your browser:
```
http://localhost:3000/whatsapp  (or via API at http://localhost:8000/api/whatsapp/qr)
```

#### Option 2: Use Browserless.io (Cloud-Based - No Dependencies)

Modify `whatsapp-bridge/index.js` to use browserless:

```javascript
// Replace the puppeteer config with:
puppeteer: {
    browserWSEndpoint: 'wss://chrome.browserless.io?token=YOUR_TOKEN',
}
```

Get free token at: https://browserless.io

#### Option 3: Use Docker (Recommended for Production)

```bash
docker run -p 3001:3001 -e "BACKEND_URL=http://host.docker.internal:8000" \
  -v $(pwd)/whatsapp-bridge:/app \
  node:18 bash -c "cd /app && npm install && npm start"
```

---

## 📦 All Dependencies Installed

### Backend
```
✅ fastapi              - Web framework
✅ uvicorn             - ASGI server
✅ sqlalchemy          - ORM (async)
✅ aiosqlite           - Async SQLite
✅ pydantic            - Data validation
✅ python-dotenv       - Environment variables
✅ httpx               - Async HTTP client
✅ openai              - OpenAI API
✅ google-generativeai - Gemini API
✅ python-multipart    - File uploads
```

### Frontend
```
✅ next                - React framework
✅ react               - UI library
✅ react-dom           - React DOM
```

### WhatsApp Bridge
```
✅ whatsapp-web.js          - WhatsApp Web automation
✅ puppeteer                - Browser automation
✅ puppeteer-extra          - Puppeteer plugins
✅ puppeteer-extra-plugin-stealth - Anti-detection
✅ express                  - Web server
✅ axios                    - HTTP client
✅ qrcode                   - QR code generation
✅ cors                     - CORS middleware
```

---

## 🗄️ Database

### SQLite Database
- **File**: `backend/smartflow.db`
- **Type**: SQLite with async support (aiosqlite)
- **Auto-created**: Yes (on first run)

### Tables Structure

```sql
-- Businesses
CREATE TABLE business (
  id INTEGER PRIMARY KEY,
  name VARCHAR,
  description VARCHAR,
  ...
)

-- Leads (WhatsApp contacts)
CREATE TABLE lead (
  id INTEGER PRIMARY KEY,
  phone_number VARCHAR UNIQUE,
  name VARCHAR,
  business_id INTEGER,
  ...
)

-- Conversations
CREATE TABLE conversation (
  id INTEGER PRIMARY KEY,
  lead_id INTEGER,
  business_id INTEGER,
  ...
)

-- Messages
CREATE TABLE message (
  id INTEGER PRIMARY KEY,
  conversation_id INTEGER,
  sender_type VARCHAR (customer|bot),
  message_text VARCHAR,
  created_at TIMESTAMP,
  ...
)

-- AI Settings
CREATE TABLE aisetting (
  id INTEGER PRIMARY KEY,
  business_id INTEGER,
  provider VARCHAR (openai|gemini|openrouter),
  api_key VARCHAR,
  model VARCHAR,
  temperature FLOAT,
  max_tokens INTEGER,
  system_prompt TEXT,
  ...
)

-- Business Media Files
CREATE TABLE business_media (
  id INTEGER PRIMARY KEY,
  business_id INTEGER,
  original_filename VARCHAR,
  stored_filename VARCHAR,
  mime_type VARCHAR,
  ...
)
```

---

## 🔌 API Endpoints

### WhatsApp
- `GET /api/whatsapp/status` - Get connection status
- `GET /api/whatsapp/qr` - Get QR code
- `POST /api/whatsapp/send` - Send message
- `POST /api/whatsapp/disconnect` - Logout
- `POST /api/whatsapp/restart` - Restart bridge
- `POST /api/whatsapp/webhook` - Receive messages

### AI Settings
- `GET /api/ai-settings` - Get AI config
- `POST /api/ai-settings` - Create AI config
- `PUT /api/ai-settings` - Update AI config
- `POST /api/ai-settings/validate` - Validate API key

### Business
- `GET /api/business` - Get business profile
- `POST /api/business` - Create business
- `PUT /api/business` - Update business

### Leads
- `GET /api/leads` - List leads
- `POST /api/leads` - Create lead
- `GET /api/leads/{id}` - Get lead
- `PUT /api/leads/{id}` - Update lead

### Conversations
- `GET /api/conversations` - List conversations
- `GET /api/conversations/{id}` - Get conversation

### Dashboard
- `GET /api/dashboard/metrics` - Get metrics

### Media
- `POST /api/media/upload` - Upload file
- `GET /api/media/file/{id}` - Download file
- `DELETE /api/media/{id}` - Delete file

---

## 🛠️ Troubleshooting

### Issue: WhatsApp Bridge Not Connecting

**Status**: This is expected in TEST MODE

**Solution**: 
1. Install system libraries (Option 1 above), OR
2. Use Browserless.io (Option 2), OR
3. Use Docker (Option 3)

### Issue: QR Code Not Showing

**Status**: Should be working now ✅

**Test**:
```bash
curl http://localhost:8000/api/whatsapp/qr
```

Should return a base64-encoded PNG image.

### Issue: API Returns 404

**Check**:
```bash
curl http://localhost:8000/docs  # See all available endpoints
```

### Issue: Frontend Can't Connect to Backend

**Check**:
1. Backend running: `curl http://localhost:8000/health`
2. CORS enabled in `backend/main.py`
3. Frontend env var: Check `frontend/.env` if it exists

### Issue: Database Locked

**Fix**:
```bash
rm -f backend/smartflow.db  # Delete and recreate
cd backend && python -c "from database import engine, Base; import asyncio; asyncio.run(Base.metadata.create_all(engine))"
```

---

## 🚢 Running All Services

### Terminal 1: Backend
```bash
cd backend
source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Terminal 2: Frontend
```bash
cd frontend
npm run dev
```

### Terminal 3: WhatsApp Bridge
```bash
cd whatsapp-bridge
npm start
```

### Or Run All Together
```bash
# From Smartflow root directory
concurrently \
  "cd backend && source venv/bin/activate && uvicorn main:app --reload" \
  "cd frontend && npm run dev" \
  "cd whatsapp-bridge && npm start"
```

To install concurrently:
```bash
npm install -g concurrently
```

---

## 🔐 AI Provider Configuration

### Current Provider: OpenRouter (Free)
```
Provider: openrouter
API Key: Pre-configured
Model: arcee-ai/trinity-large-preview:free
Temperature: 0.7
Max Tokens: 500
```

### To Change AI Provider

1. **Use OpenAI**
```bash
# In backend/.env
OPENAI_API_KEY=sk-...your-key...

# Update AI settings via API
curl -X PUT http://localhost:8000/api/ai-settings \
  -H "Content-Type: application/json" \
  -d '{
    "provider": "openai",
    "api_key": "sk-...",
    "model": "gpt-4o-mini"
  }'
```

2. **Use Google Gemini**
```bash
# In backend/.env
GEMINI_API_KEY=...your-key...

# Update via API with provider="gemini"
```

3. **Use Other OpenRouter Models**
```bash
# Just change the model in AI settings
# Available models: https://openrouter.ai/docs#models
```

---

## 📊 Features Ready to Use

✅ **Fully Functional**
- ✅ Dashboard with metrics
- ✅ Lead management (CRUD)
- ✅ Conversation history
- ✅ Message automation
- ✅ AI response generation
- ✅ Media file uploads
- ✅ WhatsApp message sending (in TEST mode)
- ✅ QR code generation (in TEST mode)
- ✅ Business profiles
- ✅ API documentation

❌ **Live Integration Only** (TEST mode limitation)
- Real WhatsApp message receiving (needs browser)
- Real WhatsApp connections (needs browser)

---

## 📝 What to Do Next

1. **Test the Frontend**: Open http://localhost:3000
2. **Test the API**: Visit http://localhost:8000/docs
3. **Check WhatsApp QR**: http://localhost:8000/api/whatsapp/qr (returns base64 PNG)
4. **Enable Live WhatsApp**: Follow Option 1-3 above to install required libraries
5. **Configure AI Keys**: Set your preferred AI provider in `backend/.env`
6. **Deploy to Production**: Use Docker for consistent environment

---

## 🐳 Docker Deployment (Recommended)

Create `Dockerfile`:
```dockerfile
FROM node:18 as frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend .
RUN npm run build

FROM python:3.12 as backend
WORKDIR /app/backend
COPY backend/requirements.txt .
RUN pip install -r requirements.txt
COPY backend .

FROM node:18
WORKDIR /app
COPY --from=frontend /app/frontend /app/frontend
COPY --from=backend /app/backend /app/backend
COPY whatsapp-bridge whatsapp-bridge

# Install Chromium dependencies
RUN apt-get update && apt-get install -y \
    libnss3 libxss1 libasound2 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libgbm1 libpango-1.0-0 libpangocairo-1.0-0 ...

EXPOSE 3000 3001 8000
CMD concurrently ...
```

---

## 📞 Support Resources

- **WhatsApp.js Docs**: https://docs.wwebjs.dev/
- **FastAPI Docs**: https://fastapi.tiangolo.com/
- **Next.js Docs**: https://nextjs.org/docs
- **Puppeteer Docs**: https://pptr.dev/

---

**Last Updated**: April 8, 2026  
**Status**: ✅ All Core Features Ready  
**WhatsApp Mode**: 🔄 TEST MODE (Ready for Live Mode Installation)
