# ✅ Deployment Checklist

## 🚀 **Pre-Deployment**
- [ ] Purchase Hostinger Premium Shared Hosting ($2.99/month)
- [ ] Get your domain name
- [ ] Access Hostinger control panel

## 📁 **File Upload**
- [ ] Open File Manager in cPanel
- [ ] Go to `public_html` folder
- [ ] Create new folder called `api`
- [ ] Upload ALL files from this folder to `api` folder
- [ ] Set file permissions (folders: 755, files: 644)

## 🗄️ **Database Setup**
- [ ] Go to MySQL Databases in cPanel
- [ ] Create database: `habit_tracker_db`
- [ ] Create user: `habit_user`
- [ ] Grant privileges to user on database
- [ ] Note down database credentials

## 🐍 **Python App Setup**
- [ ] Go to Setup Python App in cPanel
- [ ] Create new Python app:
  - App name: `habit-tracker-api`
  - Python version: `3.9` or `3.10`
  - App root: `/api`
- [ ] Click Create

## 📦 **Install Dependencies**
- [ ] Open Python app terminal
- [ ] Run: `pip install -r requirements_production.txt`
- [ ] Wait for installation to complete

## ⚙️ **Environment Configuration**
- [ ] Create `.env` file in `api` folder
- [ ] Copy content from `env_template.txt`
- [ ] Update database URL with your credentials
- [ ] Generate secret key: `python -c "import secrets; print(secrets.token_urlsafe(32))"`
- [ ] Update SECRET_KEY in `.env` file
- [ ] Set DEBUG=False and ENVIRONMENT=production

## 🗃️ **Initialize Database**
- [ ] In Python app terminal, run: `cd /api && python scripts/init_db.py`
- [ ] Verify database tables are created

## 🧪 **Testing**
- [ ] Visit: `https://pznstudio.shop/api/docs`
- [ ] Test API endpoints
- [ ] Check error logs if issues occur

## 📱 **Update Flutter App**
- [ ] Change API base URL to: `https://pznstudio.shop/api`
- [ ] Test mobile app connection
- [ ] Verify authentication works

## 🔒 **Security Check**
- [ ] Verify HTTPS is working
- [ ] Check CORS settings
- [ ] Validate authentication
- [ ] Test rate limiting

## 📊 **Post-Deployment**
- [ ] Monitor performance
- [ ] Check logs regularly
- [ ] Setup monitoring alerts
- [ ] Plan for scaling

---

**Check each item as you complete it! ✅**

**Your API will be live at: https://pznstudio.shop/api**
**Documentation at: https://pznstudio.shop/api/docs**
