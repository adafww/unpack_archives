#!/bin/bash

# Спрашиваем директорию с архивами
read -p "Введите путь к директории с архивами: " archive_dir
# Спрашиваем название папки для распаковки
read -p "Введите название папки для распаковки: " output_dir

# Проверяем, существует ли директория с архивами
if [ ! -d "$archive_dir" ]; then
  echo "Директория $archive_dir не существует!"
  exit 1
fi

# Создаём папку для распаковки рядом со скриптом
mkdir -p "$output_dir"

# Получаем список всех zip и rar архивов в директории
archives=("$archive_dir"/*.zip "$archive_dir"/*.rar)
total_archives=${#archives[@]}
processed_archives=0

# Проверяем, есть ли архивы
if [ $total_archives -eq 0 ]; then
  echo "Нет zip или rar архивов в директории $archive_dir"
  exit 1
fi

# Функция для обновления прогресса
update_progress() {
  local current=$1
  local total=$2
  local percent=$((current * 100 / total))
  echo -ne "Прогресс: $percent% ( $current / $total )\r"
}

# Обработка каждого архива
for archive in "${archives[@]}"; do
  if [ -f "$archive" ]; then
    archive_name=$(basename "$archive")
    folder_name="${archive_name%.*}"
    mkdir -p "$output_dir/$folder_name"
    
    case "$archive" in
      *.zip)
        unzip -q "$archive" -d "$output_dir/$folder_name"
        ;;
      *.rar)
        unrar x -inul "$archive" "$output_dir/$folder_name/"
        ;;
      *)
        echo "Неизвестный тип архива: $archive"
        ;;
    esac

    processed_archives=$((processed_archives + 1))
    update_progress $processed_archives $total_archives
  fi
done

echo -e "\nРаспаковка завершена!"
