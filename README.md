# Smartflow - Automation App

A full-stack application with FastAPI backend, Next.js frontend, and WhatsApp integration.

## Project Structure

```
Smartflow/
├── backend/              # FastAPI application
│   ├── main.py          # Main application entry point
│   ├── database.py       # Database configuration
│   ├── models.py         # SQLAlchemy models
│   ├── schemas.py        # Pydantic schemas
│   ├── requirements.txt   # Python dependencies
│   ├── automation/       # Automation engine
│   ├── routers/          # API route handlers
│   └── uploads/          # File uploads directory
├── frontend/             # Next.js application
│   ├── app/              # Next.js app directory
│   ├── package.json      # Node.js dependencies
│   └── next.config.js    # Next.js configuration
├── whatsapp-bridge/      # WhatsApp integration service
│   ├── index.js          # Main entry point
│   ├── package.json      # Dependencies
│   └── check.js          # Health check
└── README.md             # This file
```

## Prerequisites

- Python 3.8+ (for backend)
- Node.js 14+ (for frontend and WhatsApp bridge)
- npm or yarn
- Git

## Quick Start

### Option 1: Using Batch Files (Windows)

#### Setup Everything
```bash
setup-all.bat
```
This will:
- Install Python virtual environment for backend
- Install Python dependencies
- Install Node.js dependencies for frontend and WhatsApp bridge

#### Start All Services
```bash
start-all.bat
```
This will start backend, frontend, and WhatsApp bridge in separate windows.

#### Individual Commands

**Start Backend Only:**
```bash
start-backend.bat
```

**Start Frontend Only:**
```bash
start-frontend.bat
```

**Start WhatsApp Bridge Only:**
```bash
start-whatsapp.bat
```

### Option 2: Manual Setup (All Platforms)

#### 1. Clone the Repository
```bash
git clone https://github.com/thebhavesh11/Smartflow.git
cd Smartflow
```

#### 2. Setup Backend
```bash
cd backend
python -m venv venv

# On Windows:
.\venv\Scripts\Activate.ps1

# On macOS/Linux:
source venv/bin/activate

pip install -r requirements.txt
```

#### 3. Start Backend Server
```bash
# Option A: Direct Python
python main.py

# Option B: Using Uvicorn
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Backend API endpoint: `http://localhost:8000`
API Documentation: `http://localhost:8000/docs`

#### 4. Setup Frontend (in a new terminal)
```bash
cd frontend
npm install
```

#### 5. Start Frontend Development Server
```bash
npm run dev
```

Frontend URL: `http://localhost:3000`

#### 6. Setup WhatsApp Bridge (Optional, in another terminal)
```bash
cd whatsapp-bridge
npm install
```

#### 7. Start WhatsApp Bridge
```bash
node index.js
```

## Available Scripts

### Backend
- `python main.py` - Start development server
- `uvicorn main:app --reload` - Start with auto-reload

### Frontend
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

### WhatsApp Bridge
- `node index.js` - Start service
- `node check.js` - Health check

## API Routes

The backend serves the following main route groups:
- `/api/` - General API endpoints
- `/docs` - Swagger API documentation
- `/redoc` - ReDoc API documentation

Available routers in `backend/routers/`:
- `ai_settings.py` - AI configuration endpoints
- `business.py` - Business management
- `conversations.py` - Conversation handling
- `dashboard.py` - Dashboard data
- `leads.py` - Lead management
- `media.py` - Media handling
- `whatsapp.py` - WhatsApp integration

## Environment Variables

Create a `.env` file in the `backend/` directory if needed:
```
DATABASE_URL=sqlite:///./test.db
API_KEY=your_api_key_here
WHATSAPP_API_KEY=your_whatsapp_key
```

## Database

The application uses SQLAlchemy ORM with SQLite by default.

To initialize the database:
```bash
cd backend
python
>>> from database import Base, engine
>>> Base.metadata.create_all(bind=engine)
```

## Frontend Pages

- `/` - Home page
- `/automation` - Automation settings
- `/businesses` - Business management
- `/conversations` - Message conversations
- `/leads` - Lead tracking
- `/whatsapp` - WhatsApp configuration

## Troubleshooting

### Backend won't start
- Ensure Python 3.8+ is installed: `python --version`
- Check virtual environment is activated
- Clear `__pycache__` folders: `Get-ChildItem -Path . -Filter __pycache__ -Recurse -Force | Remove-Item -Recurse -Force`

### Frontend won't start
- Clear node_modules: `rm -r node_modules && npm install`
- Clear Next.js cache: `rm -r .next`
- Check Node.js version: `node --version`

### Port already in use
- Backend (8000): `netstat -ano | findstr :8000` (Windows)
- Frontend (3000): `netstat -ano | findstr :3000` (Windows)
- Kill process: `taskkill /PID <PID> /F` (Windows)

## Repository Links

- GitHub: https://github.com/thebhavesh11/Smartflow
- Issues: https://github.com/thebhavesh11/Smartflow/issues

## License

MIT License - See LICENSE file for details

## Author

Bhavesh - [@thebhavesh11](https://github.com/thebhavesh11)

---

**Happy coding!** 🚀
