# 🚀 Habit Tracker API - Hostinger Deployment Instructions

## 📁 **Files Ready for Upload**

All your Python files are ready! Here's what you have:

### **📂 File Structure:**
```
api/
├── app/                    # Your Python application
│   ├── __init__.py
│   ├── main.py            # FastAPI app
│   ├── config.py          # Configuration
│   ├── database.py        # Database setup
│   ├── api/               # API endpoints
│   │   └── v1/
│   │       ├── api.py     # Main router
│   │       └── endpoints/ # API endpoints
│   ├── core/              # Core functionality
│   │   └── security.py    # Authentication
│   ├── models/            # Database models
│   │   ├── user.py
│   │   ├── habit.py
│   │   ├── category.py
│   │   ├── completion.py
│   │   ├── reminder.py
│   │   └── streak.py
│   └── schemas/           # Data validation
│       └── auth.py
├── scripts/                # Database scripts
│   └── init_db.py         # Database initialization
├── main.py                 # Production entry point
├── requirements_production.txt  # Python dependencies
├── .htaccess               # Apache configuration
├── env_template.txt        # Environment template
└── DEPLOYMENT_INSTRUCTIONS.md  # This file
```

## 🚀 **Step-by-Step Deployment**

### **Step 1: Access Hostinger File Manager**
1. Login to Hostinger control panel
2. Click **"File Manager"**
3. Navigate to `public_html` folder

### **Step 2: Create API Folder**
1. Click **"New Folder"** button
2. Name it `api`
3. Click **"Create"**

### **Step 3: Upload All Files**
1. Open the `api` folder
2. Click **"Upload"** button
3. **Drag and Drop** all files from this folder
4. Or select files and click **"Upload"**

### **Step 4: Create Database**
1. Go back to Hostinger control panel
2. Click **"MySQL Databases"**
3. Create new database:
   - Database name: `habit_tracker_db`
   - Username: `habit_user`
   - Password: `your_secure_password`
4. Grant privileges to user on database

### **Step 5: Configure Python App**
1. In cPanel, go to **"Setup Python App"**
2. Create new Python app:
   - App name: `habit-tracker-api`
   - Python version: `3.9` or `3.10`
   - App root: `/api`
3. Click **"Create"**

### **Step 6: Install Dependencies**
1. In Python app settings, click **"Terminal"**
2. Run: `pip install -r requirements_production.txt`
3. Wait for installation to complete

### **Step 7: Configure Environment**
1. In File Manager, go to `api` folder
2. Create new file called `.env`
3. Copy content from `env_template.txt`
4. Update with your values:
   ```bash
   DATABASE_URL=mysql://habit_user:your_password@localhost:habit_tracker_db
   SECRET_KEY=your-generated-secret-key
   DEBUG=False
   ENVIRONMENT=production
   ```

### **Step 8: Generate Secret Key**
1. In Python app terminal, run:
   ```python
   import secrets
   print(secrets.token_urlsafe(32))
   ```
2. Copy the generated key
3. Update `.env` file with this key

### **Step 9: Initialize Database**
1. In Python app terminal, run:
   ```bash
   cd /api
   python scripts/init_db.py
   ```

### **Step 10: Test Your API**
Visit: `https://pznstudio.shop/api/docs`

## 🔧 **File Permissions**

After upload, set correct permissions:
- **Folders**: `755`
- **Files**: `644`
- **Scripts**: `755`

## 🚨 **Common Issues & Solutions**

### **Database Connection Error**
- Verify database credentials in `.env`
- Check if database user has privileges
- Ensure database is created

### **Python App Not Working**
- Check Python app status in cPanel
- Verify app root path is `/api`
- Check error logs in Python app settings

### **API Not Responding**
- Verify `.htaccess` is uploaded
- Check if Python app is running
- Look at error logs

### **Import Errors**
- Ensure all files are uploaded
- Check file permissions
- Verify Python app root path

## 📱 **Update Flutter App**

After successful deployment, update your Flutter app:

```dart
const String apiBaseUrl = 'https://pznstudio.shop/api';
```

## 🎯 **What You Get**

✅ **Live API** accessible from anywhere  
✅ **Automatic HTTPS** with SSL certificates  
✅ **Professional hosting** with 99.9% uptime  
✅ **Scalable infrastructure** that grows with your app  
✅ **24/7 support** from Hostinger team  

## 💰 **Cost**

- **Hosting**: $2.99/month (Premium Shared)
- **Domain**: $0.99/year (first year)
- **Total**: ~$4/month

## 📞 **Need Help?**

- **Hostinger Support**: 24/7 live chat
- **File Manager Help**: Available in Hostinger help center
- **Python App Guide**: Step-by-step setup instructions

---

**Your Habit Tracker API will be live at: https://pznstudio.shop/api 🌍**

**Happy Hosting! 🚀**
