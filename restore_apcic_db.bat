@echo off
SETLOCAL

REM ===== CONFIG =====
set PG_BIN="C:\Program Files\PostgreSQL\17\bin"
set DB_NAME=apcic_db
set DB_USER=postgres
set BACKUP_FILE=%USERPROFILE%\Desktop\apcic_db_bkup.sql

echo.
echo ================================
echo   APCIC DATABASE RESTORE TOOL
echo ================================
echo.

echo [1/5] Checking PostgreSQL tools...
if not exist %PG_BIN%\psql.exe (
    echo ERROR: psql not found in %PG_BIN%
    pause
    exit /b
)

echo [2/5] Dropping database if it exists...
%PG_BIN%\dropdb.exe -U %DB_USER% %DB_NAME% 2>nul

echo [3/5] Creating fresh database...
%PG_BIN%\createdb.exe -U %DB_USER% %DB_NAME%
if errorlevel 1 (
    echo Failed to create database.
    pause
    exit /b
)

echo [4/5] Ensuring role "thomas" exists...
%PG_BIN%\psql.exe -U %DB_USER% -d postgres -c "DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'thomas') THEN CREATE ROLE thomas WITH LOGIN PASSWORD '1234'; END IF; END $$;"

echo [5/5] Restoring backup... (please wait)
%PG_BIN%\psql.exe -U %DB_USER% -d %DB_NAME% -f "%BACKUP_FILE%"

echo.
echo ================================
echo   RESTORE PROCESS COMPLETED
echo ================================
echo.

pause
ENDLOCAL
