# Menú de Administración para Ubuntu Server

Script desarrollado en **Bash** para automatizar tareas de administración en Ubuntu Server.

Este proyecto ha sido creado como parte del ciclo formativo **SMR (Sistemas Microinformáticos y Redes)**.

## ✨ Funcionalidades

- Actualización del sistema
- Activar / desactivar usuario root
- Configuración de red con Netplan (IP estática o DHCP)
- Cambiar nombre del servidor
- Configurar fecha y hora
- Gestión de SSH (instalar, iniciar, conectar)
- Envío de archivos por SSH (scp)
- Visualización de ficheros del sistema
- Copias de seguridad con Duplicity
- Programación de tareas con Crontab
- Reinicio del servidor

## 📂 Archivo principal

- `MenuUbuntuServer.sh`

## ▶️ Cómo usar el script

1.  **Dar permisos de ejecución:**

    ```bash
    chmod +x MenuUbuntuServer.sh
    ```

2.  **Ejecutar el script:**

    ```bash
    sudo ./MenuUbuntuServer.sh
    ```


