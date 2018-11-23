#!/bin/bash

run() {
  if [ ! -e $2 ]
  then
    mkdir -p $2
  fi

  for dir in $1*/
  do
    if [ -e $dir ]
    then
      dir_name=${dir#$1}
      author=${dir_name%/}
      if id $author >/dev/null 2>&1
      then
        fileExplorer $dir $2 $3 $4 $author
      else
        fileExplorer $dir $2 $3 $4 $USER
      fi
    fi
  done
}

fileExplorer() {
  for file in $1*
  do
    if [ -d $file ]
    then
      run $file/ $2 $3 $4

    elif [ -f $file ]
    then
      filename=${file#$1}
      #user=$(stat -c '%U' $file)
      name=${filename#*_}
      date=$(date -d @${filename%_*} +"%Y/%m/%d")
      path=$2$5/$date/
      mkdir -p $path
      cp $file $path
      mv $path$filename $path$name
    fi
  done
}

if [ $# -ge 4 ] && [ -d $1 ]
then
  run $1 $2 $3 $4
else
    echo "No"
fi
