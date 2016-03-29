#!/bin/bash
# ------------------------------------------------------------------------
#
# Copyright 2016 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# ------------------------------------------------------------------------

set -e

pushd /mnt > /dev/null
addgroup wso2
adduser --system --shell /bin/bash --gecos 'WSO2User' --ingroup wso2 --disabled-login wso2user
apt-get update && apt-get install -y unzip wget
wget -nH -r -e robots=off --reject "index.html*" -A "jdk*.tar.gz" -nv ${HTTP_PACK_SERVER}/
wget -nH -e robots=off --reject "index.html*" -nv ${HTTP_PACK_SERVER}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}.zip
echo "unpacking ${WSO2_SERVER}-${WSO2_SERVER_VERSION}.zip to /mnt"
unzip -q /mnt/${WSO2_SERVER}-${WSO2_SERVER_VERSION}.zip -d /mnt
mkdir -p /opt/java
echo "unpacking the JDK to /opt/java"
tar -xf /mnt/jdk* -C /opt/java --strip-components=1
rm -rf /mnt/${WSO2_SERVER}-${WSO2_SERVER_VERSION}.zip
rm -rf /mnt/jdk*
apt-get purge -y --auto-remove wget unzip
rm -rfv /var/lib/apt/lists/*
chown wso2user:wso2 /usr/local/bin/*
chown -R wso2user:wso2 /mnt

cat > /etc/profile.d/set_java_home.sh << EOF
export JAVA_HOME="/opt/java"
export PATH="/opt/java/bin:\$PATH"
EOF

popd > /dev/null
