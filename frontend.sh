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

dnf module disable nginx -y
VALIDATE $? "Disabled nginx"

dnf module enable nginx:1.24 -y
VALIDATE $? "Enabled nginx:.24"

dnf install nginx -y
VALIDATE $? "Installing nginx"

systemctl enable nginx 
VALIDATE $? "Enabled nginx"

systemctl start nginx 
VALIDATE $? "Started nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip

cd /usr/share/nginx/html 

unzip /tmp/frontend.zip
VALIDATE $? "Downloaded and unzipped frontend"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied our nginx conf file"

systemctl restart nginx
VALIDATE $? "Restarted nginx"

