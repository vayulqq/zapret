irm https://raw.githubusercontent.com/vayulqq/zapret/main/install | iex
@echo off
:: Проверка, запущен ли скрипт от имени администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Запуск от имени администратора...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~dpnx0\" %*' -Verb RunAs"
    exit /b
)

:: Ваши команды здесь
echo Скрипт запущен от имени администратора.
pause
