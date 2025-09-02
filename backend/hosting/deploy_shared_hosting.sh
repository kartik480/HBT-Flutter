#!/bin/bash

# 🚀 Habit Tracker API Deployment Script for Hostinger Shared Hosting
# This script helps deploy your API to Hostinger shared hosting

set -e  # Exit on any error

echo "🚀 Starting Habit Tracker API deployment to Hostinger..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="habit-tracker-api"
DOMAIN="your-domain.com"
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
    
    if ! command -v zip &> /dev/null; then
        print_error "zip command not found. Please install zip."
        exit 1
    fi
    
    if ! command -v curl &> /dev/null; then
        print_error "curl command not found. Please install curl."
        exit 1
    fi
    
    print_success "Requirements check passed!"
}

# Create production build
create_build() {
    print_status "Creating production build..."
    
    # Create build directory
    BUILD_DIR="build_production"
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

    # Create .htaccess for shared hosting
    cat > $BUILD_DIR/.htaccess << 'EOF'
RewriteEngine On

# Handle CORS preflight requests
RewriteCond %{REQUEST_METHOD} OPTIONS
RewriteRule ^(.*)$ $1 [R=200,L]

# Route all requests to main.py
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ main.py/$1 [QSA,L]

# Security headers
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"

# CORS headers
Header always set Access-Control-Allow-Origin "*"
Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With"
Header always set Access-Control-Max-Age "86400"
EOF

    # Create production requirements.txt
    cat > $BUILD_DIR/requirements_production.txt << 'EOF'
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
pymysql==1.1.0
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
pydantic==2.5.0
pydantic-settings==2.1.0
python-dotenv==1.0.0
EOF

    # Create deployment info
    cat > $BUILD_DIR/DEPLOYMENT_INFO.md << EOF
# 🚀 Habit Tracker API - Production Deployment

## Deployment Date
$(date)

## Configuration
- **Environment**: Production
- **Hosting**: Hostinger Shared Hosting
- **Database**: MySQL
- **Domain**: $DOMAIN

## Setup Instructions

### 1. Upload Files
Upload all files in this directory to your Hostinger hosting:
- Navigate to \`public_html\` folder
- Create a new folder called \`api\`
- Upload all files to the \`api\` folder

### 2. Create Database
In Hostinger cPanel:
- Go to MySQL Databases
- Create database: \`$DB_NAME\`
- Create user: \`$DB_USER\`
- Grant privileges to user on database

### 3. Configure Environment
Create \`.env\` file in the \`api\` folder:

\`\`\`bash
DATABASE_URL=mysql://$DB_USER:your_password@localhost:$DB_NAME
SECRET_KEY=your-super-secret-key-here
DEBUG=False
ENVIRONMENT=production
\`\`\`

### 4. Install Dependencies
In Hostinger cPanel:
- Go to Setup Python App
- Create Python app pointing to \`/api\` folder
- Install requirements: \`pip install -r requirements_production.txt\`

### 5. Test API
Visit: \`https://$DOMAIN/api/docs\`

## File Structure
\`\`\`
api/
├── app/                    # Application code
├── scripts/               # Database scripts
├── main.py                # Production entry point
├── requirements_production.txt  # Production dependencies
├── .htaccess              # Apache configuration
└── DEPLOYMENT_INFO.md     # This file
\`\`\`

## Support
If you encounter issues:
1. Check Hostinger error logs
2. Verify database connection
3. Check file permissions
4. Ensure Python app is configured correctly

---
**Happy Habit Tracking! 🎉**
EOF

    print_success "Production build created in $BUILD_DIR/"
}

# Create deployment package
create_package() {
    print_status "Creating deployment package..."
    
    PACKAGE_NAME="${APP_NAME}_deployment_$(date +%Y%m%d_%H%M%S).zip"
    
    cd build_production
    zip -r "../$PACKAGE_NAME" .
    cd ..
    
    print_success "Deployment package created: $PACKAGE_NAME"
}

# Generate environment template
generate_env_template() {
    print_status "Generating environment template..."
    
    cat > build_production/.env.template << EOF
# 🚀 Habit Tracker API - Production Environment Variables
# Copy this file to .env and fill in your values

# Database Configuration
DATABASE_URL=mysql://$DB_USER:your_password@localhost:$DB_NAME

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
ALLOWED_ORIGINS=https://$DOMAIN,https://www.$DOMAIN

# Email (optional)
SMTP_SERVER=mail.$DOMAIN
SMTP_PORT=587
SMTP_USERNAME=noreply@$DOMAIN
SMTP_PASSWORD=your-email-password

# Performance
MAX_CONNECTIONS=100
WORKER_PROCESSES=2
REQUEST_TIMEOUT=30
EOF

    print_success "Environment template created: .env.template"
}

# Generate secret key
generate_secret_key() {
    print_status "Generating secure secret key..."
    
    SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
    
    cat > build_production/SECRET_KEY.txt << EOF
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
    print_status "Creating deployment checklist..."
    
    cat > build_production/DEPLOYMENT_CHECKLIST.md << 'EOF'
# ✅ Deployment Checklist

## Pre-Deployment
- [ ] Test API locally
- [ ] Update domain in configuration
- [ ] Generate strong secret key
- [ ] Prepare database credentials

## Hostinger Setup
- [ ] Purchase hosting plan
- [ ] Access cPanel
- [ ] Create MySQL database
- [ ] Create database user
- [ ] Grant database privileges

## File Upload
- [ ] Create /api folder in public_html
- [ ] Upload all files to /api folder
- [ ] Set correct file permissions (755 for folders, 644 for files)
- [ ] Verify .htaccess is uploaded

## Python App Configuration
- [ ] Go to Setup Python App in cPanel
- [ ] Create new Python app
- [ ] Set app root to /api
- [ ] Choose Python 3.9 or 3.10
- [ ] Install requirements: pip install -r requirements_production.txt

## Environment Configuration
- [ ] Create .env file in /api folder
- [ ] Set DATABASE_URL with correct credentials
- [ ] Set SECRET_KEY to generated value
- [ ] Set DEBUG=False
- [ ] Set ENVIRONMENT=production

## Testing
- [ ] Test database connection
- [ ] Visit https://your-domain.com/api/docs
- [ ] Test API endpoints
- [ ] Check error logs if issues occur

## Post-Deployment
- [ ] Update Flutter app API base URL
- [ ] Test mobile app connection
- [ ] Monitor performance
- [ ] Setup monitoring and alerts

## Security
- [ ] Verify HTTPS is working
- [ ] Check CORS settings
- [ ] Validate authentication
- [ ] Test rate limiting

---
**Check each item as you complete it! ✅**
EOF

    print_success "Deployment checklist created: DEPLOYMENT_CHECKLIST.md"
}

# Main deployment process
main() {
    echo "🚀 ========================================="
    echo "   Habit Tracker API - Hostinger Deployment"
    echo "========================================="
    echo
    
    # Update configuration with user input
    echo -e "${YELLOW}Please provide the following information:${NC}"
    read -p "Enter your domain (e.g., myapp.com): " DOMAIN
    read -p "Enter database name [habit_tracker_db]: " DB_NAME
    DB_NAME=${DB_NAME:-habit_tracker_db}
    read -p "Enter database user [habit_user]: " DB_USER
    DB_USER=${DB_USER:-habit_user}
    read -s -p "Enter database password: " DB_PASSWORD
    echo
    
    # Update configuration files with user input
    sed -i "s/your-domain.com/$DOMAIN/g" build_production/DEPLOYMENT_INFO.md
    sed -i "s/your-domain.com/$DOMAIN/g" build_production/.env.template
    
    check_requirements
    create_build
    generate_env_template
    generate_secret_key
    create_checklist
    create_package
    
    echo
    echo "🎉 ========================================="
    echo "   Deployment package ready!"
    echo "========================================="
    echo
    echo "📦 Package: $PACKAGE_NAME"
    echo "📁 Build directory: build_production/"
    echo
    echo "📋 Next steps:"
    echo "1. Upload files to Hostinger"
    echo "2. Follow DEPLOYMENT_CHECKLIST.md"
    echo "3. Configure environment variables"
    echo "4. Test your API"
    echo
    echo "🌐 Your API will be available at:"
    echo "   https://$DOMAIN/api"
    echo "   https://$DOMAIN/api/docs"
    echo
    echo "📚 For detailed instructions, see:"
    echo "   build_production/DEPLOYMENT_INFO.md"
    echo
    print_success "Deployment preparation complete!"
}

# Run main function
main "$@"
