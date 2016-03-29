#!/bin/bash

GIT_PROJECT_NAME=${GIT_PROJECT_NAME:-dummy}
GIT_PROJECT_ROOT=${GIT_PROJECT_ROOT:-/var/lib/git}

GIT_PROJECT_PATH=${GIT_PROJECT_ROOT}/${GIT_PROJECT_NAME}.git

# Create new git repo only if not already present
if [ -a ${GIT_PROJECT_PATH} ] ; then
  if [ ! -d ${GIT_PROJECT_PATH} ] ; then
    >&2 echo "File found, but directory expected at path: ${GIT_PROJECT_PATH}"
    exit 1
  elif ! git rev-parse --resolve-git-dir ${GIT_PROJECT_PATH} >/dev/null 2>&1 ; then
    >&2 echo "Directory present, but no git repository found at path: ${GIT_PROJECT_PATH}"
    exit 1
  fi
  echo "Found git repository in ${GIT_PROJECT_PATH}"
elif [ ! -f ${GIT_PROJECT_PATH} ] ; then
  echo "Initialize empty Git repository in ${GIT_PROJECT_PATH}"
  git init --bare ${GIT_PROJECT_PATH}
  cp ${GIT_PROJECT_PATH}/hooks/post-update.sample ${GIT_PROJECT_PATH}/hooks/post-update
  chmod a+x ${GIT_PROJECT_PATH}/hooks/post-update
  pushd ${GIT_PROJECT_PATH} 1>/dev/null 2>&1
  git update-server-info

  echo "${GIT_DESCRIPTION}" > ${GIT_PROJECT_PATH}/description
  git config --file config http.receivepack true
  git config --file config gitweb.owner ${GIT_OWNER}
  popd 1>/dev/null 2>&1
  #chown -R apache ${GIT_PROJECT_PATH}
fi

# httpd won't start correctly if it thinks it is already running.
rm -rf /run/httpd/* /tmp/httpd*

exec /usr/sbin/apachectl -DFOREGROUND
