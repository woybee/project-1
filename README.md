## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

(Images/Cloud_Network.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above.

  (Ansible/docker-playbook.yaml)
  (Ansible/install-elk.yaml)
  (Ansible/filebeat-playbook.yaml)
  (Ansible/metricbeat-playbook.yaml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the configuration and system files.

The configuration details of each machine may be found below.

| Name                 | Function         | IP Address | Operating System |
|----------------------|------------------|------------|------------------|
| Jump-Box-Provisioner | Gateway          | 10.0.0.4   | Linux            |
| Web-1                | DVWA Server      | 10.0.0.5   | Linux            |
| Web-2                | DVWA Server      | 10.0.0.8   | Linux            |
| Web-3                | Elk-Stack Server | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump-Box-Provisioner machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
198.52.163.249

Machines within the network can only be accessed by Jump-Box-Provisioner.
10.0.0.4 can access Web-1, Web-2, ELK-Stack-Server using SSH over Port 22.

A summary of the access policies in place can be found in the table below.

| Name                 | Publicly Accessible  | Allowed IP Addresses |
|----------------------|----------------------|----------------------|
| Jump-Box-Provisioner | Yes (SSH Port 22)    | 198.52.163.249       |
| Web-1                | Yes (HTTP Port 80)   | 10.0.0.7             |
| Web-2                | Yes (HTTP Port 80)   | 10.0.0.7             |
| Web-3                | Yes (HTTP Port 5601) | 10.0.0.7             |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...-

- it allows quick configuration of new machines in a consistent manor.
- everyone can see exactly how the network is configured by reading the configuration files.
- it allows automatic updates to occur to machines on the network whenever the configuration files change.

### Playbook 1: docker-playbook.yml
This playbook is used to set up DVWA servers running inside a Docker container. This file was used to configure Web-1 and Web-2. The playbook executes the following tasks:

- Installs Docker
- Installs Python3
- Installs Docker Python Module
- Downloads and Launches DVWA Docker Container over Port 80
- Enables the Docker service

### Playbook 2: install-elk.yml
This playbook is used to set up an ELK server running inside a Docker container. This file was used to configure Elk-Stack-Server. The playbook executes the following tasks:

- Installs Docker
- Installs Python3
- Installs Docker Python Module
- Increase Virtual Memory to 262144 to support the ELK Stack
- Download and Launch Docker Elk Container (image: sebp/elk:761)

### Playbook 3: filebeat-playbook.yml
This playbook is used to deploy Filebeat on the Web-1 and Web-2 servers. This allows the elk service on Elk-Stack_Server to monitor log file activity on the webservers. The playbook executes the following tasks:

- Downloads latest Filebeat deb from Kibana
- Installs latest Filebeat deb found in Kibana
- Drops in new Filebeat config file into /etc/filebeat/filebeat.yml
- Enable Filebeat Modules
- Setup Filebeat
- Start Filebeat service -Enable Filebeat service on boot

### Playbook 4: metricbeat-playbook.yml
This playbook is used to deploy Metricbeat on the Web-1 and Web-2 servers. This allows the elk service on Elk-Stack_Server to monitor metrics from operating systems and services on the webservers. The playbook executes the following tasks:

- Downloads latest Metricbeat deb from Kibana
- Installs latest Metricbeat deb found in Kibana
- Drops in new Metricbeat config file into /etc/metricbeat/metricbeat.yml
- Enable Metricbeat Modules
- Setup Metricbeat
- Start Metricbeat service -Enable Metricbeat service on boot

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

(Images/sudo_docker_ps_command.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1: 10.0.0.5
- Web-2: 10.0.0.8

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- Filebeat monitors the log files, collects log events, and forwards them to Elasticsearch or Logstash.
- Metricbeat periodically collects metrics from the operating system and from services running on the server, then forwards this data to Elasticsearch or Logstash.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the playbook files to Ansible Docker Container.
- Update the hosts file /etc/ansible/hosts/ to include...

[webservers]
10.0.0.5 ansible_python_interpreter=/usr/bin/python3
10.0.0.8 ansible_python_interpreter=/usr/bin/python3

[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3

- Run the playbook.

### Steps to running the playbook

1. From local machine, ssh into the Jump-Box-Provisioner ~$ ssh azadmin@<jump-box-provisioner-ip>
2. Start the Ansible Docker container ~$ sudo docker start brave_hermann. brave_hermann is the name of the docker container in Jump-Box-Provisioner.
3. Run ~$ sudo docker attach brave_hermann to jump into the Ansible Docker Container.
4. Run the four playbooks with the following commands:

- ~$ ansible-playbook /etc/ansible/docker-playbook.yml
- ~$ ansible-playbook /etc/ansible/install-elk.yml
- ~$ ansible-playbook /etc/ansible/roles/filebeat-playbook.yml
- ~$ ansible-playbook /etc/ansible/roles/metricbeat-playbook.yml

5. From the Jump-Box-Provisioner, ssh into Web-3(the ELK-Stack-Server) ~$ ssh azadmin@<dynamic-elk-public-ip>
6. In the Elk-Stack-Server run ~$ sudo docker start elk
7. If there are no errors then you can go to http://<dynamic-elk-public-ip>:5601/app/kibana and start monitoring data from Metricbeat and Filebeat from the Web-1 and Web-2 webservers.
