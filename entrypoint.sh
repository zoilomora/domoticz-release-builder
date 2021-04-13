#!/bin/bash

cd /tmp || exit

# Build Support for OpenZWave 1.6+
git clone https://github.com/domoticz/open-zwave open-zwave-read-only
cd open-zwave-read-only || exit
make
make install
cd ..

# Compile Domoticz
git clone https://github.com/domoticz/domoticz.git dev-domoticz
cd dev-domoticz || exit
cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
make
cd ..

# Generate tar.gz
mkdir release
cd dev-domoticz || exit
cp -r Config/ ../release/
cp -r dzVents/ ../release/
cp -r plugins/ ../release/
cp -r scripts/ ../release/
cp -r www/ ../release/
cp domoticz ../release/
cp domoticz.sh ../release/
cp History.txt ../release/
cp License.txt ../release/
cp server_cert.pem ../release/
cp updatebeta ../release/
cp updatebeta ../release/
cp updaterelease ../release/

cd /tmp/release
tar czvf /output/domoticz-release.tar.gz *
