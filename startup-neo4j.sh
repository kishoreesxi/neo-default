#! /bin/bash

sudo yum update

rpm --import https://debian.neo4j.com/neotechnology.gpg.key

cat <<EOF > /etc/yum.repos.d/neo4j.repo
[neo4j]
name=Neo4j Yum Repo
baseurl=http://yum.neo4j.com/stable
enabled=1
gpgcheck=1
EOF

sudo yum install https://dist.neo4j.org/neo4j-java11-adapter.noarch.rpm

#Use "NEO4J_ACCEPT_LICENSE_AGREEMENT=yes" falg to accept license agreement during installation
#for enterprise edition.
NEO4J_ACCEPT_LICENSE_AGREEMENT=yes yum -y install neo4j-enterprise-4.0.4

#community verison
#sudo yum -y install neo4j-4.0.4

sed -i 's/#dbms.default_listen_address=0.0.0.0/dbms.default_listen_address=0.0.0.0/g' /etc/neo4j/neo4j.conf

sudo systemctl enable neo4j
sudo systemctl start neo4j

sudo chown -R --verbose neo4j /var/log/neo4j
sudo chown -R --verbose neo4j /var/lib/neo4j