NO_LOCK_REQUIRED=true

. ./.env
. ./.common.sh

PARAMS=""

lockableGitFile="zuerreotype.tar"
export LOCK_VERSION="${LAST_COMMIT}"

# Build and run containers and network
echo "${lockableGitFile}" >${LOCK_FILE}
echo "${LOCK_VERSION}" >>${LOCK_FILE}

echo "${bold}*************************************"
echo "Locking ${LOCK_VERSION}"
echo "*************************************${normal}"
echo $(date)
echo "--------------------"

echo "zuerreotype"
${lockableGitFile}
