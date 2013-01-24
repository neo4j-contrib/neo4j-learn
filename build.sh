#!/bin/bash -ex

cd $( dirname $0 )
git reset --hard --
git clean -d -x -f 
git pull
mvn clean package -Pneodev

#make preview PROJECT=files
make preview PROJECT=rest
make preview PROJECT=cypher
#make preview PROJECT=java-course
#make preview PROJECT=ops-course
#make preview PROJECT=python-course
#make preview PROJECT=cypher-course

cp -rv target/html/* /var/www/learn.neo4j.org
