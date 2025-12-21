#!/usr/bin/env bash

dir=/disk/Data/Wallpapers/
rofi="rofi -show -dmenu -theme ${HOME}/.config/rofi/wallpaper-selector.rasi"

wallpapers=($(find -L "${dir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort ))

random_number=$(( ($(date +%s) + RANDOM) + $$ ))
random_picture="${wallpapers[$(( random_number % ${#wallpapers[@]} ))]}"
random_choice="[${#wallpapers[@]}] Random"

images_view () {
  printf "$random_choice\n"
  for i in "${!wallpapers[@]}"; do
    if [[ -z $(echo "${wallpapers[$i]}" | grep .gif$) ]]; then
      printf "$(basename "${wallpapers[$i]}" | cut -d. -f1)\x00icon\x1f${wallpapers[$i]}\n"
    else
      printf "$(basename "${wallpapers[$i]}")\n"
    fi
  done
}

selector() {
  choice=$(images_view | ${rofi})

  if [[ -z $choice ]]; then
    exit 0
  fi

  if [ "$choice" = "$random_choice" ]; then
    change "${random_picture}"
    return 0
  fi

  for file in "${wallpapers[@]}"; do
    if [[ "$(basename "$file" | cut -d. -f1)" = "$choice" ]]; then
      selected_file="$file"
      break
    fi
  done

  if [[ -n "$selected_file" ]]; then
    change "${selected_file}"
    return 0
  else
    echo "Image not found."
    exit 1
  fi
}

pywal_gen () {
    ## --cols16 {lighten | darken}
    wal --cols16 lighten -s -i $1 \
      --theme ~/.config/wal/colorschemes/dark/catppuccin-gruvbox-material.json
    # wal --cols16 lighten -s -i $1 #--theme gruvbox

    cp -f "${HOME}"/.cache/wal/pywal.json "${HOME}"/.config/presets/user/pywal.json

    mkdir -p "${HOME}"/.config/Kvantum/pywal
    cp "${HOME}"/.cache/wal/pywal.kvconfig "${HOME}"/.config/Kvantum/pywal/pywal.kvconfig
    cp "${HOME}"/.cache/wal/pywal.svg "${HOME}"/.config/Kvantum/pywal/pywal.svg

    gradience-cli apply --gtk both -n pywal

    echo "@import url(\"file://$(nix eval -f '<nixpkgs>'\
      --raw adw-gtk3)/share/themes/adw-gtk3-dark/gtk-4.0/gtk-dark.css\");"\
      | cat - ~/.config/gtk-4.0/gtk.css > temp && mv temp ~/.config/gtk-4.0/gtk.css
}

hyprpaper () {
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $1
    hyprctl hyprpaper wallpaper ", $1"
    printf "preload = $1\nwallpaper = , $1" > ~/.config/hypr/hyprpaper.conf
}


change () {
    # pywal_gen $1
    hyprpaper $1

    # killall .waybar-wrapped
    # sleep 0.1
    # waybar &
    # swaync-client -rs
}

case "$1" in
  "--selector") selector
  ;;
  *) change "${random_picture}"
  ;;
esac
