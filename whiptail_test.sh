value=("Choice1" "" on "Choice2" "" off "Choice3" "" off)

whiptail --title "xx" --checklist "choose" 16 78 10 "${value[@]}"
