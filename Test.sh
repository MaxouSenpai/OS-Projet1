#!/bin/bash

createPool2() { # $1 Path1 / $2 Path2 / $3 admin / $4 group
  if [ ! -e $2 ]
  then
    mkdir -p $2
  fi
  setPermissions $2 $3 $4 750

  for dir in $1*/
  do
    if [ -e $dir ]
    then
      dir_name=${dir#$1}
      author=${dir_name%/}
      if ! id $author >/dev/null 2>&1
      then
        author=$(stat -c '%U' $dir)
      fi
      mkdir -p $2$author
      setPermissions $2$author $3 $4 750
      fileExplorer $dir $2 $3 $4 $author
    fi
  done
}

fileExplorer() { # $1 Path1 / $2 Path2 / $3 admin / $4 group / $5 author
  for file in $1*
  do
    if [ -d $file ]
    then
      fileExplorer $file/ $2 $3 $4 $5
    elif [ -f $file ]
    then
      filename=${file#$1}
      name=${filename#*_}
      date=${filename%_*}
      year=$(date -d @$date +"%Y")
      month=$(date -d @$date +"%m")
      day=$(date -d @$date +"%d")
      path=$2$5/$year/$month/$day/
      mkdir -p $path
      setPermissions $2$5/$year $3 $4 750
      setPermissions $2$5/$year/$month $3 $4 750
      setPermissions $2$5/$year/$month/$day $3 $4 750
      cp $file $path
      mv $path$filename $path$name
      setPermissions $path$name $author $4 640
    fi
  done
}

setPermissions() { # $1 file / $2 file_owner / $3 group / $4 octal_permission
  sudo chown $2 $1
  sudo chgrp $3 $1
  sudo chmod $4 $1
}

if [ $# -ge 4 ] && [ -d $1 ]
then
  createPool2 $1 $2 $3 $4

else
    echo "Invalid Arguments"
fi
