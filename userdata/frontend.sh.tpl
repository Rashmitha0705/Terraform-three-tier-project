#!/bin/bash

dnf update -y
dnf install -y nginx

systemctl enable nginx
systemctl start nginx

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>AWS 3 Tier Frontend</title>
</head>

<body>

<h1>Frontend Tier Running</h1>

<p>Status: Connected via ALB</p>

<button onclick="loadBackend()">
Fetch Backend Data
</button>

<pre id="output"></pre>

<script>

async function loadBackend() {

    const output = document.getElementById("output");
    output.innerText = "Calling backend...";

    try {

        const response = await fetch("http://${internal_alb_dns}/users");

        const data = await response.json();

        output.innerText = JSON.stringify(data, null, 2);

    } catch (err) {
        output.innerText = "Error: " + err.message;
    }
}

</script>

</body>
</html>
EOF