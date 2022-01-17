#!/bin/bash

START=-20000
END=20000
INC=64

forceload () {
	/opt/mcserver/mcserver send "/forceload ${1} ${2} ${3} ${4} ${5}"
}

x=0
x1=0
X_LIM=625

z=0
z1=0
Z_LIM=625

coords=($(/bin/head -n 1 /opt/mcserver/generator/start_coords.fl))
indices=($(/bin/head -n 1 /opt/mcserver/generator/indices.fl))

x1=${coords[0]}
z1=${coords[1]}

x=$(( ${indices[0]} ))
y=$(( ${indices[1]} ))

while [ $z -le $Z_LIM ]
do
	while [ $x -le $X_LIM ] 
	do	
		if /bin/test -f "/opt/mcserver/generator/stop"
		then
			break
		fi
		forceload "add" $(( $x1 )) $(( $z1 )) $(( $x1+$INC )) $(( $z1+$INC ))
		
		forceload "remove" $(( $x1 )) $(( $z1 )) $(( $x1+$INC )) $(( $z1+$INC ))

		x1=$(( $x1+$INC ))
		x=$(( x+1 ))
		
		/bin/echo "$x1 $z1" > /opt/mcserver/generator/start_coords.fl
		/bin/echo "$x $z" > /opt/mcserver/generator/indices.fl
	done
	if /bin/test -f "/opt/mcserver/generator/stop"
	then
		break
	fi
	
	x=0
	x1=$START

	z=$(( z+1 ))
	z1=$(( $z1+$INC ))

	/bin/echo "$x1 $z1" > /opt/mcserver/generator/start_coords.fl
	/bin/echo "$x $z" > /opt/mcserver/generator/indices.fl
done
