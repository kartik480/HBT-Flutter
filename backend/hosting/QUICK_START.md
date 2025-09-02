# 🚀 Quick Start Guide - Hostinger Hosting

Get your Habit Tracker API live on Hostinger in under 30 minutes!

## 🎯 **Choose Your Hosting Plan**

### **Option 1: Shared Hosting (Recommended for Start)**
- **Cost**: $2.99/month
- **Setup Time**: 15-20 minutes
- **Best for**: Development, testing, small apps
- **Features**: Python support, MySQL, cPanel, SSL

### **Option 2: VPS Hosting (Professional)**
- **Cost**: $3.95/month
- **Setup Time**: 25-30 minutes
- **Best for**: Production apps, larger user base
- **Features**: Full server control, PostgreSQL, custom config

## 🚀 **Quick Start - Shared Hosting**

### **Step 1: Purchase Hosting**
1. Go to [Hostinger.com](https://hostinger.com)
2. Choose **Premium Shared Hosting** ($2.99/month)
3. Complete purchase and setup

### **Step 2: Prepare Deployment Package**
```bash
cd backend/hosting
chmod +x deploy_shared_hosting.sh
./deploy_shared_hosting.sh
```

### **Step 3: Upload to Hostinger**
1. Login to Hostinger control panel
2. Go to **File Manager**
3. Navigate to `public_html` folder
4. Create new folder called `api`
5. Upload all files from `build_production/` to `api/` folder

### **Step 4: Create Database**
1. In cPanel, go to **MySQL Databases**
2. Create database: `habit_tracker_db`
3. Create user: `habit_user`
4. Grant privileges to user on database

### **Step 5: Configure Python App**
1. In cPanel, go to **Setup Python App**
2. Create new Python app:
   - App name: `habit-tracker-api`
   - Python version: `3.9`
   - App root: `/api`
3. Install requirements: `pip install -r requirements_production.txt`

### **Step 6: Configure Environment**
1. Create `.env` file in `api` folder
2. Add your configuration:
```bash
DATABASE_URL=mysql://habit_user:your_password@localhost:habit_tracker_db
SECRET_KEY=your-generated-secret-key
DEBUG=False
ENVIRONMENT=production
```

### **Step 7: Test Your API**
Visit: `https://your-domain.com/api/docs`

## 🐘 **Quick Start - VPS Hosting**

### **Step 1: Purchase VPS**
1. Choose **VPS 1** plan ($3.95/month)
2. Select Ubuntu 20.04 OS
3. Complete purchase

### **Step 2: Prepare Deployment Package**
```bash
cd backend/hosting
chmod +x deploy_vps.sh
./deploy_vps.sh
```

### **Step 3: Connect to VPS**
```bash
ssh root@your_vps_ip
```

### **Step 4: Upload and Deploy**
```bash
# From your local machine
scp habit-tracker-api_vps_deployment_*.zip root@your_vps_ip:/tmp/

# On the VPS
cd /var/www/habit-tracker
unzip /tmp/habit-tracker-api_vps_deployment_*.zip
chmod +x deploy_on_vps.sh
./deploy_on_vps.sh
```

### **Step 5: Configure Domain**
1. Point your domain DNS to VPS IP
2. Setup SSL: `certbot --nginx -d your-domain.com`

### **Step 6: Test Your API**
Visit: `https://your-domain.com/docs`

## 🔧 **Common Issues & Quick Fixes**

### **Database Connection Error**
```bash
# Check if database is running
systemctl status mysql  # or postgresql

# Test connection
mysql -u habit_user -p habit_tracker_db
```

### **Permission Denied**
```bash
# Fix file permissions
chmod -R 755 /var/www/habit-tracker
chown -R www-data:www-data /var/www/habit-tracker
```

### **Python App Not Working**
1. Check Python app status in cPanel
2. Verify app root path is correct
3. Check error logs in cPanel

### **API Not Responding**
1. Check if service is running: `systemctl status habit-tracker`
2. Check Nginx status: `systemctl status nginx`
3. Check logs: `tail -f /var/log/habit-tracker-error.log`

## 📱 **Update Flutter App**

After successful deployment, update your Flutter app:

```dart
// For shared hosting
const String apiBaseUrl = 'https://your-domain.com/api';

// For VPS hosting
const String apiBaseUrl = 'https://your-domain.com';
```

## 🎯 **What You Get**

✅ **Live API** accessible from anywhere  
✅ **Automatic HTTPS** with SSL certificates  
✅ **Professional hosting** with 99.9% uptime  
✅ **Scalable infrastructure** that grows with your app  
✅ **24/7 support** from Hostinger team  

## 💰 **Cost Breakdown**

### **Shared Hosting**
- Hosting: $2.99/month
- Domain: $0.99/year (first year)
- **Total**: ~$4/month

### **VPS Hosting**
- VPS: $3.95/month
- Domain: $0.99/year (first year)
- **Total**: ~$5/month

## 🚀 **Next Steps After Deployment**

1. **Test Your API** - Visit the documentation
2. **Update Flutter App** - Change API base URL
3. **Monitor Performance** - Check logs and metrics
4. **Setup Monitoring** - Use Hostinger's tools
5. **Plan Scaling** - Monitor usage and plan upgrades

## 📞 **Need Help?**

- **Hostinger Support**: 24/7 live chat and tickets
- **Documentation**: Check the detailed guides in this folder
- **Community**: Hostinger has an active user community

---

**Your Habit Tracker API will be live and accessible from anywhere in the world! 🌍**

**Happy Hosting! 🚀**
