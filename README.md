# Generate CA and Certificate

This project aims to facilitate the creation of a certification entity and a few more certificates signed by that same entity, CA Certificate Authority, the project runs within an execution and sends the certificates to the destination hosts.

This project aims to facilitate the creation of the necessary files to set up a VPN using OpenVPN.

This branch is intended to prepare a Raspberry Pi using RaspbianOS to use OpenVPN and create the certificates and keys for the server and client. An image was also created to automate the process in the Redhat Ansible Automation Platform.

* Update the package list
* Install OpenVPN
* Create directory /etc/openvpn/ssl
* Execute the certificate role
	* Create the OpenVPN TLS key
	* Create the DH key
	* Create a CA
	* Create the server certificate, signed by the CA
	* Create client certificates, signed by the CA
	* Create server configuration files and place them in the /etc/openvpn/server/ directory
	* Create client configuration files and place them in the /etc/openvpn/clients/ directory
* Enable routing in RaspbianOS
* Apply configurations in sysctl
* Start and enable the created client services

## Build Execution
	ansible-builder build -t quay.io/lagomes/ee-openvpn:v1 -v 3
## Execute navigator
	ansible-navigator run main.yml -l raspibery