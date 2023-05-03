#!/bin/bash

cd 
ending=$(yad --form --title="select ending" --text="please write the ending of the files or directories that you want to backup" --field="The ending:" --separator='' --timeout=30 --timeout-indicator=right --width=400 --height=200)
destination=$(yad --form --title="select directory destination" --text="please write the name of the new backup directory destination" --field="The name of the new directory:" --separator='' --timeout=30 --timeout-indicator=right --width=400 --height=200)
mkdir $destination
cp *.$ending $destination
ls -l *.$ending > files 
echo "The files have been backed up"
answer=$(yad --form --title="how do you want to continue?" --text="do you want to backup more files or directories?" --button=gtk-yes:0 --button=gtk-no:1 --buttons-layout=center --separator='' --timeout=30 --timeout-indicator=right --width=400 --height=200)
ret=$?
while [ $ret -eq 0 ]
do
	ending1=$(yad --text="you chose to backup more files/directories" --text="please write the ending of the files or directories that you want to backup" --form --field="The ending:" --separator='' --timeout=30 --timeout-indicator=right --width=400 --height=200)
	cp *.$ending1 $destination
	ls -l *.$ending1 >> files
	echo "The files have been backed up"
	answer=$(yad --form --title="select ending" --title="how do you want to continue?" --text="do you want to backup more files or directories?" --button=gtk-yes:0 --button=gtk-no:1 --buttons-layout=center --separator='' --timeout=30 --timeout-indicator=right --width=400 --height=200)
	ret=$?
done
if [ $ret = 1 ]; then
	echo "you chose to not backup more files/directories"
fi
comment=$(yad --form --title="add a comment" --text="please write your comment for the backup" --field="Your comment:":TXT --separator='' --timeout=30 --timeout-indicator=right --width=400 --height=200)	 



echo "the files/directories that you chose to backup: " > backup
cat files >> backup
echo >> backup
echo "the number of files that you chose to backup: " >> backup
cat files | wc -l >> backup
echo >> backup
echo "the files/directories that backed up " >> backup
ls -l $destination >> backup
echo >> backup
echo "the number of files that backed up: " >> backup
ls $destination | wc -l  >> backup
echo >> backup
set want_to_backup = `cat files | wc -l`
set really_backed_up = `ls $destination | wc -l`

if [ $want_to_backup = $really_backed_up ] ; then 
	echo "Backup completed successfully! All files are backed up" >> backup
else
	echo "There seems to be a problem, not all files are backed up" >> backup
fi	
echo >> backup
echo "the backup directory name is: " >> backup
echo $destination >> backup
echo >> backup
echo "your comment is: " >> backup  
echo $comment >> backup
echo >> backup
echo "more details about the backup directory: " >> backup 
stat $destination >> backup
echo >> backup
echo "the backup date is: " >> backup
date >> backup

cat backup
cat backup | yad --text-info --width=400 --height=20 --title="Backup Data" 
 