#!/bin/bash

# Usamos tput (permite poner colores y/o mover el cursor por la pantalla) 
LINEAS=$(tput lines)
COLUMNAS=$(tput cols)
 
# Lo declaramos como Array
declare -A CopoDeNieve
declare -A UltimosCopos

# Funcion que mueve el copo por la pantalla (cayendo) 
function mover_copo() {
	i="$1"
	if [ "${CopoDeNieve[$i]}" = "" ] || [ "${CopoDeNieve[$i]}" = "$LINEAS" ]; then
		CopoDeNieve[$i]=0
	else
		if [ "${UltimosCopos[$i]}" != "" ]; then
			printf "\033[%s;%sH \033[1;1H " ${UltimosCopos[$i]} $i
		fi
	fi
	printf "\033[%s;%sH*\033[1;1H" ${CopoDeNieve[$i]} $i
	UltimosCopos[$i]=${CopoDeNieve[$i]}
	CopoDeNieve[$i]=$((${CopoDeNieve[$i]}+1))
}


function arbol() {
  lin=2
  col=$(($(tput cols) / 2))
  # Arbol 
  for ((i=1; i<20; i+=2))
  {
    tput cup $lin $col
    for ((j=1; j<=i; j++))
    {
        echo -n \*
    }
    let lin++
    let col--
  }
  tput sgr0; tput setaf 3
  # Tronco
  for ((i=1; i<=2; i++))
  {
    tput cup $((lin++)) $c
    echo 'mWm'
  }
}


trap "tput reset; tput cnorm; exit" 2
#Limpiamos antes de comenzar la nevada...
clear

tput civis
lin=2
col=$(($(tput cols) / 2))
c=$((col-1))
est=$((c-2))
color=0
tput setaf 2; tput bold
arbol

nuevo_agno=$(date +'%Y')
let nuevo_agno++
tput setaf 1; tput bold
tput cup $lin $((c - 6)); echo FELIZ $nuevo_agno
tput cup $((lin + 1)) $((c - 10)); echo luisgulo 
let c++
k=1

# Lights and decorations
while true; do
    for ((i=1; i<=35; i++)) {
        # Turn off the lights
        [ $k -gt 1 ] && {
            tput setaf 2; tput bold
            tput cup ${line[$[k-1]$i]} ${column[$[k-1]$i]}; echo \*
            unset line[$[k-1]$i]; unset column[$[k-1]$i]  # Array cleanup
        }

        li=$((RANDOM % 9 + 3))
        start=$((c-li+2))
        co=$((RANDOM % (li-2) * 2 + 1 + start))
        tput setaf $color; tput bold   # Switch colors
        tput cup $li $co
        echo o
        line[$k$i]=$li
        column[$k$i]=$co
        color=$(((color+1)%8))

        # Codigo para hacer nevar.
	      # la variable del sistema $RANDOM devuelve un valor aleatorio :-D
	      copo=$(($RANDOM % $COLUMNAS))
	      mover_copo $copo
	      for x in "${!UltimosCopos[@]}"
	      do
		      mover_copo "$x"
	      done
	      sleep 0.1

        # Flashing text
        sh=1
        for l in s o l o c o n l i n u x 
        do
            tput cup $((lin+1)) $((c+sh))
            echo $l
            let sh++
            sleep 0.01
        done
    }
    k=$((k % 2 + 1))
    arbol
done

