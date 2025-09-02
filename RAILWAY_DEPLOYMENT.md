# 🚀 Railway Deployment Guide for Habit Tracker API

## 📋 **Prerequisites**
1. **Railway Account** - Sign up at [railway.app](https://railway.app)
2. **GitHub Account** - For connecting your repository
3. **Backend Code** - Already prepared in this project

## 🚀 **Step-by-Step Deployment**

### **Step 1: Prepare Your Repository**
1. **Push your code to GitHub** (if not already done)
2. **Make sure these files are in your root directory:**
   - `railway.json` ✅
   - `main.py` ✅
   - `requirements.txt` ✅
   - `app/` directory with all your FastAPI code ✅

### **Step 2: Connect to Railway**
1. **Go to [railway.app](https://railway.app)**
2. **Click "Login"** and sign in with GitHub
3. **Click "New Project"**
4. **Select "Deploy from GitHub repo"**
5. **Choose your repository** (HBT-2025)
6. **Click "Deploy"**

### **Step 3: Configure Environment Variables**
In Railway dashboard, go to **Variables** tab and add:

```bash
# Database (Railway will provide this automatically)
DATABASE_URL=postgresql://postgres:password@localhost:5432/habit_tracker

# Security
SECRET_KEY=your-super-secret-key-change-this-in-production-12345
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# App Configuration
APP_NAME=Habit Tracker API
APP_VERSION=1.0.0
DEBUG=False
ENVIRONMENT=production

# CORS Configuration
ALLOWED_ORIGINS=["*"]
ALLOWED_METHODS=["GET", "POST", "PUT", "DELETE", "OPTIONS"]
ALLOWED_HEADERS=["*"]

# API Configuration
API_V1_STR=/api/v1
PROJECT_NAME=Habit Tracker API
```

### **Step 4: Add PostgreSQL Database**
1. **In Railway dashboard, click "New"**
2. **Select "Database"**
3. **Choose "PostgreSQL"**
4. **Railway will automatically connect it to your app**

### **Step 5: Get Your API URL**
1. **After deployment, Railway will give you a URL like:**
   ```
   https://your-app-name-production.up.railway.app
   ```
2. **Your API will be available at:**
   ```
   https://your-app-name-production.up.railway.app/api/v1
   ```

## 🔧 **Update Flutter App**

Once you have your Railway URL, update the Flutter app:

1. **Open `lib/config/app_config.dart`**
2. **Change the API URL:**
   ```dart
   static const String apiBaseUrl = 'https://your-app-name-production.up.railway.app/api/v1';
   ```
3. **Set mock authentication to false:**
   ```dart
   static const bool enableMockAuth = false;
   ```

## 🧪 **Test Your Deployment**

1. **Check health endpoint:**
   ```
   https://your-app-name-production.up.railway.app/api/v1/health
   ```

2. **Test registration:**
   ```bash
   curl -X POST "https://your-app-name-production.up.railway.app/api/v1/auth/register" \
   -H "Content-Type: application/json" \
   -d '{
     "email": "test@example.com",
     "username": "testuser",
     "password": "password123",
     "first_name": "Test",
     "last_name": "User"
   }'
   ```

## 🎯 **Expected Results**

After successful deployment:
- ✅ **API accessible** at your Railway URL
- ✅ **Database connected** and working
- ✅ **Authentication endpoints** working
- ✅ **Flutter app** can connect to real backend
- ✅ **No more mock authentication** needed

## 🆘 **Troubleshooting**

### **Common Issues:**
1. **Build fails** - Check `requirements.txt` and `main.py`
2. **Database connection error** - Verify `DATABASE_URL` in Railway
3. **CORS errors** - Check `ALLOWED_ORIGINS` setting
4. **App not starting** - Check Railway logs for errors

### **Railway Logs:**
- Go to your project in Railway dashboard
- Click on your service
- Go to "Deployments" tab
- Click on latest deployment to see logs

## 🎉 **Success!**

Once deployed, your Flutter app will connect to a real backend with:
- ✅ **Real user accounts**
- ✅ **Data persistence**
- ✅ **Secure authentication**
- ✅ **Production-ready API**

Your habit tracker will be fully functional with a live backend! 🚀
