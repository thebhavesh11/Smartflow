/**
 * SmartFlow WhatsApp Bridge - Rebuilt for Dev Container
 * Simple Node.js solution without Puppeteer/Chromium dependency
 */

const express = require('express');
const cors = require('cors');
const axios = require('axios');
const qrcode = require('qrcode');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3001;
const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8000';
const DATA_DIR = path.join(__dirname, '.wwebjs_auth');

// Ensure data directory exists
if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR, { recursive: true });
}

// Bridge state
let bridgeState = {
  connected: false,
  hasQR: false,
  qrCode: null,
  connectionInfo: null,
  error: null,
  messages: [],
  sessions: {}
};

// Generate a test phone number
function generateTestPhone() {
  return `92${Math.floor(Math.random() * 9000000000 + 1000000000)}`;
}

// Generate QR code
async function generateQRCode() {
  try {
    const qrData = `smartflow-session-${Date.now()}`;
    const qrImage = await qrcode.toDataURL(qrData, { width: 256 });
    bridgeState.qrCode = qrImage;
    bridgeState.hasQR = true;
    console.log('[Bridge] ✓ QR Code generated');
    return qrImage;
  } catch (err) {
    console.error('[Bridge] QR generation error:', err.message);
    bridgeState.error = 'QR generation failed: ' + err.message;
    return null;
  }
}

// Simulate WhatsApp connection
async function initializeBridge() {
  console.log('[Bridge] Initializing WhatsApp Bridge...');
  console.log('[Bridge] ℹ️  Running in SIMULATOR MODE for dev container');
  
  try {
    // Generate initial QR
    await generateQRCode();
    bridgeState.error = null;
    console.log('[Bridge] ✓ Bridge initialized successfully');
    console.log('[Bridge] ℹ️  Ready to handle WhatsApp requests');
  } catch (err) {
    console.error('[Bridge] Init error:', err.message);
    bridgeState.error = err.message;
  }
}

// Simulate scanning QR (connecting)
function connectSession() {
  if (bridgeState.connected) {
    return true;
  }
  
  bridgeState.connected = true;
  bridgeState.hasQR = false;
  bridgeState.qrCode = null;
  bridgeState.connectionInfo = {
    pushname: `SmartFlow User ${Date.now() % 10000}`,
    platform: 'web',
    phoneNumber: generateTestPhone(),
    mode: 'SIMULATOR'
  };
  bridgeState.error = null;
  console.log('[Bridge] ✓ Session connected:', bridgeState.connectionInfo.phoneNumber);
  return true;
}

// Simulate message storage
function storeMessage(phone, message, direction = 'outgoing') {
  const msg = {
    id: `msg-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
    phone: phone,
    message: message,
    direction: direction,
    timestamp: new Date().toISOString(),
  };
  bridgeState.messages.push(msg);
  console.log(`[Bridge] Message (${direction}): ${phone} - ${message.substring(0, 50)}`);
  return msg;
}

// =================================
// API ENDPOINTS
// =================================

/**
 * GET /status - Get bridge status
 */
app.get('/status', (req, res) => {
  res.json({
    connected: bridgeState.connected,
    hasQR: bridgeState.hasQR,
    info: bridgeState.connectionInfo,
    error: bridgeState.error,
    mode: 'SIMULATOR',
    version: '2.0.0'
  });
});

/**
 * GET /qr - Get QR code
 */
app.get('/qr', (req, res) => {
  res.json({
    qr: bridgeState.qrCode,
    hasQR: bridgeState.hasQR,
    mode: 'SIMULATOR'
  });
});

/**
 * POST /connect - Connect/scan QR
 */
app.post('/connect', (req, res) => {
  try {
    const connected = connectSession();
    if (connected) {
      res.json({
        success: true,
        message: 'Session connected',
        info: bridgeState.connectionInfo
      });
    } else {
      res.json({
        success: false,
        error: 'Failed to connect'
      });
    }
  } catch (err) {
    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

/**
 * POST /send - Send message
 */
app.post('/send', async (req, res) => {
  const { phone, message } = req.body;
  
  if (!phone || !message) {
    return res.status(400).json({
      success: false,
      error: 'Phone and message required'
    });
  }

  try {
    // If not connected, auto-connect for testing
    if (!bridgeState.connected) {
      connectSession();
    }

    // Store message
    const msg = storeMessage(phone, message, 'outgoing');
    
    // Simulate sending delay
    setTimeout(async () => {
      try {
        // Send webhook to backend
        await axios.post(`${BACKEND_URL}/api/whatsapp/webhook`, {
          phone: phone,
          message: message,
          name: 'SmartFlow User',
          business_id: 1,
          messageId: msg.id
        });
        console.log('[Bridge] ✓ Webhook sent to backend');
      } catch (err) {
        console.error('[Bridge] Webhook error:', err.message);
      }
    }, 500);

    res.json({
      success: true,
      messageId: msg.id,
      mode: 'SIMULATOR'
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

/**
 * POST /send-media - Send media file
 */
app.post('/send-media', async (req, res) => {
  const { phone, filename, caption } = req.body;

  try {
    if (!bridgeState.connected) {
      connectSession();
    }

    const msg = storeMessage(phone, `📎 ${filename} - ${caption || ''}`, 'outgoing');

    res.json({
      success: true,
      mode: 'SIMULATOR',
      message: 'Media queued for sending'
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

/**
 * POST /logout - Logout/disconnect
 */
app.post('/logout', (req, res) => {
  try {
    bridgeState.connected = false;
    bridgeState.connectionInfo = null;
    bridgeState.messages = [];
    generateQRCode(); // Regenerate QR for re-connection
    
    console.log('[Bridge] ✓ Logged out');
    res.json({
      success: true,
      message: 'Logged out successfully'
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

/**
 * POST /restart - Restart bridge
 */
app.post('/restart', (req, res) => {
  try {
    bridgeState.connected = false;
    bridgeState.connectionInfo = null;
    bridgeState.messages = [];
    generateQRCode();
    
    console.log('[Bridge] ✓ Restarted');
    res.json({
      success: true,
      message: 'Bridge restarted'
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

/**
 * GET /messages - Get message history
 */
app.get('/messages', (req, res) => {
  res.json({
    messages: bridgeState.messages,
    total: bridgeState.messages.length
  });
});

/**
 * DELETE /messages - Clear message history
 */
app.delete('/messages', (req, res) => {
  bridgeState.messages = [];
  res.json({
    success: true,
    message: 'Message history cleared'
  });
});

/**
 * GET /health - Health check
 */
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime(),
    mode: 'SIMULATOR'
  });
});

// =================================
// START SERVER
// =================================

app.listen(PORT, async () => {
  console.log('');
  console.log('╔════════════════════════════════════════════════╗');
  console.log('║  SmartFlow WhatsApp Bridge v2.0 (Rebuilt)      ║');
  console.log('╚════════════════════════════════════════════════╝');
  console.log('');
  console.log(`[Bridge] Running on http://0.0.0.0:${PORT}`);
  console.log(`[Bridge] Backend URL: ${BACKEND_URL}`);
  console.log('[Bridge] Mode: SIMULATOR (No browser needed)');
  console.log('');
  
  await initializeBridge();
  
  console.log('[Bridge] ✅ Ready to handle requests');
  console.log('');
});
