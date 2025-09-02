# 🚀 Hostinger Hosting Setup Guide

This guide will help you deploy your Habit Tracker app on Hostinger hosting.

## 🎯 **Hosting Options on Hostinger**

### **1. Shared Hosting (Easy Setup)**
- **Plan**: Premium or Business Shared Hosting
- **Features**: 
  - Python support
  - MySQL databases
  - SSL certificates
  - cPanel access
- **Cost**: $2.99 - $3.99/month
- **Best for**: Development, testing, small apps

### **2. VPS Hosting (Professional Setup)**
- **Plan**: VPS 1 or VPS 2
- **Features**:
  - Full server control
  - Dedicated resources
  - Custom configurations
  - Multiple domains
- **Cost**: $3.95 - $8.95/month
- **Best for**: Production apps, larger user base

## 🚀 **Option 1: Shared Hosting Setup**

### **Step 1: Purchase Hosting Plan**
1. Go to [Hostinger.com](https://hostinger.com)
2. Choose **Premium Shared Hosting** or **Business Shared Hosting**
3. Complete purchase and setup

### **Step 2: Access cPanel**
1. Login to Hostinger control panel
2. Click on **cPanel** or **Hosting Control Panel**
3. Navigate to **Advanced** section

### **Step 3: Create Database**
1. In cPanel, find **MySQL Databases**
2. Create a new database:
   - Database name: `habit_tracker_db`
   - Username: `habit_user`
   - Password: `your_secure_password`
3. Note down the database details

### **Step 4: Upload Backend Files**
1. In cPanel, go to **File Manager**
2. Navigate to `public_html` folder
3. Create a new folder called `api`
4. Upload all backend files to this folder

### **Step 5: Configure Environment**
1. Create `.env` file in the `api` folder
2. Add your database configuration:

```bash
DATABASE_URL=mysql://habit_user:your_password@localhost:habit_tracker_db
SECRET_KEY=your-super-secret-key-here
DEBUG=False
ENVIRONMENT=production
```

### **Step 6: Install Python Dependencies**
1. In cPanel, go to **Setup Python App**
2. Create a new Python app:
   - App name: `habit-tracker-api`
   - Python version: `3.9` or `3.10`
   - App root: `/api`
3. Install requirements:

```bash
pip install -r requirements.txt
```

### **Step 7: Configure Web Server**
1. Create `.htaccess` file in `public_html/api` folder:

```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ app.py/$1 [QSA,L]

# Enable CORS
Header always set Access-Control-Allow-Origin "*"
Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
```

## 🐘 **Option 2: VPS Hosting Setup**

### **Step 1: Purchase VPS Plan**
1. Choose **VPS 1** or **VPS 2** plan
2. Select your preferred OS (Ubuntu 20.04 recommended)
3. Complete purchase

### **Step 2: Connect to VPS**
1. Get your VPS IP and root password
2. Connect via SSH:

```bash
ssh root@your_vps_ip
```

### **Step 3: Update System**
```bash
apt update && apt upgrade -y
apt install python3 python3-pip python3-venv nginx postgresql postgresql-contrib -y
```

### **Step 4: Create Database User**
```bash
sudo -u postgres psql
CREATE DATABASE habit_tracker_db;
CREATE USER habit_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE habit_tracker_db TO habit_user;
\q
```

### **Step 5: Setup Application**
```bash
# Create app directory
mkdir -p /var/www/habit-tracker
cd /var/www/habit-tracker

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Upload your backend files here
# Then install dependencies
pip install -r requirements.txt
```

### **Step 6: Configure Gunicorn**
```bash
pip install gunicorn

# Create gunicorn service file
cat > /etc/systemd/system/habit-tracker.service << EOF
[Unit]
Description=Habit Tracker API
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/var/www/habit-tracker
Environment="PATH=/var/www/habit-tracker/venv/bin"
ExecStart=/var/www/habit-tracker/venv/bin/gunicorn --workers 3 --bind unix:habit-tracker.sock -m 007 app.main:app

[Install]
WantedBy=multi-user.target
EOF

# Start service
systemctl start habit-tracker
systemctl enable habit-tracker
```

### **Step 7: Configure Nginx**
```bash
cat > /etc/nginx/sites-available/habit-tracker << EOF
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://unix:/var/www/habit-tracker/habit-tracker.sock;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable site
ln -s /etc/nginx/sites-available/habit-tracker /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

### **Step 8: Setup SSL with Let's Encrypt**
```bash
apt install certbot python3-certbot-nginx -y
certbot --nginx -d your-domain.com
```

## 🔧 **Environment Configuration**

### **Production Environment Variables**
```bash
# Database
DATABASE_URL=mysql://habit_user:password@localhost:habit_tracker_db
# or for PostgreSQL
DATABASE_URL=postgresql://habit_user:password@localhost:5432/habit_tracker_db

# Security
SECRET_KEY=your-production-secret-key-here
DEBUG=False
ENVIRONMENT=production

# CORS
ALLOWED_ORIGINS=https://your-domain.com,https://www.your-domain.com

# Email (if using Hostinger email)
SMTP_SERVER=mail.your-domain.com
SMTP_PORT=587
SMTP_USERNAME=noreply@your-domain.com
SMTP_PASSWORD=your-email-password
```

## 📱 **Flutter App Configuration**

### **Update API Base URL**
In your Flutter app, update the API base URL:

```dart
// For shared hosting
const String apiBaseUrl = 'https://your-domain.com/api';

// For VPS hosting
const String apiBaseUrl = 'https://your-domain.com';
```

### **Update CORS Settings**
Make sure your backend allows requests from your Flutter app domain.

## 🚨 **Common Issues & Solutions**

### **1. Database Connection Issues**
```bash
# Check if database is running
systemctl status mysql
# or
systemctl status postgresql

# Test connection
mysql -u habit_user -p habit_tracker_db
```

### **2. Permission Issues**
```bash
# Fix file permissions
chown -R www-data:www-data /var/www/habit-tracker
chmod -R 755 /var/www/habit-tracker
```

### **3. Port Issues**
```bash
# Check if ports are open
netstat -tlnp | grep :80
netstat -tlnp | grep :443
```

### **4. SSL Issues**
```bash
# Check SSL certificate
certbot certificates

# Renew if needed
certbot renew
```

## 📊 **Performance Optimization**

### **Database Optimization**
```sql
-- For MySQL
CREATE INDEX idx_user_id ON habits(user_id);
CREATE INDEX idx_category_id ON habits(category_id);
CREATE INDEX idx_completed_at ON completions(completed_at);

-- For PostgreSQL
CREATE INDEX CONCURRENTLY idx_user_id ON habits(user_id);
CREATE INDEX CONCURRENTLY idx_category_id ON habits(category_id);
CREATE INDEX CONCURRENTLY idx_completed_at ON completions(completed_at);
```

### **Application Optimization**
```bash
# Increase Gunicorn workers based on CPU cores
# For 2 CPU cores, use 4 workers
gunicorn --workers 4 --bind unix:habit-tracker.sock app.main:app

# Enable Gunicorn logging
gunicorn --workers 4 --bind unix:habit-tracker.sock --log-file /var/log/habit-tracker.log app.main:app
```

## 🔐 **Security Best Practices**

### **1. Environment Variables**
- Never commit `.env` files
- Use strong, unique passwords
- Rotate secrets regularly

### **2. Database Security**
- Use dedicated database user
- Limit database permissions
- Enable SSL connections

### **3. Application Security**
- Keep dependencies updated
- Enable HTTPS only
- Implement rate limiting
- Use secure headers

### **4. Server Security**
- Update system regularly
- Configure firewall
- Use SSH keys instead of passwords
- Monitor logs

## 📈 **Monitoring & Maintenance**

### **Health Checks**
```bash
# Check application status
systemctl status habit-tracker

# Check nginx status
systemctl status nginx

# Check database status
systemctl status mysql
# or
systemctl status postgresql
```

### **Log Monitoring**
```bash
# Application logs
tail -f /var/log/habit-tracker.log

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# System logs
journalctl -u habit-tracker -f
```

### **Backup Strategy**
```bash
# Database backup
mysqldump -u habit_user -p habit_tracker_db > backup.sql
# or
pg_dump -U habit_user habit_tracker_db > backup.sql

# Application backup
tar -czf habit-tracker-backup.tar.gz /var/www/habit-tracker
```

## 🎯 **Next Steps After Deployment**

1. **Test Your API**: Visit `https://your-domain.com/docs`
2. **Update Flutter App**: Change API base URL
3. **Monitor Performance**: Check logs and metrics
4. **Setup Monitoring**: Consider using Hostinger's monitoring tools
5. **Plan Scaling**: Monitor resource usage and plan upgrades

## 💰 **Cost Estimation**

### **Shared Hosting**
- **Premium Plan**: $2.99/month
- **Business Plan**: $3.99/month
- **Domain**: $0.99/year (first year)
- **Total**: ~$4-5/month

### **VPS Hosting**
- **VPS 1**: $3.95/month
- **VPS 2**: $8.95/month
- **Domain**: $0.99/year (first year)
- **Total**: ~$5-10/month

---

**Happy Hosting! 🚀**

Your Habit Tracker app will be live and accessible from anywhere in the world!
