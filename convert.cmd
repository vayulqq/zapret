# Запрос конфигурации у пользователя
$config = Read-Host "Введите вашу конфигурацию"

# Функция для удаления путей и кавычек
function Remove-PathsAndQuotes {
    param (
        [string]$line
    )
    $line -replace '="\S+"', '='
}

# Функция для замены значений после удаления путей и кавычек
function ReplaceValues {
    param (
        [string]$line
    )
    $line -replace '--hostlist-auto=', '--hostlist-auto=\"%CD%\\..\\autohosts.txt\"' 
          -replace '--hostlist=', '--hostlist=\"%CD%\\..\\youtube.txt\"' 
          -replace '--ipset=', '--ipset=\"%CD%\\..\\autohosts.txt\"' 
          -replace '--dpi-desync-fake-tls=', '--dpi-desync-fake-tls="tls_clienthello_www_google_com.bin"' 
          -replace '--dpi-desync-fake-quic=', '--dpi-desync-fake-quic="quic_initial_www_google_com.bin"'
}

# Обработка каждой строки
$configArray = $config -split "n"
$newConfig = $configArray | ForEach-Object { 
    $_ = Remove-PathsAndQuotes $_
    ReplaceValues $_
}

# Вывод обновленной конфигурации
$newConfig -join "n"
