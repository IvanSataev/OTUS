#!/bin/bash

yum install vim docker git wget gcc openssl-devel readline-devel systemd-devel make pcre-devel -y
systemctl start docker
cat >> prometheus.yml << EOF
global:
alerting:
  alertmanagers:
    - static_configs:
        - targets:
rule_files:
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: node
    static_configs:
      - targets: ['10.0.2.15:9100']
EOF

docker run -d -p  9090:9090 -v prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz  --no-check-certificate
tar xvfz node_exporter-1.6.1.linux-amd64.tar.gz

cp node_exporter-1.6.1.linux-amd64/node_exporter /usr/sbin/node_exporter
cat >>  /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter

[Service]
ExecStart=/usr/sbin/node_exporter
Restart=Always

[Install]
WantedBy=default.target
EOF

systemctl enable node_exporter.service
systemctl start node_exporter.service