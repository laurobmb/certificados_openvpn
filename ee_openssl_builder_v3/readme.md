# EE

## Login na redhat
    podman login registry.redhat.io --username lagomes@redhat.com
## Build
    ansible-builder build -t quay.io/lagomes/ee-openvpn:v1 -v 3
## Enviando para o hub
    podman push quay.io/lagomes/ee-openvpn:v1 --tls-verify=false
## Test
    podman container run -it quay.io/lagomes/ee-openvpn:v1 ansible-galaxy collection list 
    podman container run -it quay.io/lagomes/ee-openvpn:v1 pip show boto
    podman container run -it quay.io/lagomes/ee-openvpn:v1 pip3 freeze | grep boto
