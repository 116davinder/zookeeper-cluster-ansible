#!/bin/bash

# change to output certs dir based on $1 or current directory
cert_path=$( cd "$(dirname "${BASH_SOURCE[1]}")" ; pwd -P )

key_pass="IdontKnow"
key_size=4096
key_alg="RSA"

for zook_host in 1 2 3
do
    echo
    echo "------------------------------------------------"
    echo "Generating Keystore for zookeeper$zook_host.localhost with RSA 4096"
    keytool -genkeypair -alias "zookeeper$zook_host.localhost" \
        -keyalg "$key_alg" -keysize $key_size -dname "cn=zookeeper$zook_host.localhost" \
        -keypass "$key_pass" \
        -keystore "$cert_path/keystore-zookeeper$zook_host.localhost.jks" \
        -storepass "$key_pass" \
        -validity 9999 \
        -ext san=ip:192.168.56.11$zook_host,dns:zookeeper$zook_host.localhost,dns:localhost,dns:*.localhost

    echo
    echo "------------------------------------------------"
    echo "Extracting Cert. for zookeeper$zook_host.localhost from Keystore"
    keytool -exportcert -alias "zookeeper$zook_host.localhost" \
        -keystore "$cert_path/keystore-zookeeper$zook_host.localhost.jks" \
        -file "$cert_path/zookeeper$zook_host.localhost.cer" -storepass "$key_pass" -rfc

    echo
    echo "------------------------------------------------"
    echo "Merge certs into One Truststore with Hostname"
    keytool -importcert -alias "zookeeper$zook_host.localhost" \
        -file "$cert_path/zookeeper$zook_host.localhost.cer" \
        -keystore "$cert_path/truststore.jks" \
        -storepass "$key_pass" -noprompt

    echo
    echo "------------------------------------------------"
    echo "Merge certs into One Truststore with IP"
    keytool -importcert -alias "192.168.56.11$zook_host" \
        -file "$cert_path/zookeeper$zook_host.localhost.cer" \
        -keystore "$cert_path/truststore.jks" \
        -storepass "$key_pass" -noprompt

    echo
    echo "------------------------------------------------"
    echo "Merge keystores into One Keystore"
    keytool -importkeystore \
        -srckeystore "$cert_path/keystore-zookeeper$zook_host.localhost.jks" \
        -destkeystore "$cert_path/keystore.jks" \
        -srcstorepass "$key_pass" \
        -deststorepass "$key_pass" \
        -noprompt
done


echo
echo "------------------------------------------------"
echo "Merge certs into One CA Crt, will be used to scrap admin endpoint"
echo "------------------------------------------------"
cat *.cer >> zookeeper-all.crt

echo
echo "------------------------------------------------"
echo "Print Number of Private keys in Unified Keystore"
echo "------------------------------------------------"
keytool -list -keystore "$cert_path/keystore.jks" -storepass "$key_pass"

echo
echo "------------------------------------------------"
echo "Print Number of Certs in Truststore"
echo "------------------------------------------------"
keytool -list -keystore "$cert_path/truststore.jks" -storepass "$key_pass"

# echo
# echo "------------------------------------------------"
# echo "Print Certs Details in All.crt"
# echo "------------------------------------------------"
# keytool -printcert -file "$cert_path/zookeeper-all.crt" | grep -A 10 "Certificate\["

# echo remove certs
rm -rf *.cer