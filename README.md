tripleo-upgrade-automation
========================

This is a set of playbooks to perform automatic minor updates and major upgrades for TripleO. It is specially designed for upgrades between 8 and 10 versions, and it is tightly coupled with https://github.com/redhat-nfvpe/rhel-local-mirrors , that can be used to create local repositories to upgrade your system.

----------

How to start using it
-------------

The playbooks are intented to run in a deployed TripleO. They will execute several tasks, focused on the **undercloud**. You need to run the playbooks on the hypervisor containing the undercloud:

 - cd /opt
 - git clone https://github.com/redhat-nfvpe/tripleo-upgrade-automation
 - export ANSIBLE_SSH_ARGS="-F /home/stack/quickstart/ssh.config.ansible"
 - export ANSIBLE_CONFIG=/home/stack/quickstart/ansible.cfg 
 - Create a hosts file, that will contain just an entry for the undercloud - vim hosts:

> localhost
> ansible_connection=local undercloud

Once these steps are defined, you have several playbooks for either executing minor updates, or major upgrades, in undercloud or overcloud.

Perform minor updates on the undercloud
-------------
First, create a vars.yml file, that needs to contain the following information:

> current_repo_url: http://url/to/your/local.repo
> current_repo_name:  local.repo

The *current_repo_url* setting will be used to create an entry in **/etc/yum.repos.d**, with the *current_repo_name* filename.
For a minor update, this repository needs to match with the current version of the deployed undercloud, but shall contain the latest updated packages.
After the vars.yaml is defined, execute this command, on the */opt/tripleo-upgrade-automation* directory:

> ansible-playbook minor-undercloud-update.yml -e @./vars.yml -i ./hosts

 This will update the undercloud to the latest packages in the same version.

 Perform minor updates on the overcloud
-------------
The process will be similar as the minor update on the undercloud, and you could reuse the same vars.yml file. The playbook that needs to be executed is the following:

> ansible-playbook minor-overcloud-update.yml -e @./vars.yml -i ./hosts

This will update the overcloud to the latest packages in the same version.

Perform major upgrades on the undercloud
-------------
This will be the process of upgrading the undercloud to a newer version. You need to create a new vars.yml file, that will contain the following information:

> current_repo_url: http://url/to/your/local.repo
> current_repo_name: local.repo
> previous_repo_name: previous.repo

In this case, the *current_repo_url* and *current_repo_name* need to be the url and name for the repositories for the next release. While *previous_repo_name* need to be the name of the repository you are currently using (so the playbook is able to disable the repository properly)
After you have defined this vars.yml file, you just need to execute this playbook:

> ansible-playbook major-undercloud-upgrade.yml -e @./vars.yml -i ./hosts

This will upgrade the undercloud to the next version.

Perform major upgrades on the overcloud
-------------
The process will be similar as the major upgrade on the undercloud, and you could reuse the same vars.yml file. The playbook that needs to be executed is the following:

> ansible-playbook major-overcloud-upgrade.yml -e @./vars.yml -i ./hosts

This will upgrade the overcloud to the next version.
