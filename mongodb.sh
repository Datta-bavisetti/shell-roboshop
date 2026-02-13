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
    echo -e "$R Please run the script with root user$N"
    exit 1
fi

VALIDATE(){
if [ $1 -ne 0 ]; then
    echo "$2...FAILURE" | tee -a $LOGS_FILE
else
    echo "$2...SUCCESS" | tee -a $LOGS_FILE
fi
}

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo" 

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing MongoDB" 

systemctl enable mongod  &>>$LOGS_FILE
VALIDATE $? "Enabled mongod"

systemctl start mongod  &>>$LOGS_FILE
VALIDATE $? "Started mongod"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf

systemctl restart mongod  &>>$LOGS_FILE
VALIDATE $? "Restarted mongod"