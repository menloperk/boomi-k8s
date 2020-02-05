#!/bin/bash
# Copyright (c) 2015 Boomi, Inc.

ATOM_HOME="/var/boomi"

usage() {
	echo -e "Boomi Docker Installer\n\nusage:\n\nInstall an Atom\n$0 -n <atom name> -u <boomi userid> -p <boomi password> -a <boomi accountid>
	-h <proxy host> -e <proxy username> -d <proxy password> -r <proxy port> -i <installation directory>
	-f <docker uid> -y <symlinks directory> -t<port> -b <boomi container name> -k <installation token>" 1>&2; exit 1;
}

atom() {
    if !([ -n "${user}" ] && [ -n "${pwd}" ] && [ -n "${accountid}" ] || [ -n "${installToken}" ] )
    then
        echo "Either username with password and accountid or token must be input"
        usage
    fi

    URL=@installHost@
    if [ -z "${containername}" ]; then
        containername=$atomname
    fi
    if [ -z "${port}" ]; then
        port=9090
    fi
    if [ -z "${installationDir}" ]; then
       installationDir=/var/boomi #default atom installation dir
    fi
    platform=@platformBase@
    if [ `echo $platform | grep 'localhost' | wc -l` -gt 0 ]
    then
        hostIP=`ifconfig eth0 | grep 'inet addr:'  | cut  -d: -f2 | awk '{print $1}'`
        run_command="docker run -p ${port}:9090 -h ${atomname} --add-host=\"localhost.boomi.com:$hostIP\""
    else
        run_command="docker run -p ${port}:9090 -h ${atomname}"
    fi

    $run_command \
        -e URL=${URL} \
        -e BOOMI_USERNAME=${user} \
        -e BOOMI_PASSWORD=${pwd} \
        -e BOOMI_ATOMNAME=${atomname} \
        -e BOOMI_CONTAINERNAME="${containername}" \
        -e BOOMI_ACCOUNTID=${accountid} \
        -e PROXY_HOST=${proxyHost} \
        -e PROXY_USERNAME=${proxyUser} \
        -e PROXY_PASSWORD=${proxyPassword} \
        -e PROXY_PORT=${proxyPort} \
        -e INSTALLATION_DIRECTORY=${installationDir} \
        -e DOCKERUID=${dockeruid} \
        -e SYMLINKS_DIR=${symlinksDir} \
        -e ATOM_LOCALHOSTID=${atomname} \
        -e INSTALL_TOKEN=${installToken} \
        --name ${atomname} \
        -v ${ATOM_HOME}:${installationDir}:Z \
        -d -t @repo@atom:@atomVersion@

}

while getopts "u:p:n:a:h:e:d:r:i:f:y:t:b:k:" o; do
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
        r)
            proxyPort=${OPTARG}
            ;;
        y)
            symlinksDir=${OPTARG}
            ;;
        t)
            port=${OPTARG}
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
    atom
fi
