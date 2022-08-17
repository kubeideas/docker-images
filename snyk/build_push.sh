#!/bin/bash


## variables
REPOSITORY=$1
SNYK_VERSION=$2
IMG="${REPOSITORY}/snyk:${SNYK_VERSION}"


check_args () {

  if [ $# -ne 2 ]
   then
     echo "Invalid arguments!"
     echo "Usage: $(basename $0) <RESPOSITORY> <SNYK-VERSION>"
     echo "Ex: $(basename $0) docker.io/kubeideas v0.1.0"
     exit 2
  fi

}

## Check commands return code
check_cmd_exit() {
  if [ $1 -ne 0 ]
    then
      echo ""
      echo "Something went wrong!"
      echo "Please check parameters."
      echo ""
      exit 1
  fi
}

build_image () {

  docker build --rm -t ${IMG} ./
  check_cmd_exit $?

  docker scan ${IMG}
  check_cmd_exit $?  

  docker push ${IMG}
  check_cmd_exit $?

}


## MAIN ##
check_args $@
build_image

