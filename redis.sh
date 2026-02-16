#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script/"
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

mkdir -p $LOGS_FOLDER

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run the script with root user$N" | tee -a $LOGS_FILE
    exit 1
fi

VALIDATE(){
if [ $1 -ne 0 ]; then
    echo "$2...FAILURE" | tee -a $LOGS_FILE
else
    echo "$2...SUCCESS" | tee -a $LOGS_FILE
fi
}

dnf module disable redis -y &>>$LOGS_FILE
VALIDATE $? "Disabling Redis default version"

dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "Enabling Redis 7"

dnf install redis -y &>>$LOGS_FILE
VALIDATE $? "Installing Redis"

systemctl enable redis
VALIDATE $? "Enable redis service"

systemctl start redis 
VALIDATE $? "Staring the redis service"