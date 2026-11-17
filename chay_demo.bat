@echo off
title Smart Warehouse - Live MySQL Demo
chcp 65001 >nul
cd /d "%~dp0"

echo ====================================================================
echo    HE THONG SAN TMDT & KHO THONG MINH - DEMO KET NOI MYSQL
echo ====================================================================
echo.

echo [1/3] Kiem tra thu vien pymysql...
python -c "import pymysql" 2>nul
if errorlevel 1 (
    echo Chua co pymysql, dang cai dat...
    python -m pip install pymysql
)

echo [2/3] Kiem tra MySQL / database...
echo     Hay chac chan MySQL trong XAMPP da duoc Start.
echo.
echo [3/3] Khoi dong server tai http://localhost:8080 ...
python server.py
pause
