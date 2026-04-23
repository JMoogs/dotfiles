#!/usr/bin/env bash

mkdir -p dracula/anime frappe/anime latte/anime

echo "---------------------------------------"
echo "Running LUT generator to generate a dracula LUT"
echo "---------------------------------------"
lutgen generate -p dracula -o .tmp_dracula_lut.png

echo "---------------------------------------"
echo "Running LUT generator to generate a catppuccin-frappe LUT"
echo "---------------------------------------"
lutgen generate -p catppuccin-frappe -o .tmp_frappe_lut.png

echo "---------------------------------------"
echo "Running LUT generator to generate a catppuccin-latte LUT"
echo "---------------------------------------"
lutgen generate -p catppuccin-latte -o .tmp_latte_lut.png

for file in originals/*.{jpg,png} originals/anime/*.{jpg,png}
do
  if [ -f "$file" ]; then
    if [ "$(dirname "$file")" = "originals/anime" ]; then
      out_path="anime/"
    else 
      out_path=""
    fi

    echo "---------------------------------------"
    echo "Running LUT generator to convert "$(basename "$file")" to dracula theme:"
    echo "---------------------------------------"

    if [ ! -f "dracula/$out_path$(basename "${file%.*}").png" ]; then
      lutgen apply -p dracula "$file" -o "dracula/$out_path$(basename "${file%.*}").png"
    else 
      echo "Skipped file: $(basename "$file") as it already existed"
    fi

    echo "---------------------------------------"
    echo "Running LUT generator to convert "$(basename "$file")" to catppuccin-frappe theme:"
    echo "---------------------------------------"

    if [ ! -f "frappe/$out_path$(basename "${file%.*}").png" ]; then
      lutgen apply -p catppuccin-frappe "$file" -o "frappe/$out_path$(basename "${file%.*}").png"
    else 
      echo "Skipped file: $(basename "$file") as it already existed"
    fi

    echo "---------------------------------------"
    echo "Running LUT generator to convert "$(basename "$file")" to catppuccin-latte theme:"
    echo "---------------------------------------"

    if [ ! -f "latte/$out_path$(basename "${file%.*}").png" ]; then
      lutgen apply -p catppuccin-latte "$file" -o "latte/$out_path$(basename "${file%.*}").png"
    else 
      echo "Skipped file: $(basename "$file") as it already existed"
    fi
  fi
done

echo "---------------------------------------"
echo "Removing temporary files"
echo "---------------------------------------"
rm .tmp_dracula_lut.png
rm .tmp_frappe_lut.png
rm .tmp_latte_lut.png

echo "---------------------------------------"
echo "Finished generating wallpapers"
echo "---------------------------------------"
