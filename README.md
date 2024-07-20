# Generate CA and Certificate

This project aims to facilitate the creation of a certification entity and a few more certificates signed by that same entity, CA Certificate Authority, the project runs within an execution and sends the certificates to the destination hosts.

This project aims to facilitate the creation of the necessary files to set up a VPN using OpenVPN.

This branch is intended to prepare a Raspberry Pi using RaspbianOS to use OpenVPN and create the certificates and keys for the server and client. An image was also created to automate the process in the Redhat Ansible Automation Platform.

[x] Update the package list
[x] Install OpenVPN
[x] Create directory /etc/openvpn/ssl
[x] Execute the certificate role
	[x] Create the OpenVPN TLS key
	[x] Create the DH key
	[x] Create a CA
	[x] Create the server certificate, signed by the CA
	[x] Create client certificates, signed by the CA
	[x] Create server configuration files and place them in the /etc/openvpn/server/ directory
	[x] Create client configuration files and place them in the /etc/openvpn/clients/ directory
[x] Enable routing in RaspbianOS
[x] Apply configurations in sysctl
[x] Start and enable the created client services


## Build Execution
	ansible-builder build -t quay.io/lagomes/ee-openvpn:v1 -v 3
## Execute navigator
	ansible-navigator run main.yml -l raspibery