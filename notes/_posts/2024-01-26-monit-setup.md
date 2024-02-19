---
title: Configuring Monit in Ubuntu-22.04
date: 2024-01-02 19:10 +0530
categories: [DevOps, Alerting]
tags: [devops, alerting, ubuntu]
---
# Configure Monit

By default, it is set up to check that services are running every 2 minutes and stores its log file in “/var/log/monit.log”.

These settings can be altered at the beginning of the configuration file in the `set daemon` and `set logfile` lines.

## Web Service

Monit comes with it’s own web server running on port 2812. To configure the web interface, find and uncomment the section that begins with `set httpd port 2812`.

```bash
# File: /etc/monit/monitrc
set httpd port 2812
  allow admin:monit
```

## References

1. System alert setup [[system]]
2. SSH Login alert setup [[ssh-login]]
3. Automate with webhooks [[webhook]]
