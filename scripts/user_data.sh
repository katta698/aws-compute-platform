#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y docker amazon-cloudwatch-agent

systemctl enable docker
systemctl start docker

# Prepare attached data volume if present.
if [ -b /dev/xvdf ]; then
  file -s /dev/xvdf | grep -q filesystem || mkfs -t xfs /dev/xvdf
  mkdir -p /appdata
  grep -q /appdata /etc/fstab || echo "/dev/xvdf /appdata xfs defaults,nofail 0 2" >> /etc/fstab
  mount -a
fi

cat > /tmp/index.html <<HTML
<html>
  <head><title>AWS Compute Platform</title></head>
  <body>
    <h1>AWS Compute Platform</h1>
    <p>Served from EC2 Auto Scaling behind an Application Load Balancer.</p>
    <p>Instance ID: $(TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600") && curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)</p>
  </body>
</html>
HTML

docker rm -f compute-demo || true
docker run -d --name compute-demo --restart unless-stopped -p ${app_port}:80 -v /tmp/index.html:/usr/share/nginx/html/index.html:ro nginx:stable
