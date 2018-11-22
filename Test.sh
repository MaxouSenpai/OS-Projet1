#!/bin/bash

run() {
  for file in $1*
  do
    if [ -d $file ]
    then
      run $file/ $2 $3 $4

    elif [ -f $file ]
    then
      filename=${file#$1}
      user=$(stat -c '%U' $file)
      name=${filename#*_}
      date=$(date -d @${filename%_*} +"%Y/%m/%d")
      path=$2$user/$date/
      mkdir -p $path
      cp $file $path
      mv $path$filename $path$name
    fi
  done
}

if [ $# -lt 4 ] ; then
  echo "Pas assez d'arguments"
else
run $1 $2 $3 $4
fi
