@echo off
echo 🚀 Committing Railway files to git...

git add .
echo ✅ Files added to git

git commit -m "Add Railway deployment files - fix deployment"
echo ✅ Files committed

git push origin master
echo ✅ Files pushed to GitHub

echo.
echo 🎉 Successfully committed and pushed Railway files!
echo 🎯 Now go to Railway and redeploy your project!
pause
