## Hướng dẫn sử dụng trên check_mk và nagios

- [1. Tải Plugin](#1)
- [2. Cấu hình check_mk](#2)
- [3. Cấu hình Nagios](#3)

<a name="1" />

### 1. Tải plugin

**Chú ý**: Các bước này làm trên node `controller` của OpenStack

- Tải plugin ở 2 thư mục `check_resoucres` và `check_services`

```
https://github.com/hoangdh/nagios-plugin-OpenStack/tree/master/plugins
```

Ví dụ, chúng ta tải các plugin về thư mục `/opt/check_openstack`

- Phân quyền cho các plugins

```
cd /opt/check_openstack
chmod +x *
```

<a name="2" />

### 2. Cấu hình check_mk

**Chú ý**: Các bước này làm trên node `controller` của OpenStack

- **Bước 1**: Copy các file plugin

[Hướng dẫn cài check_mk Agent trên máy cần giám sát.](https://github.com/hoangdh/meditech-ghichep-omd/blob/master/docs/2.Install-agent.md)

Thư mục mặc định: `/usr/lib/check_mk_agent/plugins`

Xác định lại thư mục:

```
[root@controller ~]# check_mk_agent | grep 'PluginsDirectory'
PluginsDirectory: /usr/lib/check_mk_agent/plugins
```

- **Bước 2**: Thêm cấu hình vào file `mrpe.cfg`

	- Cú pháp như sau:

	```
	<Tên-Hiển-thị-trên-Dashboard> <Đường-dẫn-plugin>
	```
	
	- Ví dụ:
	
	```
	OPENSTACK_Cinder /usr/lib/check_mk_agent/plugins/check_cinder
	OPENSTACK_Neutron /usr/lib/check_mk_agent/plugins/check_neutron
	OPENSTACK_Keystone /usr/lib/check_mk_agent/plugins/check_keystone
	OPENSTACK_Nova /usr/lib/check_mk_agent/plugins/check_nova
	OPENSTACK_Glance /usr/lib/check_mk_agent/plugins/check_glance	
	OPENSTACK_Volume /usr/lib/check_mk_agent/plugins/check_volumes
	OPENSTACK_Images /usr/lib/check_mk_agent/plugins/check_images
	OPENSTACK_Networks /usr/lib/check_mk_agent/plugins/check_networks
	OPENSTACK_VMs_State /usr/lib/check_mk_agent/plugins/check_instances_state
	```

<a name="3" />
	
### 3. Nagios Core

**Chú ý:** Các bước làm trên node `controller` của OpenStack

- **Bước 1**: Copy các file plugin

[Hướng dẫn cài đặt NRPE trên máy cần giám sát.](https://github.com//meditech-ghichep-nagios/blob/master/docs/thuchanh-nagios/1.Setup-CentOS-7.md#3.1.2)

**Thư mục mặc định:**

- Trên CentOS 

```
/usr/lib64/nagios/plugins
```

- Trên Ubuntu

```
/usr/lib/nagios/plugins
```

- **Bước 2**: Thêm cấu hình vào file nrpe.

**Lưu ý:** Thay thế đường dẫn phù hợp với DISTRO của bạn vào file cấu hình. Trong bài viết này, chúng tôi sử dụng CentOS 7.

```
vi /etc/nagios/nrpe.cfg
```

```
command[check_cinder]=/usr/lib64/nagios/plugins/check_cinder
command[check_neutron]=/usr/lib64/nagios/plugins/check_neutron
command[check_keystone]=/usr/lib64/nagios/plugins/check_keystone
command[check_nova]=/usr/lib64/nagios/plugins/check_nova
command[check_glance]=usr/lib/check_mk_agent/plugins/check_glance
command[check_volumes]=/usr/lib64/nagios/plugins/check_volumes
command[check_images]=/usr/lib64/nagios/plugins/check_images
command[check_networks]=/usr/lib64/nagios/plugins/check_networks
command[check_instances_state]=/usr/lib64/nagios/plugins/check_instances_state
```

Trên file cấu hình của host `controller` trên Nagios, chúng ta sửa file cấu hình như sau:

```
...
define service {
        use                             generic-service
        host_name                       controller
        service_description             OPENSTACK_Cinder
        check_command                   check_nrpe!check_cinder
}
define service {
        use                             generic-service
        host_name                       controller
        service_description             OPENSTACK_Neutron
        check_command                   check_nrpe!check_neutron
}
define service {
        use                             generic-service
        host_name                       controller
        service_description             OPENSTACK_Keystone
        check_command                   check_nrpe!check_keystone
}
define service {
        use                             generic-service
        host_name                       controller
        service_description             OPENSTACK_Nova
        check_command                   check_nrpe!check_nova
}
define service {
        use                             generic-service
        host_name                       controller
        service_description             OPENSTACK_Glance
        check_command                   check_nrpe!check_glance
}
define service {
        use                             generic-service
        host_name                       controller
        service_description             OPENSTACK_Images
        check_command                   check_nrpe!check_images
}
define service {
        use                             generic-service
        host_name                       controller
        service_description             OPENSTACK_Networks
        check_command                   check_nrpe!check_networks
}
# define service {
        # use                             generic-service
        # host_name                       controller
        # service_description             OPENSTACK_VMs_State
        # # check_command                   check_nrpe!check_instances_state
# }
```
