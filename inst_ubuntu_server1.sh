#!/bin/bash

echo "INSTALAÇÃO POSTGRESQL 10.16 UBUNTU_SERVER E DEBIAN Aperte ENTER para continuar"
read #pause até que o ENTER seja pressionado

wget https://ftp.postgresql.org/pub/source/v12.13/postgresql-12.13.tar.gz

tar -zxvf postgresql-12.13.tar.gz

mv postgresql-12.13 /usr/local/src

echo "Será instalado o pacote Buil-Essential clique em ENTER"

apt-get install build-essential -y

cd /usr/local/src

cd postgresql-12.13/

./configure --without-readline --without-zlib --prefix=/usr/local
make 
make
make install
make install

cd /usr/local/src/postgresql-10.16/contrib

make
make
make install
make install

echo "Agora vamos Criar o usuario Postgres"
echo "Digite a senha 123456 confirme a mesma e Aperte ENTER"
echo "Aperte ENTER para continuar"
read

adduser postgres

echo "Agora vamos criar a pasta DATA e atribuir as permissões para a mesma, por padrão vamos deixar a pasta no local /home/cucafresca/cuca/postgresql/10/data"
echo "Aperte ENTER para continuar"
read

mkdir -p /home/cucafresca/cuca/postgresql/10/data
chmod -R 777 /home/cucafresca/cuca/postgresql/10/data
chown -R postgres /home/cucafresca/cuca/postgresql
chmod -R 0700 /home/cucafresca/cuca/postgresql

cd /etc

echo "export PGDATA=/usr/local/bin" >> bash.bashrc
echo "export PGDATA=/home/cucafresca/cuca/postgresql/10/data" >> bash.bashrc

echo "Agora será configurado o locales selecione a opção PT_BR ISO-8859-1 e pt_BR clique em OK "
echo "Caso não selecionar a opção PT_BR ISO-8859-1 o banco não será instalado corretamente"
echo "Aperte ENTER e Selecione a opção PT_BR ISO-8859-1 e pt_BR"
read

dpkg-reconfigure locales

locale -a

echo "Será baixado e instalado o Script para inicialização automática do Postgresql"
echo "Aperte ENTER para continuar"
read

wget https://raw.githubusercontent.com/cucafresca/postgresql-12/main/iniciabanco.sh

wget https://raw.githubusercontent.com/cucafresca/iniciabanco/master/postgresql.service

chmod +x iniciabanco.sh

chmod 777 iniciabanco.sh

mv iniciabanco.sh /etc/systemd/system

mv postgresql.service /etc/systemd/system

cd /etc/systemd/system/

systemctl daemon-reload

systemctl enable postgresql.service

echo "Primeira parte finalizada logue com usuario POSTGRES e execute o script inst_ubuntu_server2.sh"
