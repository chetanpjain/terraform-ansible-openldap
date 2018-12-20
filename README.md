Please note the security groups are kept very open here, please change that

# terraform-ansible-openldap
Creation of AWS instances with terraform, installation and setup of openldap via Ansible, user creation and deletion automation

ldap-ansible
cd terraform_ansible

terraform init
terraform plan
terraform apply

Steps :

Install terraform on your local system which has access to Internet
git pull this repository
cd terraform_ansible
terraform init
terraform plan
terraform apply
This will create the needed resources on AWS for you, and now we will use ansible as a configuration management tool which will configure LDAP Master, 2 LDAP slaves, and 2 LDAP clients

above terraform setup will also install ansible on the ldap master host at location /etc/ansible

Now, pull the code repository on the ldap-master at location of your preference

for that first install git and then perform below steps :

-- sudo yum install git -- git clone URL -- cd ldap_ansible -- git pull

7.copy the ansible directory from the code checked out to this location : sudo cp -r terraform_ansible/ansible /etc/

8.modify the hosts file in ansible directory (this is the inventory file for ansible) with the internal IP's of all the EC2 instances as below, you will have to find out internal IP's of all 5 instances we have created :

##First Internal IP's of all the servers
10.0.0.11
10.0.0.164
10.0.0.130
10.0.0.114
10.0.0.187
[master]
10.0.0.11  # ip of ldap master

[slaves]
10.0.0.164  # ip of ldap slave1
10.0.0.130  # ip of ldap slave 2
you can look at the hosts file in the code repository as a reference to modify this file.

all the variables are placed at : /etc/ansible/group_vars/all file.

modify values for below variables in this file as per the new IP's :

ldap_master_url: ldap://10.0.0.121:389/    ##master
ldap_server_one: ldap://10.0.0.121:389/    ##master
ldap_server_two: ldap://10.0.0.148:389/    ## slave1
ldap_server_three: ldap://10.0.0.183:389/   ## slave2
ldap_uri: ldap://10.0.0.121:389/ ldap://10.0.0.148:389/ ldap://10.0.0.183:389/
Step 9: Perform this step only if you are setting up the environment for the first time, change the value of clean_all: true in file /etc/ansible/group_vars/all file so that ansible understands this is first time setup, once setup is complete change the value back to false so that on next run it does not overwrite anything

Step 10 : you can also update the file : /etc/ansible/group_vars/all with the list of users to be added in the LDAP, refer to the sample file in the repository, users have to be added in the same manner in that file, the users which are supposed to be deleted will be present under user_remove paramter as per the given format in the file

for e.g

user_present:
  vault_test:
    userid: vault_test
    userPassword: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          38353632613736363031323535643336383934636566643462626437613035326432373732386339
          6533363462393766306566386339373431646436303439610a316439323835396138653530343039
          33653532393835306364383838623238663231646339373339393738623637373866653335383963
          6637303161376433640a393932653333636536336365643537373835643237626130646637373131
          6533
    cn: Vault Test
    uid: 16858
    gid: 100
    homedir: /home/vault_test
    
  user_remove:
    - testuser
Please see :

while updating the variables file : /etc/ansible/groups_var/all if you have any sensitive information, then you can vault like below. for e.g : I am creating a LDAP user vault_test and its password needs to be secured which is Password@1, so we will encrypt the string Password@1 as below

ansible-vault encrypt_string Password@1

this will prompt for vault password, provide the password and store it somewhere for future use (we will need it while running the playbook), you will get the encrypted value for above string as a output in below format:

!vault |
          $ANSIBLE_VAULT;1.1;AES256
          38353632613736363031323535643336383934636566643462626437613035326432373732386339
          6533363462393766306566386339373431646436303439610a316439323835396138653530343039
          33653532393835306364383838623238663231646339373339393738623637373866653335383963
          6637303161376433640a393932653333636536336365643537373835643237626130646637373131
          6533
use this value in the variable file for the value of the paramter, like below..you can use this for all the paramters which needs to be secured :

 vault_test:
    userid: vault_test
    userPassword: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          38353632613736363031323535643336383934636566643462626437613035326432373732386339
          6533363462393766306566386339373431646436303439610a316439323835396138653530343039
          33653532393835306364383838623238663231646339373339393738623637373866653335383963
          6637303161376433640a393932653333636536336365643537373835643237626130646637373131
          6533
    cn: Vault Test
    uid: 16858
    gid: 100
    homedir: /home/vault_test
Step 11 : once this is done you can run the below ansible command to setup everything for you, needs to be run from /etc/ansible directory always :

ansible-playbook -u centos --private-key /tmp/sshkey site.yml --become --ask-vault-pass
here it will prompt for the password that you had stored somewhere in previous step, and the playbook execution will complete.

Few Notes :

If the password needs to be changed for the user, we can have either a shell script doing that or use phpldapadmin UI for doing that change, Other work around is drop the user and re-create it with the new password using our ansible playbook

For the group thing, we can have similar playbook for LDAP the way we have users and can add certain users to the group and can control the authorization from there.

sudoers can be implemented, that needs a new task to be written, will update it here shortly.

to view encrypted values, paste that value in a file as below :

vi test.yml
$ANSIBLE_VAULT;1.1;AES256
38353632613736363031323535643336383934636566643462626437613035326432373732386339
6533363462393766306566386339373431646436303439610a316439323835396138653530343039
33653532393835306364383838623238663231646339373339393738623637373866653335383963
6637303161376433640a393932653333636536336365643537373835643237626130646637373131
6533

then run : sudo ansible-vault view test.yml
It will prompt for a password, enter it and you will get the decrypted value
