#!/bin/bash
echo "Staring configuration."
# reminder of convention:
# UPPER_CASE variables :
# lower_case variables : 
PWD=$(echo pwd)
PATH_TO_LAYERS="${PWD}/layers"
BRANCH="wrynose"
clone_list=("meta-yocto")

echo "Downloading layers needed for the project."
# Download the repositories needed and change to the branch required.
# Currently using Wrynose.

for repo in "${clone_list[@]}"; do

  cd PATH_TO_LAYERS
  if [[ -d ${PATH_TO_LAYERS}/${repo} ]]; then
    echo "repository found at: ${PATH_TO_LAYERS}/${repo}"
  else
    echo " clonning: ${repo} from: https://git.yoctoproject.org/${repo}"
    cd PATH_TO_LAYERS
    git clone https://git.yoctoproject.org/${repo}
    cd ${PATH_TO_LAYERS}/${repo}
    echo " changing branch in ${repo} from $(git branch) to ${BRANCH}"
    git checkout ${BRANCH}
  fi

done

echo "Layers cloned. Configuring environment:"
source ${PWD}/oecore/oe-init-build-env
