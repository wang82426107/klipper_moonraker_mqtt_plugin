<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://gitee.com/676758285/klipper_moonraker_mqtt_plugin/blob/master">
    <img src="https://gitee.com/676758285/klipper_moonraker_mqtt_plugin/raw/master/img/LOGO.png" alt="Logo" width="200" height="200">
  </a>

  <h3 align="center">Klipper-Moonraker-MQTT-plugin</h3>

  <p align="center">
    一款应用于 klipper moonraker 的 mqtt插件
    <br />
    <a href="https://space.bilibili.com/123363171?spm_id_from=333.337.0.0"><strong>骚栋个人B站主页 »</strong></a>
    <br />
    <br />
    <a href="https://gitee.com/676758285/klipper_moonraker_mqtt_plugin/issues">提Bug</a>
    ·
    <a href="https://gitee.com/676758285/klipper_moonraker_mqtt_plugin/issues">提需求</a>
  </p>
</p>


<!-- 目录 -->
<details open="open">
  <summary>目录</summary>
  <ol>
    <li>
      <a href="#关于插件">关于插件</a>
      <ul>
        <li><a href="#使用技术">使用技术</a></li>
      </ul>
    </li>
    <li>
      <a href="#导入插件">插件导入</a>
      <ul>
        <li><a href="#前期准备">前期准备</a></li>
        <li><a href="#导入">导入</a></li>
      </ul>
    </li>
    <li><a href="#使用示例">使用示例</a></li>
    <li><a href="#联系我">联系我</a></li>

  </ol>
</details>



<!-- About-Project -->
## 关于插件

当前MQTT的插件会贯穿整个打印的过程,不但可以通过MQTT接受到Klipper的相关参数信息.而且你可以发送GCode来实现对Klipper的控制

### 使用技术

涉及到的相关基础:
* [Python3](https://www.python.org/)
* [Json](https://www.json.org/)
* [Bash](https://www.gnu.org/software/bash/)

<!-- Import -->
## 导入插件

### 前期准备

首先你必须安装了 MainsailOS 和 Fluidd,可以方便后期的管理
* [MainsailOS](https://github.com/meteyou/mainsail)
* [Fluidd](https://github.com/cadriel/fluidd)

### 导入

1. 如果当前的用户不是你安装Klipper用户,例如当前用户是root等,请先切换一下用户.假设安装用户名为klipper,那么如下操作即可.(可选步骤.)

   ```sh
    su klipper
   ```
2. 首先进入就是切换到你安装 Klipper的目录下, 如果是树莓派,应该在 `/home/pi`,如果是香橙派的Debian系统 则应该是 `/home/orangepi`. 我们可以直接使用下面命令完成文件夹切换.

   ```sh
   cd ~
   ```
3. 下载源码
    ```sh
   git clone https://gitee.com/676758285/klipper_moonraker_mqtt_plugin.git
   ```
4. 直接运行编译源码中的注入脚本 `install.sh`
	```sh
   bash ./klipper_moonraker_mqtt_plugin/scripts/install.sh
   ```

5. 然后在 Klipper的 moonraker.conf 中 添加如下代码, 方便后期升级更新.


	```sh
    [octoprint_compat]

    [update_manager]

    [update_manager client Klipper-Moonraker-MQTT-plugin]
    type: git_repo
    path: ~/klipper_moonraker_mqtt_plugin
    origin: https://gitee.com/676758285/klipper_moonraker_mqtt_plugin.git
    ```

6. 添加完成上面信息之后,保存并且重启Klipper.
7. 然后在配置页面`Klipper_Moonraker_mqtt.cfg`中,设置MQTT的相关信息.Port(端口)是可选的.

	``` Python
    [Broker]
    IP = x.x.x.x
    Port = 1883 # 可选
    #Username = username
    #Password = password

    [MQTT-Config]
    client_id = moonraker_MQTT
    topic = moonraker
    refresh_time = 5
    ```

8. 手动启动脚本,我们只需要在SSH的命令使用如下命令就可以了.

	``` sh
    Python ~/klipper_moonraker_mqtt_plugin/scripts/mqtt.py
    ```


9. 如果想要开机自启动的话,我们需要编辑 `/etc/rc.local` 文件,首先打开文件.

	``` sh
    sudo nano /etc/rc.local
    ```
10. 然后在 `exit 0` 之前添加上执行代码 `Python ~/klipper_moonraker_mqtt_plugin/scripts/mqtt.py`即可.整体如下所示.

	``` sh
    #!/bin/sh -e
    #
    # rc.local
    #
    # This script is executed at the end of each multiuser runlevel.
    # Make sure that the script will "exit 0" on success or any other
    # value on error.
    #
    # In order to enable or disable this script just change the execution
    # bits.
    #
    # By default this script does nothing.
    Python ~/klipper_moonraker_mqtt_plugin/scripts/mqtt.py
    exit 0
    ```
11. 然后 `Ctrl + O` 回车保存, `Ctrl + X` 退出编辑.

<!-- 使用 -->
## 使用示例

在MQTT的终端可以订阅到以下的 `Topic`. 这些Topic 在`mqtt.py`文件中都是能找到的.

> * moonraker/status
> * moonraker/printer_status/info/hostname
> * moonraker/printer_status/info/software_version
> * moonraker/printer_status/info/cpu_info
> * moonraker/printer_status/klipper/klippy_connected
> * moonraker/printer_status/klipper/klippy_state
> * moonraker/printer_status/temperature/bed/actual
> * moonraker/printer_status/temperature/bed/target
> * moonraker/printer_status/temperature/tool0/actual
> * moonraker/printer_status/temperature/tool0/target
> * moonraker/printer_status/query_endstops/query_endstop_x
> * moonraker/printer_status/query_endstops/query_endstop_y
> * moonraker/printer_status/query_endstops/query_endstop_z

那么如何控制Klipper呢,我们只需要往 `moonraker/control/run_gcode`这个Topic 发送GCode即可.

另外需要说明的几点Topic的前缀 `moonraker` 是在conf中设置的,还有就是发送的频率也是在config中设置的(`refresh_time` 字段)

<!-- 使用 -->
## 联系我

如果有问题,可以联系邮箱 676758285@qq.com 或者 加 QQ 676758285.



### End
