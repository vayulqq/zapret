# Функция для логирования
Function Log-Message {
    param ([string]$message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $message" | Out-File -FilePath $logFilePath -Append
    Write-Host $message
}

# Функция для скачивания файла
Function Download-File {
    param ([string]$url, [string]$savePath)
    try {
        Invoke-WebRequest -Uri $url -OutFile $savePath -ErrorAction Stop
        Log-Message "Файл успешно скачан: $savePath"
    } catch {
        Log-Message "Ошибка при скачивании файла: $_"
        exit 1
    }
}

# Функция для распаковки ZIP-файла
Function Unpack-Zip {
    param ([string]$filePath, [string]$extractTo)
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($filePath, $extractTo)
        Log-Message "Файлы успешно распакованы в папку: $extractTo"
    } catch {
        Log-Message "Ошибка при распаковке файла: $_"
        exit 1
    }
}

# Основной процесс
try {
    Log-Message "Начало работы скрипта."
    
    # Скачивание файла
    Download-File -url $url -savePath $zipPath
    
    # Распаковка
    Unpack-Zip -filePath $zipPath -extractTo $desktopPath
} catch {
    Log-Message "Общая ошибка: $_"
}
