#!/bin/bash
echo "Staring configuration."
# reminder of convention:
# UPPER_CASE variables :
# lower_case variables : 
PWD_PATH=$(pwd)
PATH_TO_LAYERS="${PWD}/layers"
BRANCH="scarthgap"
layers_list=()
repos_list=()

git clone -b "${BRANCH}" "https://github.com/juan294949/poky.git"
git clone -b "${BRANCH}" "https://github.com/juan294949/meta-zybo.git"

echo "Configuring environment:"
source ${PWD_PATH}/oecore/oe-init-build-env

# Repositories needed for the project.
while IFS= read -r line
  do
    repos_list+=$line
done < ${PWD_PATH}/configuration/repos_list.txt

echo "Downloading repos needed for the project."
# Download the repositories needed and change to the branch required.
# Currently using scarthgap.

for repo in "${repos_list[@]}"; do
  if [[ -d ${PATH_TO_LAYERS}/${repo} ]]; then
    echo "repository found at: ${PATH_TO_LAYERS}/${repo}"
  else
    echo " clonning: ${repo} from: ${repo}"
    git clone -b "${BRANCH}" "${repo}" "${PATH_TO_LAYERS}/${repo}"
  fi
done

# Layers to add in the bblayer.conf file.
while IFS= read -r line
  do
    bitbake-layers add-layer "${PATH_TO_LAYERS}/${repo}/${line}"
done < ${PWD_PATH}/configuration/layers_list.txt

cd $PWD_PATH
