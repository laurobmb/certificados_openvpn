# EE

## Login na redhat
    podman login hub.aap.rhbr-lab.com -u admin -p redhat --tls-verify=false
## Build
    ansible-builder build -t quay.io/lagomes/ee-openssl-rhel8:v1 -v 3
## Enviando para o hub
    podman push quay.io/lagomes/ee-openssl-rhel8:v1 --tls-verify=false
## Test
    podman container run -it quay.io/lagomes/ee-openssl-rhel8:v1 ansible-galaxy collection list 
    podman container run -it quay.io/lagomes/ee-openssl-rhel8:v1 pip show boto
    podman container run -it quay.io/lagomes/ee-openssl-rhel8:v1 pip3 freeze | grep boto
