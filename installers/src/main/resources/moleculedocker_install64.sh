#!/bin/bash
# Copyright (c) 2015 Boomi, Inc.

ATOM_HOME="/var/boomi"

usage() {
	echo -e "Boomi Docker Installer\n\nusage:\n\nInstall a Molecule\n$0 -n <molecule name> -u <boomi userid> -p <boomi password> -a <boomi accountid>
	-b <boomi container name> -t<port> -h <proxy host> -e <proxy username> -d <proxy password> -r <proxy port>
	-f <docker uid> -i <installation directory> -l <local path> -m <local temp path> -y <symlinks directory> -k <installation token> \n\n
	Add a Molecule node\n$0 -n <molecule name> -b <boomi container name> -s <node suffix> -i <installation directory> -f <docker uid> \n\n " 1>&2; exit 1;
}

molecule() {
    platform=@platformBase@
    if [ `echo $platform | grep 'localhost' | wc -l` -gt 0 ]
    then
        #development only
        hostIP=`ifconfig eth0 | grep 'inet addr:'  | cut  -d: -f2 | awk '{print $1}'`
    fi
    URL=@installHost@
    if [ -z "${containername}" ]; then
        containername=$atomname
    fi
    if [ -z "${port}" ]; then
        port=9090
    fi
    if [ -z "${installationDir}" ]; then
       installationDir=/var/boomi #default molecule installation dir
    fi
    if [ -z "${nodesuffix}" ]
    then
        if !([ -n "${user}" ] && [ -n "${pwd}" ] && [ -n "${accountid}" ] || [ -n "${installToken}" ] )
        then
            echo "Either username with password and accountid or token must be input"
            usage
        fi
        if [ `echo $platform | grep 'localhost' | wc -l` -gt 0 ]
        then
            run_command="docker run -p ${port}:9090 -h ${atomname} --add-host=\"localhost.boomi.com:$hostIP\""
        else
            run_command="docker run -p ${port}:9090 -h ${atomname}"
        fi

        $run_command \
            -e URL=${URL} \
            -e BOOMI_USERNAME=${user} \
            -e BOOMI_PASSWORD=${pwd} \
            -e BOOMI_ATOMNAME=${atomname} \
            -e BOOMI_ACCOUNTID=${accountid} \
            -e BOOMI_CONTAINERNAME="${containername}" \
            -e INSTALLATION_DIRECTORY=${installationDir} \
            -e LOCAL_PATH=${localPath} \
            -e LOCAL_TEMP_PATH=${localTempPath} \
            -e SYMLINKS_DIR=${symlinksDir} \
            -e DOCKERUID=${dockeruid} \
            -e PROXY_HOST=${proxyHost} \
            -e PROXY_USERNAME=${proxyUser} \
            -e PROXY_PASSWORD=${proxyPassword} \
            -e PROXY_PORT=${proxyPort} \
            -e ATOM_LOCALHOSTID=${atomname} \
            -e INSTALL_TOKEN=${installToken} \
            --name ${atomname} \
            -v ${ATOM_HOME}:${installationDir}:Z \
            -d -t @repo@molecule:@moleculeVersion@
    else
        if [ `docker ps |grep ${atomname} | wc -l` -le 0 ]
        then
	        echo -e "Boomi Docker Installer\n\nError:\n\n Cannot add node when there is no docker container running with name ${atomname}\n\n" 1>&2; exit 1;
	    else
	         head_containername=`docker inspect ${atomname} | grep BOOMI_CONTAINERNAME | cut -d"=" -f2 | cut -d'"' -f1`
	         if [ "${head_containername}" != "${containername}" ]
	         then
                 echo -e "Boomi Docker Installer\n\nError:\n\n Cannot add node unless you correctly specify both the atomname as ${atomname} and the containername as ${head_containername}\n\n" 1>&2; exit 1;
             fi
        fi

        if [ `echo $platform | grep 'localhost' | wc -l` -gt 0 ]
        then
            run_command="docker run -h ${atomname}${nodesuffix} --add-host=\"localhost.boomi.com:$hostIP\""
        else
            run_command="docker run -h ${atomname}${nodesuffix}"
        fi

        $run_command \
            -e BOOMI_ATOMNAME=${atomname}${nodesuffix} \
            -e BOOMI_CONTAINERNAME="${containername}" \
            -e INSTALLATION_DIRECTORY=${installationDir} \
            -e DOCKERUID=${dockeruid} \
            -e ATOM_LOCALHOSTID=${atomname}${nodesuffix} \
            --name ${atomname}${nodesuffix} \
            -v ${ATOM_HOME}:${installationDir}:Z \
            -d -t @repo@molecule:@moleculeVersion@
    fi
}


while getopts "u:p:n:a:s:b:t:h:e:d:r:i:l:m:y:f:k:" o; do
    case "${o}" in
        f)
            dockeruid=${OPTARG}
	        ;;
        u)
            user=${OPTARG}
            ;;
        p)
            pwd=${OPTARG}
            ;;
        n)
            atomname=${OPTARG}
            len=`echo -n "$atomname" | wc -c`
            atomname=`echo "$atomname"|sed 's/ //g'`
            newlen=`echo -n "$atomname" | wc -c`
            if [ $newlen != $len ]
            then
                echo "Spaces are not allowed in atom names. Only valid characters for atom name are 0-9, a-z, A-Z, - and _"
                exit
            fi
            if [[ $atomname =~ ^[0-9A-Za-z_\-]+$ ]]
            then
                echo "Processing atom named $atomname"
            else
                echo "Invalid character(s) found in atom name. Only valid characters for atom name are 0-9, a-z, A-Z, - and _"
                exit
            fi
            ;;
        a)
            accountid=${OPTARG}
            ;;
        b)
            containername=${OPTARG}
            ;;
        d)
            proxyPassword=${OPTARG}
            ;;
        e)
            proxyUser=${OPTARG}
            ;;
        h)
            proxyHost=${OPTARG}
            ;;
        i)
            installationDir=${OPTARG}
            ;;
        l)
            localPath=${OPTARG}
            ;;
        m)
            localTempPath=${OPTARG}
            ;;
        r)
            proxyPort=${OPTARG}
            ;;
        s)
            nodesuffix=${OPTARG}
            ;;
        t)
            port=${OPTARG}
            ;;
        y)
            symlinksDir=${OPTARG}
            ;;
        k)
            installToken=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${atomname}" ]; then
    usage
else 
    molecule
fi
