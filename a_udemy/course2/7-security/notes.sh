## Certificate Authority (CA)
openssl genrsa -out ca.key 2048                                     # generate a private key for the CA
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr  # certificate signing request
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt            # self-sign the CA certificate