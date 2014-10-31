#!/bin/bash -e
function usage()
{
    echo "Usage $0 <stp git repo root>"
    exit 1
}

if [ $# -ne 1 ]; then
    echo "Incorrect number of arguments"
    usage
fi

STP_GIT_DIR="$1"
SCRIPT_DIR="$( cd ${BASH_SOURCE[0]%/*} ; echo "$PWD" )"

if [ ! -d "${STP_GIT_DIR}" ]; then
    echo "\"$1\" is not a directory"
    usage
fi

# sanity check
if [ ! -d "${STP_GIT_DIR}/.git" ]; then
    echo "\"$1\" does not seem to be a git repository"
    exit 1
fi

# Check there is no existing debian directory
if [ -a "${STP_GIT_DIR}/debian" ]; then
    echo "a file within the STP source root with the name debian exists."
    exit 1
fi

# Check the repo is clean
STATUS=$( cd "${STP_GIT_DIR}" && git status --porcelain || echo fail)

if [ -n "${STATUS}" ]; then
    echo "STP git repo is not clean"
    echo ""
    echo "${STATUS}"
    exit 1
fi

VERSION="1.0+1SNAPSHOT$(date +%Y%m%d)"
NAME="stp_${VERSION}.orig.tar.bz2"
FULL_VERSION="${VERSION}-0~trusty1"
echo "Creating snapshot for ${FULL_VERSION}"

echo "Generating tarball"
cd "${STP_GIT_DIR}"
git archive --format=tar HEAD | bzip2 > ../${NAME}
# Adjust changelog

echo "Updating package changelog"
cd "${SCRIPT_DIR}"
dch  --urgency low --maintmaint --distribution trusty --newversion="${FULL_VERSION}" "New snapshot"

# Copy over debian directory
echo "Copying debian directory to \"${STP_GIT_DIR}\""
cp -r debian "${STP_GIT_DIR}/"
