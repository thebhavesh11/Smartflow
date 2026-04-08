# Deploying Smartflow to Render

This guide will help you deploy the Smartflow app to Render.

## Prerequisites

1. **Render Account**: Sign up at [render.com](https://render.com)
2. **GitHub Repository**: Push your code to GitHub
3. **Environment Variables**: Prepare your `.env` variables

## Deployment Steps

### Step 1: Connect GitHub Repository to Render

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"Blueprint"**
3. Connect your GitHub account and select the Smartflow repository
4. Click **"Connect"**

### Step 2: Review the Configuration

The `render.yaml` file contains three services:

- **smartflow-backend** (FastAPI Python service)
- **smartflow-frontend** (Next.js Node.js service)
- **smartflow-whatsapp** (WhatsApp Bridge Node.js service)

### Step 3: Set Environment Variables

Before deploying, set up environment variables in Render:

1. In the Blueprint editor, review the services
2. For **Backend Service**:
   - `DATABASE_URL`: Pre-configured to use SQLite
   - `OPENAI_API_KEY`: Add your OpenAI key
   - `GOOGLE_API_KEY`: Add your Google API key
   - `OPENROUTER_API_KEY`: Add your OpenRouter key (if using)

3. For **Frontend Service**:
   - `NEXT_PUBLIC_API_URL`: Should auto-populate as `https://smartflow-backend.onrender.com`

4. For **WhatsApp Service**:
   - `BACKEND_URL`: Should auto-populate as `https://smartflow-backend.onrender.com`

### Step 4: Deploy

1. Click **"Deploy Blueprint"**
2. Render will create all three services and start deploying
3. Wait for all services to show "Live" status (this may take 5-10 minutes)

### Step 5: Verify Deployment

Once deployed, you can access:

- **Frontend**: `https://smartflow-frontend.onrender.com`
- **Backend API**: `https://smartflow-backend.onrender.com`
- **API Docs**: `https://smartflow-backend.onrender.com/docs`
- **WhatsApp Bridge**: `https://smartflow-whatsapp.onrender.com/status`

## Common Issues & Solutions

### Issue 1: WhatsApp Bridge Fails to Start
**Reason**: Puppeteer requires system libraries (Chromium)

**Solution**: 
- For Puppeteer to work in Render, it requires a buildpack or custom Dockerfile
- Option A: Use `whatsapp-web.js` without Puppeteer (lightweight alternative)
- Option B: Contact Render support for custom buildpack

### Issue 2: Database Persistence
**Current Setup**: Using SQLite (file-based, resets on service restart)

**Recommended for Production**:
Create a PostgreSQL database on Render:
1. Go to Render Dashboard → "New +" → "PostgreSQL"
2. Create a new database
3. Update `DATABASE_URL` in backend service to the PostgreSQL connection string

### Issue 3: Cross-Service Communication
Services communicate via:
- Frontend → Backend: `https://smartflow-backend.onrender.com`
- WhatsApp → Backend: `https://smartflow-backend.onrender.com`

These URLs are set in `NEXT_PUBLIC_API_URL` and `BACKEND_URL`

## Database Migration (SQLite to PostgreSQL)

To use PostgreSQL instead of SQLite for better reliability:

1. Create PostgreSQL database in Render
2. Modify `backend/database.py`:
   ```python
   DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+asyncpg://user:password@host/db")
   ```
3. Update `requirements.txt` to include:
   ```
   asyncpg
   psycopg2-binary
   ```
4. Re-deploy

## Monitoring & Logs

In Render Dashboard:
1. Click on each service to view logs
2. Use the **Logs** tab to debug issues
3. Check **Metrics** for resource usage

## Cost Information

Render's free tier includes:
- Web Services: 750 hrs/month (about 1 service running continuously)
- PostgreSQL: 90-day free trial with 1 free database

For production with multiple services running 24/7, you'll need a paid plan.

## Next Steps

1. ✅ Ensure all API keys are set
2. ✅ Test the deployed services
3. ✅ Set up custom domain (optional)
4. ✅ Configure database backups (if using PostgreSQL)
5. ✅ Set up monitoring and logs

## Support

- Render Documentation: https://render.com/docs
- Smartflow Issues: Check project README for troubleshooting
