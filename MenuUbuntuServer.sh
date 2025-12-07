#!/bin/bash
# Shell script que ejecuta tareas tras la instalacion de Ubuntu Server.
# Script creado por  Samu-Bm para la asignatura de Programacion del ciclo formativo SMR (Sistemas Microinformáticos y Redes)

# COLORES
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
RESET="\e[0m"

# Necesitamos que el script se ejecute como root para que podamos ejecutar comandos como administrador
# primero lo comprobamos y si no lo somos nos avisa.
if  [ "$(id -u)" -ne 0 ]
then
echo -e "${RED}"
echo -e "=============================================="
echo -e "                A  V  I  S  O                 "
echo -e "----------------------------------------------"
echo -e "    Necesitas privilegios de administrador    " 
echo -e "=============================================="
echo -e "${RESET}"
exit 1
fi

# CONFIGURACION OPCION 3 NETPLAN
netplanconfig()
{
echo -e "${YELLOW}"
echo -e "========================================="
echo -e " CONFIGURACION DE RED   N E T P L A N "
echo -e "========================================="
echo -e "${RESET}"

# Preguntamos si queremos configurar de manera estatica o dinamica.
echo -e "${RED}[1]${RESET} Configurar IP estatica"
echo -e "${RED}[2]${RESET} Activar DHCP"
echo " "
echo -ne "${BLUE}Elige opcion [1-2]: ${RESET}"
read -n 1 net

    archivo_netplan="/etc/netplan/50-cloud-init.yaml"

    # Hacer una copia de seguridad.
    cp $archivo_netplan $archivo_netplan.backup 2>/dev/null

    if [[ $net == "1" ]]; then 
echo " "
read -p "Introduce una direccion IP [20-254]: " ip
read -p "Introduce DNS [Ej 8.8.8.8]: " dns

        cat > $archivo_netplan <<Fin
network:
  version: 2
  ethernets:
    enp0s3:
      addresses:
        - 192.168.1.$ip/24
      gateway4: 192.168.1.1 
      nameservers:
        addresses: [$dns]
Fin
        netplan apply

        echo -e "${GREEN}"
        echo -e "========================================="
        echo -e "- IP ESTATICA CONFIGURADA CORRECTAMENTE -"
        echo -e "========================================="
        echo -e "${RESET}"

    else 
        cat > $archivo_netplan <<Fin
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
Fin
        netplan apply

        echo -e "${GREEN}"
        echo -e "============================="
        echo -e "- DHCP ACTIVADO CORRECTAMENTE -"
        echo -e "============================="
        echo -e "${RESET}"
    fi
}


# MENU PRINCIPAL
while true; do
clear

echo -e "${YELLOW}"
echo -e " __  __               / "   
echo -e "|  \/  | __  _ __  _   _"
echo -e "| |\/| |/ _ \ '_ \| | | |"
echo -e "| |  | |  __/ | | | |_| |"
echo -e "|_|  |_|\___|_| |_|\__,_|"
echo -e "${RESET}"

echo -e "${BLUE}   [-] Herramienta creada por Samuel Burgueño ${RESET}\n"

echo -e "${RED}[01]${RESET} Actualiza el equipo          ${RED}[07]${RESET} Enviar fichero por SSH"
echo -e "${RED}[02]${RESET} Habilita/Deshabilita root    ${RED}[08]${RESET} Mostrar ficheros del sistema"
echo -e "${RED}[03]${RESET} Configurar IP estática       ${RED}[09]${RESET} Copias de seguridad con Duplicity"
echo -e "${RED}[04]${RESET} Cambiar nombre del servidor  ${RED}[10]${RESET} Reiniciar el servidor"
echo -e "${RED}[05]${RESET} Ajustes de fecha y hora      ${RED}[11]${RESET} Programar tareas con CRONTAB"
echo -e "${RED}[06]${RESET} Sesión SSH"
echo -e " "
echo -e "${RED}[00]${RESET}${YELLOW} Salir del script${RESET}"
echo -e " "
echo -ne "${BLUE}Selecciona una opción [1-9]: ${RESET}"
read opcion

case $opcion in

# OPCION 1 ACTUALIZAR EL SISTEMA
1) 
echo -e "${GREEN}"
echo -e "======================================="
echo -e "  ACTUALIZACIÓN DEL SISTEMA EN CURSO"
echo -e "======================================="
echo -e "${RESET}"
sudo apt update && sudo apt upgrade -y
read -p "- Presiona ENTER para continuar..."
;;

# OPCIÓN 2: HABILITA O DESABILITA EL USUARIO ROOT
2)
echo -e "${YELLOW}"
echo -e "========================================"
echo -e " HABILITA / DESHABILITA EL USUARIO ROOT"
echo -e "========================================"
echo -e "${RESET}"
read -p "Deseas Hablitar (H) o deshabilitar (D) el usuario root? [H/D] " accion
if [ "$accion" == "H" ] || [ "$accion" == "h" ]; then
sudo passwd root
echo -e "${GREEN}"
echo -e "======================================"
echo -e "- EL USUARIO ROOT HA SIDO HABILITADO -"
echo -e "======================================"
echo -e "${RESET}"
elif [ "$accion" == "D" ] || [ "$accion" == "d" ]; then
sudo passwd -l root
echo -e "${RED}"
echo -e "========================================="
echo -e "- EL USUARIO ROOT HA SIDO DESHABILITADO -"
echo -e "========================================="
echo -e "${RESET}"
else
echo -e "${RED}"
echo -e "- X Opcion no valida"
echo -e "${RESET}"
fi
read -p "- Presione ENTER para continuar..."
;;

# OPCION 3: CONFIGURAR LA IP DE FORMA ESTATICA MEDIANTE NETPLAN
3)
# LLAMAMOS A LA VARIABLE QUE ESCRUBIMOS ARRIBA
netplanconfig

read -p "- Presione ENTER para continuar..."
;;

#OPCION 4: CAMBIAR EL NOMBRE DEL SERVIDOR
4)
echo -e "$YELLOW" 
echo -e "==============================="
echo -e " CAMBIA EL NOMBRE DEL SERVIDOR"
echo -e "==============================="
echo -e "${RESET}"

read -p "introduce el nuevo nombre del servidor: " nuevo_nombre
hostnamectl set-hostname $nuevo_nombre
echo -e "${GREEN}"
echo -e "===================================="
echo -e "- NOMBRE CAMBIADO A: $nuevo_nombre -"
echo -e "===================================="
echo -e "${RESET}"

read -p "- Presione ENTER para continuar..."
;;

#OPCION 5: AJUSTES DE FECHA Y HORA
5)
echo -e "${YELLOW}"
echo -e "==========================="
echo -e "  AJUSTES DE FECHA Y HORA"
echo -e "==========================="
echo -e "${RESET}"

#OPCIONES DE LOS AJUSTES DE FECHA Y HORA
echo -e "${RED}[1]${RESET} Ver fecha y hora actual"
echo -e "${RED}[2]${RESET} Cambiar zona horaria"
echo -e "${RED}[3]${RESET} Sincronizar hora"
echo " "
read -p "Selecciona una opcion [1-3]: " opcion_fecha

# Vemos la fecha actual.
case $opcion_fecha in
1)
timedatectl status
;;

# Listamos los sitios o zonas horarias.
2)
timedatectl list-timezones
;;

# Sincronizamos la hora.
3)
timedatectl set-ntp true
echo -e "${GREEN}"
echo -e "================================="
echo -e "- Hora sincronizada correctamente"
echo -e "================================="
echo -e "${RESET}"
;;

# Opcion por si introducimos alguna opcion que no esta en el menu.
*) "- X Opcion no valida"
;;
esac
read -p "- Presione ENTER para continuar..."
;;

#OPCION 6 SESION SSH

6)
echo -e "${YELLOW}"
echo -e "======================="
echo -e "      SESIÓN SSH"
echo -e "======================="
echo -e "${RESET}"

echo -e "${RED}[1]${RESET} Instalar SSH"
echo -e "${RED}[2]${RESET} Iniciar el servicio SSH"
echo -e "${RED}[3]${RESET} Estado del servicio SSH"
echo -e "${RED}[4]${RESET} Realizar una conexion mediante SSH"
echo " "
read -p "Seleciona una opcion [1-4]: " opcion_ssh
case $opcion_ssh in

# Comando para instalar el paquete openssh.
1)
sudo apt install openssh-server -y

echo -e "${GREEN}"
echo -e "================================================="
echo -e "- El servicio SSH ha sido instalado correctamente"
echo -e "================================================="
echo -e "${RESET}"

;;
# iniciamos el servicio.
2) systemctl start ssh
systemctl enable ssh

echo -e "${GREEN}"
echo -e "================================================"
echo -e "- El servicio SSH ha sido iniciado correctamente"
echo -e "================================================"
echo -e "${RESET}"

;;
# Mostramos el estado del servicio.
3) systemctl status ssh
;;
# Realizamos una conexion SSH.
4)
echo -e "${YELLOW}"
echo -e "============================"
echo -e " REALIZAR UNA CONEXION SSH"
echo -e "============================"
echo -e "${RESET}"

read -p "Introduce la IP o dominio del servidor: " ssh_host
read -p "Introduce el usuario para la conexion: " ssh_user

echo -e "${GREEN}"
echo -e "INTENTANDO LA CONEXION A ${ssh_user}@${ssh_host}..."
echo -e "${RESET}"

ssh ${ssh_user}@${ssh_host}

echo -e "${GREEN}"
echo -e "========================"
echo -e " SESION SSH FINALIZADA"
echo -e "========================"
echo -e "${RESET}"
;;

# Por si introducimos una opcion que no existe.
*)
echo -e "${RED}"
echo -e "-X Opcion no valida"${RESET}
;;

esac
read -p "- Presione ENTER para continuar..."
;;


#OPCION 7 ENVIAR FICHERO MEDIANTE SSH
# Preguntamos que fichero queremos enviar y la ruta.
7)
echo -e "${YELLOW}"
echo -e "===============================" 
echo -e "  ENVIAR FICHERO MEDIANTE SSH"
echo -e "==============================="
echo -e "${RESET}"
read -p "Ruta del fichero local: " fichero
read -p "Nombre del usuario remoto: " usuario
read -p "IP del servidor remoto: " ip_remota
read -p "Ruta destino del archivo" destino

scp $fichero $usuario@$ip_remota:$ruta_destino

echo -e "${GREEN}"
echo -e "==============================="
echo -e "- Fichero enviado correctamente"
echo -e "==============================="
echo -e "${RESET}"
read -p "- Presione ENTER para continuar..."
;;

# OPCION 8 FICHEROS DEL SISTEMA
# Con las siguientes opciones podemos listar ficheros del sistema entre otras opciones...
8)
echo -e "${YELLOW}"
echo -e "========================"
echo -e "  FICHEROS DEL SISTEMA"
echo -e "========================"
echo -e "${RESET}"
echo -e "${RED}[1]${RESET} Mostrar ficheros del sistema"
echo -e "${RED}[2]${RESET} Mostrar ficheros de netplan"
echo -e "${RED}[3]${RESET} Mostrar ficheros de shadow"
echo -e "${RED}[4]${RESET} Mostrar ficheros de passwd"
echo -e "${RED}[5]${RESET} Mostrar uso del disco"
read -p "- Seleciona una opcion [1-2]: " opcion_ficheros

case $opcion_ficheros in

1)
ls -la /etc/
;;
2)
ls -la /etc/netplan
;;
3)
ls -la /etc/shadow
;;
4) 
ls -la /etc/passwd
;;
5)
df -h
;;
esac
read -p "- Presione ENTER para continuar..."
;;

# OPCION 9 COPIAS DE SEGURIDAD CON DUPLICITY
9)
echo -e "${YELLOW}"
echo -e "=============================="
echo -e "COPIAS DE SEGURIDAD DUPLICITY"
echo -e "=============================="
echo -e "${RESET}"
echo " "
echo -e "${RED}[1]${RESET} Instalar Duplicity"
echo -e "${RED}[2]${RESET} Realizar copia de Completa"
echo -e "${RED}[3]${RESET} Realizar copia Incremental"
echo -e "${RED}[4]${RESET} Listar copias de seguridad"
echo -e "${RED}[5]${RESET} Restaurar archivos"
echo -e "${RED}[6]${RESET} Ver estado de las copias"
echo " "
read -p "Selecciona una opcion [1-6]: " opcion_duplicity

case $opcion_duplicity in

# Con esta opcion instalamos el paquete duplicity.
1)
sudo apt install duplicity -y
echo -e "${GREEN}- Duplicity instalado correctamente${RESET}"
;;

# Con esta opcion realizamos una copia completa.
2)
read -p "Ruta a respadar: " ruta_origen
read -p "Destino (ej: file:///backups): " destino_backup
duplicity full "$ruta_origen" "$destino_backup"
echo -e "${GREEN}- Copia completa realizada${RESET}"
;;

# Con esta opcion realizamos la copia incremental.
3)
read -p "Ruta a respaldar: " ruta_origen
read -p "Destino (ej: file:///backups): " destino_backup
duplicity incremental "$ruta_origen" "$destino_backup"
echo -e "${GREEN}- Copia incremental realizada${RESET}"
;;

# Con la opcion 4 listamos nuestras copias de seguridad.
4)
read -p "Destino de las copias: " destino_backup
duplicity collection-status "$destino_backup"
;;

# La opcion 5 nos permite restaurar los archivos.
5)
read -p "Destino de las copias" destino_backup
read -p "Ruta a restaurar" ruta_restaurar
read -p "Destino de restauracion" destino_restauracion
duplicity restore "$destino_backup" "$ruta_restaurar" "$destino_restauracion"
echo -e "${GREEN}- Restauracion Completada${RESET}"
;;

# Con esta opcion podemos ver el estado de las copias.
6)
read -p "Destino de las copias: " destino_backup
duplicity list-current-files "$destino_backup"
;;

# Por si introducimos algun caracter que no es una opcion.
*)
echo -e "${RED}- X Opcion no valida${RESET}"
;;
esac
read -p "- Presione ENTER para continuar..."
;;

# OPCION 10 REINICIAR EL SERVIDOR
10)
echo -e "${YELLOW}"
echo -e "======================="
echo -e " REINICIAR EL SERVIDOR"
echo -e "======================="
echo -e "${RESET}"

echo -e "${RED}!ADVERTENCIA¡${RESET} Esto reiniciara el servidor inmediatamente"
echo "Todos los servicios se detendrán."

read -p "¿Estas completamente seguro? [s/N]: " confirmar_reinicio


if [[ "$confirmar_reinicio" == "s" || "$confirmar_reinicio" == "S" ]]; then
echo "- Reiniciando el sistema..."

init 6

else
echo "Reinicio cancelado"
read -p "- Presiona ENTER para volver al menú..."
fi
;;

# OPCION 11: TAREAS PROGRAMADAS (CRONTAB)
11)
echo -e "${YELLOW}"
echo -e "===================================="
echo -e "  TAREAS PROGRAMADAS (CRONTAB)"
echo -e "===================================="
echo -e "${RESET}"

echo -e "${RED}[1]${RESET} Ver tareas programadas actuales"
echo -e "${RED}[2]${RESET} Programar actualización automática"
echo -e "${RED}[3]${RESET} Programar tarea personalizada"
echo -e "${RED}[4]${RESET} Eliminar todas las tareas programadas"
echo -e "${RED}[5]${RESET} Instalar crontab"
echo " "
read -p "Selecciona una opción [1-5]: " opcion_cron

case $opcion_cron in

# La opcion 1 va a ser ver las tareas que tenemos programadas.
1)
echo -e "${GREEN}"
echo -e "===================================="
echo -e "   TAREAS PROGRAMADAS ACTUALES"
echo -e "===================================="
echo -e "${RESET}"
crontab -l
;;

# Con la opcion 2 programamos actualizaciones, para ello mostramos un ejemplo para que el usuario sepa utilizar el formato de Crontab
# al ejecutarlo enviamos el comando para actualizar el sistema.
2)
echo -e "${YELLOW}"
echo -e "===================================="
echo -e "  PROGRAMAR ACTUALIZACIÓN AUTOMÁTICA"
echo -e "===================================="
echo -e "${RESET}"
echo "Ejemplos de frecuencia:"
echo "  '0 2 * * *'  - Todos los días a las 2:00 AM"
echo "  '0 0 * * 0'  - Todos los domingos a medianoche"
echo "  '0 9-17 * * 1-5' - De lunes a viernes de 9 a 17h cada hora"
echo " "
read -p "Introduce la frecuencia (formato cron): " frecuencia

(crontab -l 2>/dev/null; echo "$frecuencia apt update && apt upgrade -y > /dev/null 2>&1") | crontab -

echo -e "${GREEN}"
echo -e "====================================="
echo -e " ACTUALIZACION AUTOMATICA PROGRAMADA"
echo -e "====================================="
echo -e "${RESET}"
;;

# La  opcion 3 es como la anterior pero permite programar el comando que el usuario desee.
3)
echo -e "${YELLOW}"
echo -e "===================================="
echo -e "  PROGRAMAR TAREA PERSONALIZADA"
echo -e "===================================="
echo -e "${RESET}"
read -p "Frecuencia (formato cron): " frecuencia
read -p "Comando a ejecutar: " comando

(crontab -l 2>/dev/null; echo "$frecuencia $comando >> /var/log/custom_cron.log 2>&1") | crontab -

echo -e "${GREEN}- Tarea personalizada programada${RESET}"
echo -e "${BLUE}- Comando: $comando${RESET}"
echo -e "${YELLOW}- Frecuencia: $frecuencia${RESET}"
;;

# Con la opcion 4 eliminamos las tareas para ellos preguntamos confirmacion y si es la correcta ejecutamos el comando crontab -r.
4)
echo -e "${RED}"
echo -e "===================================="
echo -e "  ELIMINAR TAREAS PROGRAMADAS"
echo -e "===================================="
echo -e "${RESET}"
read -p "¿Estás seguro de eliminar TODAS las tareas programadas? (s/N): " confirmar_eliminar

if [[ "$confirmar_eliminar" == "s" || "$confirmar_eliminar" == "S" ]]; then
    crontab -r
    echo -e "${GREEN}- Todas las tareas programadas han sido eliminadas${RESET}"
else
    echo -e "${YELLOW}- Operación cancelada${RESET}"
fi
;;

# Con esta opcion 5 instalamos crontab y lo activamos.
5)
echo -e "${YELLOW}"
echo -e "===================================="
echo -e "  INSTALAR CRONTAB"
echo -e "===================================="
echo -e "${RESET}"

apt install cron -y
systemctl enable cron
systemctl start cron

echo -e "${GREEN}"
echo -e "===================================="
echo -e "- CRONTAB INSTALADO Y ACTIVADO"
echo -e "===================================="
echo -e "${RESET}"
;;

# Por si introducimos algun caracter que no esta en el menú.
*)
echo -e "${RED}- X Opción no válida${RESET}"
;;
esac
read -p "- Presione ENTER para continuar..."
;;

# OPCION 0 SALIR DEL MENU.
0)
echo -e "${RED}"
echo -e "========================================="
echo -e " SALIENDO DEL SCRIPT...  HASTA PRONTO =)"
echo -e "========================================="
echo -e "${RESET}"

exit 0
;;

# TEXTO SI PULSAS OTRA LETRA O NUMERO QUE NO ES UNA OPCION.
*)
echo -e "${RED}"
echo -e "=========================="
echo -e "- X  OPCION NO VALIDA  X -"
echo -e "=========================="
echo -e "${RESET}"
read -p "- Presione ENTER para continuar..."
;;

esac
done
