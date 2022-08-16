#!/bin/bash

# set variables here
CHART_NAME="pybliometrics"

# variables
update=false
env='dev'


function start() {
    #set_kubernetes_context
    cd_to_project_directory
    if [ $env == 'dev' ] ; then
        set_local_volume_path
    fi
    install_chart
}

function set_kubernetes_context() {
    kubectl config use-context docker-desktop
}

function cd_to_project_directory() {
   script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
   cd $script_dir
}

function set_local_volume_path() {
   # set LOCAL_VOLUME_PATH based on script directory
   if [[ $script_dir =~ ^(.*)/repository(.*) ]];
   then
      LOCAL_VOLUME_PATH=${BASH_REMATCH[1]}
   else
      echo "Error: I could not set the LOCAL_VOLUME_PATH which must be the path of the project folder!"
      echo "Path structure is fixed! For example: <absolute_path>/<project_name>/repository"
      exit 1
   fi
}

function install_chart() {
    if [ "$update" = true ] ; then
        helm dependency update ./
    fi

    if [ $env == 'dev' ] ; then
        helm install \
        --set localVolumePath=$LOCAL_VOLUME_PATH \
        "$CHART_NAME-dev" ./ -f ./values-local-dev.yaml
    elif [[ $env == 'prod' ]]; then
        helm install $CHART_NAME ./
    fi

    helm list
}

function stop() {
    #set_kubernetes_context
    uninstall_chart
}

function uninstall_chart() {
   # TODO switch dev/prod needed
    #helm uninstall $CHART_NAME
    helm uninstall "$CHART_NAME-dev"
    helm list
}

function help() {
   echo "Run <CHARTNAME> Split."
   echo
   echo "Syntax: ./local-setup.sh <start|stop|-h> <{dev}|prod> [-u]"
   echo "Options:"
   echo " -h|--help     Print this help."
   echo " -u|--update   Update helm dependencies."
   echo
   exit 1
}


while [ $# -gt 0 ]
do
   arg="$1"
   case ${arg} in
      -h|--help|\?)
         help ;;
      -u|--update)
         update=true ;;
      start)
         option=start ;;
      stop)
         option=stop ;;
      dev)
         env='dev' ;;
      prod)
         env='prod' ;;
      *)
         echo "Error: Invalid option"
         help ;;
   esac
   shift 
done

case "$option" in
   start)
      start ;;
   stop)
      stop ;;
   *)
      echo "Error: Invalid option"
      help ;;
esac
