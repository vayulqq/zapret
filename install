# URL ZIP-файла
$url = "https://github.com/vayulqq/zapret/releases/download/qedqedndndn/zapret.zip"

# Получаем пути к папке загрузок и рабочему столу для текущего пользователя
$userProfilePath = [System.Environment]::GetFolderPath("UserProfile")
$downloadsPath = Join-Path -Path $userProfilePath -ChildPath "Downloads"
$desktopPath = Join-Path -Path $userProfilePath -ChildPath "Desktop"

# Локальный путь для сохранения ZIP-файла в папке Загрузки
$zipPath = Join-Path -Path $downloadsPath -ChildPath "zapret.zip"
$logFilePath = Join-Path -Path $desktopPath -ChildPath "download_log.txt"

# Функция для логирования
Function Log-Message {
    param (
        [string]$message
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $message" | Out-File -FilePath $logFilePath -Append
    Write-Host $message  # Также выводим в консоль
}

# Функция для скачивания файла с повторной попыткой
Function Download-File {
    param (
        [string]$url,
        [string]$savePath
    )
    $attempts = 3
    $success = $false
    Log-Message "Скачивание файла началось..."

    for ($i = 1; $i -le $attempts; $i++) {
        try {
            # Проверка доступности URL перед скачиванием
            $response = Invoke-WebRequest -Uri $url -Method Head -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Invoke-WebRequest -Uri $url -OutFile $savePath -ErrorAction Stop
                Log-Message "Файл успешно скачан: $savePath"
                $success = $true
                break
            } else {
                Log-Message "Ошибка: Файл не найден на сервере. Статус: $($response.StatusCode)"
                exit 1
            }
        } catch {
            Log-Message "Попытка $i из $attempts: Ошибка при скачивании файла: $_"
            if ($i -eq $attempts) {
                Log-Message "Все попытки скачивания завершились неудачей."
                exit 1
            }
        }
        Start-Sleep -Seconds (2 * $i)  # Увеличиваем задержку между попытками
    }
}

# Функция для распаковки файла
Function Unpack-Zip {
    param (
        [string]$filePath,
        [string]$extractTo
    )
    Log-Message "Распаковка файла..."
    try {
        # Используем System.IO.Compression.ZipFile для распаковки
        [System.IO.Compression.ZipFile]::ExtractToDirectory($filePath, $extractTo)
        Log-Message "Файлы успешно распакованы в папку: $extractTo"
        Remove-Item -Path $filePath -Force
        Log-Message "ZIP-файл удален."
    } catch {
        Log-Message "Ошибка при распаковке файла: $_"
        exit 1
    }
}

# Проверка и создание папки загрузок, если она не существует
If (-Not (Test-Path $downloadsPath)) {
    Log-Message "Папка загрузок не существует. Создаю её..."
    New-Item -ItemType Directory -Path $downloadsPath | Out-Null
} else {
    Log-Message "Папка загрузок существует: $downloadsPath"
}

# Проверка существования папки рабочего стола
If (-Not (Test-Path $desktopPath)) {
    Log-Message "Папка рабочего стола не существует. Создаю её..."
    New-Item -ItemType Directory -Path $desktopPath | Out-Null
} else {
    Log-Message "Папка рабочего стола существует: $desktopPath"
}

# Основной процесс
try {
    Log-Message "Рабочая платформа: $($env:OS)"
    
    # Скачиваем файл
    Download-File -url $url -savePath $zipPath
    
    # Распаковываем файл на рабочий стол
    Unpack-Zip -filePath $zipPath -extractTo $desktopPath
} catch {
    Log-Message "Произошла ошибка: $_"
}
