@echo off
:: Устанавливаем кодировку UTF-8 для правильного отображения русского текста
chcp 65001

:: Проверка, запущен ли скрипт с правами администратора
net session >nul 2>nul
if %errorlevel% neq 0 (
    echo Скрипт не запущен с правами администратора. Перезапускаем с правами администратора...
    :: Перезапуск скрипта с правами администратора
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /b
)

:: Включаем тестовый режим
bcdedit /set testsigning on

:: Отключаем отображение уведомлений о тестовом режиме
bcdedit /set bootstatuspolicy ignoreallfailures

:: Отключаем проверку подписи драйверов
bcdedit /set nointegritychecks on

:: Удаляем watermark тестового режима через реестр
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DisplayTestSign" /t REG_DWORD /d 0 /f

:: Информация для пользователя
echo Тестовый режим включен, уведомления о нем скрыты.
echo Проверка подписи драйверов отключена.
echo Компьютер будет перезагружен для применения изменений...

:: Перезагрузка системы
shutdown /r /t 0
