#!/bin/bash -ex

cd $( dirname $0 )
git reset --hard --
git clean -d -x -f 
git pull
mvn clean license:format package

make preview PROJECT=java-hello-world
make preview PROJECT=java-cypher

cp -rv target/html/* /var/www/learn.neo4j.org
