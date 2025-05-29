#!/bin/bash

set -x
trap 'echo -e "Обработан сигнал SIGINT"' SIGINT
trap 'echo -e "Обработан сигнал SIGTERM"' SIGTERM
mkdir -p logs/os-monitoring/
exec > logs/os-monitoring/os-monitoring-$(date +%y-%m-%d_%H:%M:%S).log
exec > logs/os-monitoring/os-monitoring-$(date +%y-%m-%d_%H:%M:%S).log 2>&1
echo -e "----------- uptime command output ----------\n"
uptime
echo -e "----------- free command output ----------\n"
free
echo -e "----------- df -h command output ----------\n"
df -h
echo -e "----------- standart output ----------\n"