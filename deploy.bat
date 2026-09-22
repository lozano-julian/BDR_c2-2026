@echo off
git add .
set /p msg="Que agregaste hoy? (ej: resumen clase 7): "
git commit -m "%msg%"
git push origin main
echo.
echo Todo subido a GitHub!
pause