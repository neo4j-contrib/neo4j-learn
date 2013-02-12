#!/bin/bash -ex

cd $( dirname $0 )
git reset --hard --
git clean -d -x -f 
git pull
mvn clean license:format package

make init preview project_name=java-hello-world
make init preview project_name=java-cypher

cp -rv target/html5/*/ /var/www/learn.neo4j.org
