#!/bin/bash

dnf update -y

dnf install -y python3 python3-pip nginx

pip3 install flask pymysql flask-cors

cat <<EOF > /home/ec2-user/app.py
from flask import Flask, jsonify
from flask_cors import CORS
import pymysql

app = Flask(__name__)
CORS(app)

DB_HOST = "${rds_endpoint}"
DB_USER = "admin"
DB_PASS = "ChangeMe123!"
DB_NAME = "projectdb"

@app.route("/")
def health():
    return jsonify({
        "status": "healthy"
    })

@app.route("/users")
def get_users():

    try:

        connection = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASS,
            database=DB_NAME,
            cursorclass=pymysql.cursors.DictCursor
        )

        cursor = connection.cursor()

        cursor.execute(
            "SELECT * FROM users"
        )

        data = cursor.fetchall()

        connection.close()

        return jsonify(data)

    except Exception as e:

        return jsonify({
            "error": str(e)
        }), 500

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000
    )
EOF

cat <<EOF > /etc/nginx/conf.d/backend.conf
server {

    listen 80;

    location / {

        proxy_pass http://127.0.0.1:5000;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

systemctl enable nginx
systemctl restart nginx

nohup python3 /home/ec2-user/app.py > /home/ec2-user/app.log 2>&1 &