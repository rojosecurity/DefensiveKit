#!/bin/bash

# Colores de fuente

fnegro="\033[30m"
fnaranja="\033[33m"
fverde="\033[32m"
rstfn="\033[39m"

# Colores fondo

yellow="\033[103m"
blue="\033[104m"
rstfg="\033[40m"



requisitosPrevios(){
    # verificar conexión a internet
    verificarConexion=$(ping -c1 google.com | grep "1 received" | cut -d "," -f 2)
    
    if [[ "$verificarConexion" == *"1 received"* ]]; then
        echo -e "${blue}          REQUISITOS PREVIOS          ${rstfg}"
        sleep 2
        echo "[+] Conexión establecida"
    fi

    # Validando que el sistema es debian o ubuntu
    validacionDistribucion=$(cat /etc/os-release | grep "ID=debian")
    validacionDistribucion2=$(cat /etc/os-release | grep "ID=ubuntu")
    if [[ "$validacionDistribucion" == *"ID=debian"* ]];then
        echo "[+] OS : Debian"
    elif [[ "$validacionDistribucion2" == *"ID=ubuntu"* ]];then    
        echo -e "[+] OS : ${fnaranja} Ubuntu ${rstfn}"
    else
        echo "[X] Distro no compatible "
        exit 1
    fi
}

actualizandoRepositorios(){
    echo -e "${blue}      ACTUALIZANDO REPOSITORIOS       ${rstfg}"
    apt-get update 1>/dev/null
    
    if [[ "$?" != 0 ]];then
        sleep 2
        echo "[X] Error al actualizar repositorios"
        exit 1
    else
        sleep 2
        echo "[+] Repositorios actualizados"
    fi
}

instalacionBasicos(){
    echo "INSTALANDO UTILIDADES BÁSICAS"
    
    apt install dnsutils

}

# Categoría | Reconocimiento y Enumeración
catReconocimiento(){
    echo "Reconocimiento"

    recon=(nmap masscan arp-scan netdiscover nbtscan smbclient)

    for n in "${recon[@]}";do
        apt-get install $n -y 1>/dev/null
        sleep 1
        echo -e "${fverde}╠${rstfn} $n"
    done
    
}

catMonitoreoRed(){
    echo "Analisis y monitoreo de red"

    monitoreo=(tcpdump tshark iftop nload conntrack suricata)

    for n in "${monitoreo[@]}";do
        apt-get install $n -y 1>/dev/null
        sleep 1
        echo -e "${fverde}╠${rstfn} $n"
    done
}

# Seguridad del Sistema y Hardening
catHardening(){
    #apt install ufw fail2ban auditd chrootkit rkhunter
    echo "Seguridad del Sistema y Hardening"
    hardening=(ufw fail2ban auditd chkrootkit rkhunter lynis)

    for n in "${hardening[@]}";do
        apt-get install $n -y 1>/dev/null
        sleep 1
        echo -e "${fverde}╠${rstfn} $n"
    done
}

# -----------------------------------
# Verificar privilegios de ejecución
# -----------------------------------

if [ $(id -u) -ne 0 ] ; then 
    echo -e "${yellow} ${fnegro} EJECUTA EL SCRIPT COMO ROOT ${rstfn} ${rstfg}"
    exit 1
else 
    requisitosPrevios
    actualizandoRepositorios
    catReconocimiento
    catMonitoreoRed
    catHardening
fi

