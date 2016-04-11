#!/bin/bash
BASE_DIR="./eucalyptus_dependencies"
PYTHON_CACHE_DIR="$BASE_DIR/python_cache"
VIRT_ENV="virtual_env"
DEST_ARCHIVE="eucalyptus_dependencies.tar.gz"
CALYPTOS_GIT="https://github.com/eucalyptus/calyptos.git"
CALYPTOS_BRANCH="master"
NEPHORIA="https://github.com/nephomaniac/nephoria.git"
NEPHORIA_BRANCH="master"
ADMIN_API_GIT="https://github.com/nephomaniac/adminapi.git"
ADMINAPI_BRANCH="master"
EXTRA_RPMS="
gcc
python-virtualenv
python-pip
python-devel
git
python-setuptools"
PIP_PKGS="
calyptos
adminapi
"
echo $EXTRA_RPMS |  xargs -n1 yum install -y --downloadonly --downloaddir=$BASE_DIR
yum search -q eucalyptus | awk '{print $1}' | xargs -n1 yum install -y --downloadonly --downloaddir=$BASE_DIR

# CREATE VIRTUAL ENV
yum -q list installed python-virtualenv
if [ $? -ne 0 ]; then
  yum install $BASE_DIR/python-virtualenv*
fi


cd $BASE_DIR
virtualenv $VIRT_ENV
cd $VIRT_ENV
source bin/activate
echo $PIP_PKGS | xargs -n1 pip install

#GIT INSTALLS
yum -q list installed git
if [ $? -ne 0 ]; then
   yum install $BASE_DIR/git
 fi
git clone $CALYPTOS_GIT
cd calyptos && python setup.py install; cd -




tar -cvzf $DEST_ARCHIVE  $BASE_DIR/