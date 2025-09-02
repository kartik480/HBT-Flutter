h#!/bin/bash

# 🚀 Habit Tracker API Deployment Script for Hostinger VPS
# This script helps deploy your API to Hostinger VPS hosting

set -e  # Exit on any error

echo "🚀 Starting Habit Tracker API deployment to Hostinger VPS..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="habit-tracker-api"
DOMAIN="your-domain.com"
VPS_IP=""
VPS_USER="root"
DB_NAME="habit_tracker_db"
DB_USER="habit_user"
DB_PASSWORD=""

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_requirements() {
    print_status "Checking requirements..."
    
    if ! command -v ssh &> /dev/null; then
        print_error "ssh command not found. Please install OpenSSH client."
        exit 1
    fi
    
    if ! command -v scp &> /dev/null; then
        print_error "scp command not found. Please install OpenSSH client."
        exit 1
    fi
    
    if ! command -v zip &> /dev/null; then
        print_error "zip command not found. Please install zip."
        exit 1
    fi
    
    print_success "Requirements check passed!"
}

# Create production build
create_build() {
    print_status "Creating production build..."
    
    # Create build directory
    BUILD_DIR="build_vps"
    rm -rf $BUILD_DIR
    mkdir -p $BUILD_DIR
    
    # Copy necessary files
    cp -r app $BUILD_DIR/
    cp -r scripts $BUILD_DIR/
    cp requirements.txt $BUILD_DIR/
    cp hosting/production_config.py $BUILD_DIR/
    
    # Create production main.py
    cat > $BUILD_DIR/main.py << 'EOF'
#!/usr/bin/env python3
"""
Production entry point for Habit Tracker API
"""

import os
import sys
from pathlib import Path

# Add app directory to path
sys.path.insert(0, str(Path(__file__).parent / "app"))

from app.main import app

if __name__ == "__main__":
    import uvicorn
    
    # Production settings
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", "8000"))
    
    uvicorn.run(
        app,
        host=host,
        port=port,
        log_level="info"
    )
EOF

    # Create systemd service file
    cat > $BUILD_DIR/habit-tracker.service << 'EOF'
[Unit]
Description=Habit Tracker API
After=network.target postgresql.service

[Service]
Type=notify
User=www-data
Group=www-data
WorkingDirectory=/var/www/habit-tracker
Environment="PATH=/var/www/habit-tracker/venv/bin"
Environment="PYTHONPATH=/var/www/habit-tracker"
ExecStart=/var/www/habit-tracker/venv/bin/gunicorn --workers 4 --bind unix:habit-tracker.sock --access-logfile /var/log/habit-tracker-access.log --error-logfile /var/log/habit-tracker-error.log app.main:app
ExecReload=/bin/kill -s HUP $MAINPID
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

    # Create Nginx configuration
    cat > $BUILD_DIR/nginx-site << 'EOF'
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;
    
    # API routes
    location / {
        proxy_pass http://unix:/var/www/habit-tracker/habit-tracker.sock;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Buffer settings
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
    }
    
    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
    
    # Static files (if any)
    location /static/ {
        alias /var/www/habit-tracker/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

    # Create production requirements.txt
    cat > $BUILD_DIR/requirements_production.txt << 'EOF'
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
pydantic==2.5.0
pydantic-settings==2.1.0
python-dotenv==1.0.0
gunicorn==21.2.0
redis==5.0.1
celery==5.3.4
EOF

    # Create deployment script
    cat > $BUILD_DIR/deploy_on_vps.sh << 'EOF'
#!/bin/bash

# 🚀 VPS Deployment Script
# Run this script on your VPS after uploading files

set -e

echo "🚀 Starting VPS deployment..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Update system
print_status "Updating system packages..."
apt update && apt upgrade -y

# Install required packages
print_status "Installing required packages..."
apt install -y python3 python3-pip python3-venv nginx postgresql postgresql-contrib redis-server supervisor

# Create application directory
print_status "Setting up application directory..."
mkdir -p /var/www/habit-tracker
cd /var/www/habit-tracker

# Create virtual environment
print_status "Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
print_status "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements_production.txt

# Install Gunicorn
pip install gunicorn

# Set correct permissions
print_status "Setting file permissions..."
chown -R www-data:www-data /var/www/habit-tracker
chmod -R 755 /var/www/habit-tracker

# Setup PostgreSQL
print_status "Setting up PostgreSQL..."
sudo -u postgres psql -c "CREATE DATABASE habit_tracker_db;" || echo "Database already exists"
sudo -u postgres psql -c "CREATE USER habit_user WITH PASSWORD 'your_password';" || echo "User already exists"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE habit_tracker_db TO habit_user;"

# Setup systemd service
print_status "Setting up systemd service..."
cp habit-tracker.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable habit-tracker

# Setup Nginx
print_status "Setting up Nginx..."
cp nginx-site /etc/nginx/sites-available/habit-tracker
ln -sf /etc/nginx/sites-available/habit-tracker /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx

# Setup Redis
print_status "Setting up Redis..."
systemctl enable redis-server
systemctl start redis-server

# Create log files
print_status "Setting up logging..."
touch /var/log/habit-tracker-access.log
touch /var/log/habit-tracker-error.log
chown www-data:www-data /var/log/habit-tracker-*.log

# Start application
print_status "Starting application..."
systemctl start habit-tracker

# Check status
print_status "Checking service status..."
systemctl status habit-tracker --no-pager -l

print_success "VPS deployment complete!"
echo
echo "🌐 Your API is now running at: https://pznstudio.shop"
echo "📚 API documentation: https://pznstudio.shop/docs"
echo
echo "📋 Next steps:"
echo "1. Configure your domain DNS to point to this VPS"
echo "2. Setup SSL certificate with Let's Encrypt"
echo "3. Update your .env file with production settings"
echo "4. Test your API endpoints"
echo "5. Update Flutter app with new API URL"
EOF

    chmod +x $BUILD_DIR/deploy_on_vps.sh

    # Create environment template
    cat > $BUILD_DIR/.env.template << 'EOF'
# 🚀 Habit Tracker API - VPS Production Environment Variables
# Copy this file to .env and fill in your values

# Database Configuration
DATABASE_URL=postgresql://habit_user:your_password@localhost:5432/habit_tracker_db

# Security
SECRET_KEY=generate-strong-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# App Configuration
DEBUG=False
ENVIRONMENT=production
APP_NAME=Habit Tracker API
APP_VERSION=1.0.0

# CORS
ALLOWED_ORIGINS=https://your-domain.com,https://www.your-domain.com

# Redis
REDIS_URL=redis://localhost:6379

# Email (optional)
SMTP_SERVER=mail.your-domain.com
SMTP_PORT=587
SMTP_USERNAME=noreply@your-domain.com
SMTP_PASSWORD=your-email-password

# Performance
MAX_CONNECTIONS=100
WORKER_PROCESSES=4
REQUEST_TIMEOUT=30
EOF

    print_success "VPS build created in $BUILD_DIR/"
}

# Create deployment package
create_package() {
    print_status "Creating deployment package..."
    
    PACKAGE_NAME="${APP_NAME}_vps_deployment_$(date +%Y%m%d_%H%M%S).zip"
    
    cd build_vps
    zip -r "../$PACKAGE_NAME" .
    cd ..
    
    print_success "VPS deployment package created: $PACKAGE_NAME"
}

# Generate secret key
generate_secret_key() {
    print_status "Generating secure secret key..."
    
    SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
    
    cat > build_vps/SECRET_KEY.txt << EOF
🔐 Generated Secret Key for Production

Your generated secret key:
$SECRET_KEY

⚠️  IMPORTANT: 
1. Copy this key to your .env file
2. Keep this file secure and delete after deployment
3. Never commit this key to version control

To use this key, add to your .env file:
SECRET_KEY=$SECRET_KEY
EOF

    print_success "Secret key generated and saved to SECRET_KEY.txt"
}

# Create deployment checklist
create_checklist() {
    print_status "Creating VPS deployment checklist..."
    
    cat > build_vps/VPS_DEPLOYMENT_CHECKLIST.md << 'EOF'
# ✅ VPS Deployment Checklist

## Pre-Deployment
- [ ] Test API locally
- [ ] Update domain in configuration
- [ ] Generate strong secret key
- [ ] Prepare VPS credentials
- [ ] Ensure domain DNS is configured

## VPS Setup
- [ ] Purchase VPS plan on Hostinger
- [ ] Get VPS IP address and root password
- [ ] Connect to VPS via SSH
- [ ] Update system packages
- [ ] Install required software

## File Upload
- [ ] Upload deployment package to VPS
- [ ] Extract files to /var/www/habit-tracker
- [ ] Set correct file permissions
- [ ] Run deploy_on_vps.sh script

## Database Setup
- [ ] PostgreSQL is installed and running
- [ ] Database habit_tracker_db is created
- [ ] User habit_user is created with privileges
- [ ] Test database connection

## Application Setup
- [ ] Python virtual environment is created
- [ ] Dependencies are installed
- [ ] .env file is configured
- [ ] Systemd service is enabled
- [ ] Application is running

## Web Server Setup
- [ ] Nginx is installed and configured
- [ ] Site configuration is enabled
- [ ] Nginx configuration is valid
- [ ] Nginx is reloaded

## SSL Setup
- [ ] Install Certbot
- [ ] Obtain SSL certificate
- [ ] Configure automatic renewal
- [ ] Test HTTPS access

## Testing
- [ ] API responds to requests
- [ ] Documentation is accessible
- [ ] Database operations work
- [ ] Authentication works
- [ ] CORS is configured correctly

## Post-Deployment
- [ ] Update Flutter app API URL
- [ ] Test mobile app connection
- [ ] Monitor logs and performance
- [ ] Setup monitoring and alerts
- [ ] Configure backups

## Security
- [ ] Firewall is configured
- [ ] SSH key authentication is enabled
- [ ] Root login is disabled
- [ ] Regular security updates
- [ ] Monitor access logs

---
**Check each item as you complete it! ✅**
EOF

    print_success "VPS deployment checklist created: VPS_DEPLOYMENT_CHECKLIST.md"
}

# Create SSH connection guide
create_ssh_guide() {
    print_status "Creating SSH connection guide..."
    
    cat > build_vps/SSH_CONNECTION_GUIDE.md << EOF
# 🔐 SSH Connection Guide

## Connect to Your VPS

### 1. Get VPS Details
- **IP Address**: $VPS_IP
- **Username**: root
- **Password**: (provided by Hostinger)

### 2. Connect via SSH
\`\`\`bash
ssh root@$VPS_IP
\`\`\`

### 3. Upload Files
From your local machine:
\`\`\`bash
# Upload deployment package
scp ${APP_NAME}_vps_deployment_*.zip root@$VPS_IP:/tmp/

# Or upload individual files
scp -r build_vps/* root@$VPS_IP:/var/www/habit-tracker/
\`\`\`

### 4. Extract and Deploy
On the VPS:
\`\`\`bash
cd /var/www/habit-tracker
unzip /tmp/${APP_NAME}_vps_deployment_*.zip
chmod +x deploy_on_vps.sh
./deploy_on_vps.sh
\`\`\`

## Troubleshooting

### Connection Issues
- Verify VPS IP address
- Check if VPS is running
- Ensure SSH is enabled
- Try different SSH clients

### Permission Issues
\`\`\`bash
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
\`\`\`

### File Upload Issues
- Check disk space: \`df -h\`
- Check file permissions
- Use SFTP if SCP fails

---
**Keep your VPS credentials secure! 🔒**
EOF

    print_success "SSH connection guide created: SSH_CONNECTION_GUIDE.md"
}

# Main deployment process
main() {
    echo "🚀 ========================================="
    echo "   Habit Tracker API - Hostinger VPS Deployment"
    echo "========================================="
    echo
    
    # Update configuration with user input
    echo -e "${YELLOW}Please provide the following information:${NC}"
    read -p "Enter your domain (e.g., myapp.com): " DOMAIN
    read -p "Enter VPS IP address: " VPS_IP
    read -p "Enter database name [habit_tracker_db]: " DB_NAME
    DB_NAME=${DB_NAME:-habit_tracker_db}
    read -p "Enter database user [habit_user]: " DB_USER
    DB_USER=${DB_USER:-habit_user}
    read -s -p "Enter database password: " DB_PASSWORD
    echo
    
    # Update configuration files with user input
    sed -i "s/your-domain.com/$DOMAIN/g" build_vps/nginx-site
    sed -i "s/your-domain.com/$DOMAIN/g" build_vps/.env.template
    sed -i "s/your_password/$DB_PASSWORD/g" build_vps/deploy_on_vps.sh
    
    check_requirements
    create_build
    generate_secret_key
    create_checklist
    create_ssh_guide
    create_package
    
    echo
    echo "🎉 ========================================="
    echo "   VPS Deployment package ready!"
    echo "========================================="
    echo
    echo "📦 Package: $PACKAGE_NAME"
    echo "📁 Build directory: build_vps/"
    echo
    echo "📋 Next steps:"
    echo "1. Upload files to your VPS"
    echo "2. Follow VPS_DEPLOYMENT_CHECKLIST.md"
    echo "3. Run deploy_on_vps.sh script"
    echo "4. Configure environment variables"
    echo "5. Test your API"
    echo
    echo "🌐 Your API will be available at:"
    echo "   http://$DOMAIN (after DNS setup)"
    echo "   http://$DOMAIN/docs"
    echo
    echo "📚 For detailed instructions, see:"
    echo "   build_vps/VPS_DEPLOYMENT_CHECKLIST.md"
    echo "   build_vps/SSH_CONNECTION_GUIDE.md"
    echo
    print_success "VPS deployment preparation complete!"
}

# Run main function
main "$@"
