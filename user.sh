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

dnf module disable nodejs -y &>>$LOGS_FILE
VALIDATE $? "Disabling nodejs default version"
dnf module enable nodejs:20 -y &>>$LOGS_FILE
VALIDATE $? "Enabling NodeJS 20"

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "Installing NodeJS"

id roboshop
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    VALIDATE $? "Creating system user"
else 
    echo -e "Roboshop already exists....$Y SKIPPING $N"
fi

mkdir -p /app 
VALIDATE $? "Creating the app directory"

curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip
VALIDATE $? "Downloading the app content"

cd /app 
VALIDATE $? "Chaging the directory to the app"

rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/user.zip
VALIDATE $? "Unzipping the content"

npm install 
VALIDATE $? "Installing npm"

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service
VALIDATE $? "Copying the user service file"

systemctl daemon-reload
VALIDATE $? "daemon reload"

systemctl enable user 
VALIDATE $? "Enabling user service"

systemctl start user
VALIDATE $? "Starting user service"