Ansible : create user + grant privileges

1. /etc/hosts: ip servers
2. playbook: ./playbook/ssh.yml and ./playbook/sudoers.yml
3. run playbook
	ansible-playbook ./playbook/ssh.yml
	ansible-playbook ./playbook/sudoers.yml
	
Install ansible: http://blog.vccloud.vn/ansible-cai-dat-va-cau-hinh/
	
	yum install ansible or apt-get install ansible
	configure ssh with no password

