#!/usr/bin/env bash
# Reset terminal on exit
trap 'tput cnorm; tput sgr0; clear' EXIT

# invisible cursor, no echo
tput civis
stty -echo
max_x=$(($(tput cols) - ${#text}))
max_y=$(($(tput lines) - ${#text}))
text=`echo $skin | cut -c1`
textB=`echo $skin | cut -c2`
textA=`echo $skin | cut -c3`
dir=1 x=$(($max_x / 2)) y=$max_y
#color=`echo $(($RANDOM%9))`
color=2
num=`echo $(($RANDOM%9))`
text1="$num"
dira=1 xa=`echo $(($RANDOM%$max_x))` ya=1
vidas="$vidasN1"
vidasD="$vidasN2"
puntos="$puntosN"
guardar=0

while sleep 0.1 # GNU specific!
do
  max_x=$(($(tput cols) - ${#text}))
  max_y=$(($(tput lines) - ${#text}))
  x1=$(($x + 1))
  x2=$(($x + 2))
    # move and change direction when hitting walls
    (( ya == 0 || ya == max_y )) && \
        ((dira *= -1))
    (( ya += dira ))
    if [ $ya -eq $max_y ];
    then
      if [[ $xa -eq $x ]];
      then
        puntos=$(($puntos + $num))
        xa=`echo $(($RANDOM%$max_x))`
        ya=1
        num=`echo $(($RANDOM%5))`
        text1="$num"
      elif [[ $xa -eq $x1 ]];
      then
        puntos=$(($puntos + $num))
        xa=`echo $(($RANDOM%$max_x))`
        ya=1
        num=`echo $(($RANDOM%5))`
        text1="$num"
      elif [[ $xa -eq $x2 ]];
      then
        puntos=$(($puntos + $num))
        xa=`echo $(($RANDOM%$max_x))`
        ya=1
        num=`echo $(($RANDOM%5))`
        text1="$num"
      else
        ya=1
        xa=`echo $(($RANDOM%$max_x))`
        vidas=$(($vidas -1))
        num=`echo $(($RANDOM%5))`
        text1="$num"
        if [ $vidas -eq 2 ];
        then
          vidasD="<3 <3"
        elif [ $vidas -eq 1 ];
        then
          vidasD="<3"
        elif [ $vidas -eq 0 ];
        then
          printf "%s" "    GAME OVER"
          vidasD="  "
          tput cup "1" "1"
          printf "%s" "Vidas: $vidasD"
          sleep 2
          tput cnorm
          stty echo
          break
          #vidas=3
          #vidasD="<3 <3 <3"
          #puntos=0
          x=$(($max_x / 2))
          /usr/bin/resize -s 24 80
        fi
        if [[ $xa -eq "0" ]];
        then
          xa=1
        fi
      fi
      if [ $puntos -le 10 ];
        then
          /usr/bin/resize -s 26 56
        elif [ $puntos -le 20 ];
        then
          /usr/bin/resize -s 26 65
        elif [ $puntos -le 30 ];
        then
          /usr/bin/resize -s 26 75
        elif [ $puntos -le 40 ];
        then
          /usr/bin/resize -s 26 80
        elif [ $puntos -le 50 ];
        then
          /usr/bin/resize -s 26 100
        elif [ $puntos -gt 50 ];
        then
          /usr/bin/resize -s 26 140
      fi
    fi

    # read all the characters that have been buffered up
    while IFS= read -rs -t 0.0001 -n 1 key
    do
        [[ $key == d ]] && (( x++ ))
        [[ $key == a ]] && (( x-- ))
        [[ $key == g ]] && guardar=1
    done
    if [[ $guardar -eq 1 ]];
    then
      tput cnorm
      stty echo
      break
    fi

    # batch up all terminal output for smoother action
    framebuffer=$(
        clear
        tput cup "$y" "$x"
        tput setaf "$color"
        printf "%s%s%s" "$text" "$textA" "$textB"
        tput cup "$ya" "$xa"
        tput setaf "$color"
        printf "%s" "$text1"
        tput cup "1" "1"
        printf "%s" "Vidas: $vidasD"
        tput cup "1" "20"
        printf "%s" "Puntuación: $puntos"
    )
    # dump to screen
    printf "%s" "$framebuffer"
done
