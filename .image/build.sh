#!/bin/bash

# set image name
IMAGE_NAME="guenltu/sandbox:pybliometrics"

# variables
push=false
dev=true
nocache=''


function build() {
   cd_to_project_directory
   read_current_version
   build_image
}

function cd_to_project_directory() {
   script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
   cd $script_dir/..
}

function read_current_version() {
   version=$(grep -E '^appVersion: [0-9]+\.[0-9]+\.[0-9]+' ./.chart/Chart.yaml)
   version="${version/'appVersion: '/}"
}

function build_image() {
   image_tag=$IMAGE_NAME-$version

   if [ "$dev" = true ] ; then
      image_tag="$image_tag-dev"
      echo "Building development image $image_tag"
      docker build --ssh default $nocache --target dev --force-rm --tag $image_tag --file ./.image/Dockerfile .
   else
      echo "Building production image $image_tag"
      docker build --ssh default $nocache --target prod --force-rm --tag $image_tag --file ./.image/Dockerfile .
   fi

   if [ "$push" = true ] ; then
      docker push $image_tag
   fi
}

function help() {
   echo "Build the $IMAGE_NAME."
   echo
   echo "Syntax: ./build.sh <{dev}|prod> [-h|-p|-c]"
   echo "Options:"
   echo " -h|--help        Print this help."
   echo " -p|--push        Push image to Docker Hub."
   echo " -c|--nochache    Build without cache."
   echo
   exit 1
}


while [ $# -gt 0 ]
do
   arg="$1"
   case ${arg} in
      -h|--help|\?)
         help ;;
      -p|--push)
         push=true ;;
      -c|-nocache)
         nocache='--no-cache' ;;
      dev)
         dev=true ;;
      prod)
         dev=false ;;
      *)
         echo "Error: Invalid option"
         help ;;
   esac
   shift 
done

build
