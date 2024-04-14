#!/usr/bin/env bash

if [ ! -d "dracula" ]; then
  mkdir dracula
fi
if [ ! -d "dracula/anime" ]; then
  mkdir dracula/anime
fi

if [ ! -d "frappe" ]; then
  mkdir frappe
fi
if [ ! -d "frappe/anime" ]; then
  mkdir frappe/anime
fi

if [ ! -d "latte" ]; then
  mkdir latte
fi
if [ ! -d "latte/anime" ]; then
  mkdir latte/anime
fi

echo "---------------------------------------"
echo "Running LUT generator to generate LUTs"
echo "---------------------------------------"
lutgen generate -p dracula -a shepards-method --power 12 --lum 0.5 --preserve -n 256 --level 20 -o .tmp_dracula_lut.png
lutgen generate -p catppuccin-frappe -a shepards-method --power 12 --lum 0.5 --preserve -n 256 --level 20 -o .tmp_frappe_lut.png
lutgen generate -p catppuccin-latte -a shepards-method --power 12  --lum 0.5 --preserve -n 256 --level 20 -o .tmp_latte_lut.png

echo "---------------------------------------"
echo "Applying LUTs to images"
echo "---------------------------------------"
for file in originals/*.{jpg,png} originals/anime/*.{jpg,png}
do
  if [ -f "$file" ]; then
    if [ "$(dirname "$file")" = "originals/anime" ]; then
      out_path="anime/"
    else 
      out_path=""
    fi

    if [ ! -f "dracula/$out_path$(basename "${file%.*}").png" ]; then
      lutgen apply --hald-clut ".tmp_dracula_lut.png" "$file" -o "dracula/$out_path$(basename "${file%.*}").png"
    else 
      echo "Skipped file: $(basename "$file") as it already existed"
    fi

    if [ ! -f "frappe/$out_path$(basename "${file%.*}").png" ]; then
      lutgen apply --hald-clut ".tmp_frappe_lut.png" "$file" -o "frappe/$out_path$(basename "${file%.*}").png"
    else 
      echo "Skipped file: $(basename "$file") as it already existed"
    fi

    if [ ! -f "latte/$out_path$(basename "${file%.*}").png" ]; then
      lutgen apply --hald-clut ".tmp_latte_lut.png" "$file" -o "latte/$out_path$(basename "${file%.*}").png"
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
