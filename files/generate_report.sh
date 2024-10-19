#!/bin/bash

# Caminho dos arquivos de relatório e log
REPORT_FILE="/var/log/ansible_report.txt"
LOG_FILE="/var/log/report_generation.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")
HEADER="===== System Report ====="
FOOTER="===== End of Report ====="

# Função de logging
log_message() {
  local MESSAGE=$1
  echo "$DATE: $MESSAGE" >> "$LOG_FILE"
}

# Função para verificar e criar diretórios, se necessário
ensure_directory_exists() {
  local DIR=$1
  if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
    if [ $? -ne 0 ]; then
      log_message "Error: Failed to create directory $DIR"
      exit 1
    fi
  fi
}

# Função para escrever no relatório
write_report() {
  local SECTION=$1
  echo "[$SECTION]" >> "$REPORT_FILE"
  shift
  eval "$@" >> "$REPORT_FILE" 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to retrieve $SECTION data" >> "$REPORT_FILE"
    log_message "Error retrieving $SECTION data"
  fi
  echo "" >> "$REPORT_FILE"
}

# Função para gerar o cabeçalho do relatório
generate_header() {
  echo "$HEADER" > "$REPORT_FILE"
  echo "Generated on: $DATE" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
}

# Função para gerar o rodapé do relatório
generate_footer() {
  echo "$FOOTER" >> "$REPORT_FILE"
}

# Função principal que gera o relatório
generate_report() {
  log_message "Report generation started"

  generate_header

  # Informações gerais do sistema
  write_report "Operating System Information" "lsb_release -a || cat /etc/os-release"
  write_report "Kernel Version" "uname -r"
  write_report "System Architecture" "uname -m"
  write_report "Runlevel" "runlevel"

  # Uso de recursos
  write_report "System Load" "uptime"
  write_report "Disk Usage" "df -h"
  write_report "Memory Usage" "free -h"
  write_report "CPU Usage" "top -b -n1 | grep 'Cpu(s)'"

  # Informações de hardware
  write_report "CPU Info" "lscpu"
  write_report "Memory Info" "dmidecode --type memory | grep -i 'Size:'"
  write_report "Block Devices" "lsblk"
  write_report "Mounted Filesystems" "mount | column -t"
  
  # Informações de rede e conectividade
  write_report "Network Interfaces" "ip -br addr || ifconfig"
  write_report "Open Ports" "netstat -tuln | grep LISTEN || ss -tuln"
  write_report "Active Network Connections" "ss -s"
  write_report "Routing Table" "ip route show"
  write_report "DNS Servers" "cat /etc/resolv.conf | grep nameserver"
  write_report "Firewall Rules (UFW)" "ufw status verbose || iptables -L"

  # Informações de serviços e processos
  write_report "Running Services" "systemctl list-units --type=service --state=running"
  write_report "Failed Services" "systemctl --failed"
  write_report "Top 10 Memory-consuming Processes" "ps aux --sort=-%mem | head -n 10"
  write_report "Top 10 CPU-consuming Processes" "ps aux --sort=-%cpu | head -n 10"

  # Pacotes e atualizações
  write_report "Installed Packages" "dpkg -l"
  write_report "Available Updates" "apt list --upgradable"

  # Sistema e logs
  write_report "System Boot Time" "who -b"
  write_report "Recent System Logs" "journalctl -n 100 --no-pager"
  write_report "User Login History" "last -n 10"

  generate_footer

  if [ -f "$REPORT_FILE" ]; then
    log_message "Report generated successfully at $REPORT_FILE"
    echo "Report generated successfully at $REPORT_FILE"
  else
    log_message "Error: Report generation failed"
    echo "Error: Report generation failed" >&2
    exit 1
  fi
}

# Início do script
ensure_directory_exists "/var/log"
generate_report
