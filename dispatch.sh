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

dnf install golang -y &>>$LOGS_FILE
VALIDATE $? "Installing golang"

id roboshop
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
    VALIDATE $? "Creating system user"
else 
    echo -e "Roboshop already exists....$Y SKIPPING $N" 
fi


mkdir -p /app &>>$LOGS_FILE
VALIDATE $? "Creating the app directory"

curl -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloading the app content"

cd /app &>>$LOGS_FILE
VALIDATE $? "Chaging the directory to the app"

rm -rf /app/* &>>$LOGS_FILE
VALIDATE $? "Removing existing code"

unzip /tmp/dispatch.zip &>>$LOGS_FILE
VALIDATE $? "Unzipping the content"

cd /app  &>>$LOGS_FILE
VALIDATE $? "Chaging the directory to the app"

go mod init dispatch
go get 
go build

systemctl daemon-reload &>>$LOGS_FILE
VALIDATE $? "daemon reload"

systemctl enable dispatch &>>$LOGS_FILE
systemctl start dispatch
VALIDATE $? "Enabled & Started dispatch service"