#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
N="\e[0m"
validate(){
  if [ $1 -ne 0 ]
  then
   echo -e "$2 is failure $R"
   exit 1
  else
   echo -e "$2 is success $G"
}

if [ $USERID -ne 0 ]
then
 echo "you are not a super user"
else 
 echo "you are a super user"
fi 
 
dnf install mysql -y &>>$LOGFILE
validate $? "installing mysql"

systemctl enable mysql &>>$LOGFILE
validate $? "enabling mysql"

systemctl start mysql &>>$LOGFILE
validate $? "starting mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
validate $? "setting up root password"