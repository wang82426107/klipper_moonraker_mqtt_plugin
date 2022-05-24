#!/bin/bash
       OPTIONS="CN English Quit"
       select opt in $OPTIONS; do
           if [ "$opt" = "Englisch" ]; then
            echo "========= moonraker-mqtt-plugin - Installation Script ==========="
            echo "========= Install the Subsystem ========="
            sudo apt update && sudo apt upgrade
            sudo apt install curl
            curl --version
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            python3 get-pip.py
            pip3 install paho-mqtt
            pip3 install requests
            pip3 install ConfigParser           
            cp -i ~/Klipper_Moonracker_MQTT_plugin/scripts/Klipper_Moonraker_mqtt.cfg ~/klipper_config
            echo "========= Installing the Subsystem successful ========="
            exit
           elif [ "$opt" = "CN" ]; then
            echo "========= Klipper_Moonracker_MQTT_plugin - 初始化脚本 ==========="
            echo "========= 导入 Klipper_Moonracker_MQTT_plugin ========="
            echo "========= 导入 依赖包 ========="
            python3 ~/Klipper_Moonracker_MQTT_plugin/scripts/get-pip.py
            pip3 install paho-mqtt
            pip3 install requests
            pip3 install ConfigParser
            cp -i ~/Klipper_Moonracker_MQTT_plugin/scripts/Klipper_Moonraker_mqtt.cfg ~/klipper_config
            echo "========= 加载完成 ========="
            exit
           elif [ "$opt" = "Quit" ]; then
            echo done
            exit
           else
            echo bad option
            exit
           fi
       done
