#!/bin/bash

DIR=/opt/mcserver

X_ORIGIN=-20000
X_RESET=523
X_INC=190
X_LIM=211

Y_ORIGIN=150
Y_RESET=80

Z_ORIGIN=-20000
Z_RESET=-279
Z_INC=190
Z_LIM=211

USERNAME="RedwardFlip"

gamemode () {
	/opt/mcserver/mcserver send "/gamemode ${1} ${2}"
}

tp () {
	/opt/mcserver/mcserver send "/tp ${1} ${2} ${3} ${4}"
}

username="RedwardFlip"

x=0
x_coord=0

y_coord=150

z=0
z_coord=0

coords=($(/bin/head -n 1 /opt/mcserver/generator/start_coords))
indices=($(/bin/head -n 1 /opt/mcserver/generator/indices))

x_coord=${coords[0]}
y_coord=${coords[1]}
z_coord=${coords[2]}

x=$(( ${indices[0]} ))
y=$(( ${indices[1]} ))

gamemode "spectator" $USERNAME

while [ $z -le $Z_LIM ]
do
	while [ $x -le $X_LIM ]
	do
		if /bin/test -f "/opt/mcserver/generator/stop"
		then
			break
		fi
		tp $USERNAME $x_coord $y_coord $z_coord
		/bin/sleep 5s

		x_coord=$(( $x_coord+$X_INC ))
		x=$(( x+1 ))
		/bin/echo "$x_coord $y_coord $z_coord" > /opt/mcserver/generator/start_coords
		/bin/echo "$x $z" > /opt/mcserver/generator/indices
	done
	if /bin/test -f "/opt/mcserver/generator/stop"
	then
		break
	fi
	
	x=0
	x_coord=$X_ORIGIN
	
	z_coord=$(( $z_coord+$Z_INC ))
	z=$(( z+1 ))

	/bin/echo "$x_coord $y_coord $z_coord" > /opt/mcserver/generator/start_coords
	/bin/echo "$x $z" > /opt/mcserver/generator/indices
done

tp $USERNAME $X_RESET $Y_RESET $Z_RESET

gamemode "survival" $USERNAME

