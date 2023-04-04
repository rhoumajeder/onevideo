#!/bin/bash

# Get the new IP addresses from Terraform output
ip_addresses=($(terraform output -json ip_address | jq -r 'to_entries[] | .value'))


echo "[MasterKubernetes]" >> /tmp/hosts

line1="${ip_addresses[0]} ansible_ssh_private_key_file=RjeKeys.pem ansible_python_interpreter=/usr/bin/python3"
echo "$line1" >> /tmp/hosts

echo "[WorkerKubernetes]" >> /tmp/hosts

line2="${ip_addresses[1]} ansible_ssh_private_key_file=RjeKeys.pem ansible_python_interpreter=/usr/bin/python3"
echo "$line2" >> /tmp/hosts

#line3="${ip_addresses[2]} ansible_ssh_private_key_file=RjeKeys.pem ansible_python_interpreter=/usr/bin/python3"
#echo "$line3" >> /tmp/hosts


mv /tmp/hosts /home/ubuntu/environment/myproject/test/ansible/inventory/vm-setup-playbook/hosts


line1="sudo ssh -i "RjeKeys.pem" ubuntu@${ip_addresses[0]}"
line2="sudo ssh -i "RjeKeys.pem" ubuntu@${ip_addresses[1]}"
#line3="sudo ssh -i "RjeKeys.pem" ubuntu@${ip_addresses[2]}"
line4="ansible-playbook --inventory inventory/vm-setup-playbook/hosts vm-setup-playbook.yml"
echo $line1
echo $line2
#echo $line3
echo $line4