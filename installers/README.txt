Uploading docker images to hub
------------------------------

1) Build the docker images
    cd src/java8
    docker build -t boomi/java8 .
    cd src/install
    docker build -t boomi/install:<version> .
    cd src/atom
    docker build -t boomi/atom:<version> .
    cd src/cloud
    docker build -t boomi/cloud:<version> .
    cd src/molecule
    docker build -t boomi/molecule:<version> .

2) Use the "docker images" command to find the image id for each one


You can view the tags for the images on dockerhub at
https://hub.docker.com/r/boomi/atom/tags/
https://hub.docker.com/r/boomi/molecule/tags/
https://hub.docker.com/r/boomi/cloud/tags/

Tips and tricks
---------------

To see running containers
	docker ps
	
To see all containers 
	docker ps -a
	
To see running processes in a container
	docker top <container name>
	
To exec into a running container and obtain a bash session
	docker exec -it <container name> /bin/bash



Example startup:
  ./clouddocker_install64.sh -n dockerCloud -u username@x.com -p xxx -a account1 -c '11111111-9999-aaaa-bbbb-d75f4a0ea428'
  ./moleculedocker_install64.sh -n dockerMolecule -u username@x.com -p xxx -a account1
  ./atomdocker_install64.sh -n dockerAtom -u username@x.com -p xxx -a account1
