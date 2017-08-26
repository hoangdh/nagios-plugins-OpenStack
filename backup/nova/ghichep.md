## Ghi chép những thông tin về NOVA

- Lấy danh sách VMs đang hoạt động

```
openstack server list > /tmp/nova_list_vms.h2
cat /tmp/nova_list_vms.h2 | grep -w 'ACTIVE' | awk {'print $3'} FS="|"
```

- Danh sách VMs SHUTOFF

```
nova list --status SHUTOFF
```

- Lấy thông tin tài nguyên VMs sử dụng

```
nova diagnostics vmx > /tmp/nova_resource_usage_vmX.h2
 | awk {'print $2'} FS="|" |  sed -e 's/^[[:space:]]*//'
```

### Kịch bản:

- Lấy danh sách VMs
	- Số VM RUNNING
	- Số VM STOPED
- Lấy các thông số về tài nguyên của các VM RUNNING
	- RAM
		- actual
		- rss
	- NETWORK
		- TX
		- RX
	- DISK
		- 
