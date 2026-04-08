# Port Configuration Update

## Current Frontend Port: 2020

The frontend application has been configured to run on **port 2020** instead of port 3000.

### Access Your App
```
http://localhost:2020
```

### Backend & APIs (Unchanged)
```
http://localhost:8000       # Backend API & Docs
http://localhost:8000/docs  # Interactive API Documentation
```

### Changes Made
1. ✅ Frontend startup script updated to use port 2020
2. ✅ Backend CORS configuration updated to allow port 2020
3. ✅ All services restarted and working

### How to Start Services

**Option 1: One Command**
```bash
cd /workspaces/Smartflow
./start-app.sh
```

**Option 2: Separate Terminals**
```bash
# Backend
cd backend && source venv/bin/activate && uvicorn main:app --reload

# Frontend (port 2020)
cd frontend && npm run dev -- -p 2020

# WhatsApp Bridge
cd whatsapp-bridge && npm start
```

### Troubleshooting

If port 2020 is already in use:
```bash
# Find what's using port 2020
lsof -i :2020

# Kill the process
kill -9 <PID>

# Then restart
cd frontend && npm run dev -- -p 2020
```

### No More "Backend Unreachable" Error

The CORS configuration now properly allows the frontend (port 2020) to communicate with the backend (port 8000) without any errors.

---

Updated: April 8, 2026
