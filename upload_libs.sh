#!/bin/sh
#
function upload {
  openssl dgst -sha1 $1 >> ../sha1.txt
  tar czf $1.tar.gz -L $1
  scp $1.tar.gz bcs:/www/biosignalml/binaries/src/plugins/api/BioSignalMLAPI/$2
  }
#
rm -rf /Users/dave/build/OpenCOR/src/plugins/api/BioSignalMLAPI/include/biosignalml/*
rm -rf /Users/dave/build/OpenCOR/src/plugins/api/BioSignalMLAPI/include/typedobject/*
cp -pr /Users/dave/biosignalml/libbsml/include/biosignalml/*        \
       /Users/dave/build/OpenCOR/src/plugins/api/BioSignalMLAPI/include/biosignalml
cp -pr /Users/dave/biosignalml/typedobject/include/typedobject/*    \
       /Users/dave/build/OpenCOR/src/plugins/api/BioSignalMLAPI/include/typedobject
#
rm -rf /tmp/upload
mkdir -p /tmp/upload/release
mkdir -p /tmp/upload/debug
#
cp /Users/dave/biosignalml/libbsml/win64/biosignalml.lib          /tmp/upload/release
cp /Users/dave/biosignalml/libbsml/win64/biosignalml.dll          /tmp/upload/release
cp /Users/dave/biosignalml/typedobject/win64/typedobject.lib 	  /tmp/upload/release
cp /Users/dave/biosignalml/typedobject/win64/typedobject.dll 	  /tmp/upload/release
#
cp /Users/dave/biosignalml/libbsml/win64d/biosignalml_d.lib       /tmp/upload/debug/biosignalml.lib
cp /Users/dave/biosignalml/libbsml/win64d/biosignalml_d.dll       /tmp/upload/debug/biosignalml.dll
cp /Users/dave/biosignalml/typedobject/win64d/typedobject_d.lib   /tmp/upload/debug/typedobject.lib
cp /Users/dave/biosignalml/typedobject/win64d/typedobject_d.dll   /tmp/upload/debug/typedobject.dll
#
cp /Users/dave/biosignalml/libbsml/osx/libbiosignalml.0.dylib     /tmp/upload/release
cp /Users/dave/biosignalml/typedobject/osx/libtypedobject.1.dylib /tmp/upload/release
#
cp /Users/dave/biosignalml/libbsml/ubuntu/libbiosignalml.so.0     /tmp/upload/release
cp /Users/dave/biosignalml/typedobject/ubuntu/libtypedobject.so.1 /tmp/upload/release
#
pushd /tmp/upload > /dev/null
#
rm -f sha1.txt
cd ./release
echo "RELEASE" >> ../sha1.txt
upload  biosignalml.dll windows/release/
upload  biosignalml.lib windows/release/
upload  typedobject.dll windows/release/
upload  typedobject.lib windows/release/
cd ../debug
echo "DEBUG" >> ../sha1.txt
upload  biosignalml.dll windows/debug/
upload  biosignalml.lib windows/debug/
upload  typedobject.dll windows/debug/
upload  typedobject.lib windows/debug/
#
cd ../release
echo "RELEASE" >> ../sha1.txt
upload  libbiosignalml.0.dylib osx/
upload  libtypedobject.1.dylib osx/
#
echo "" >> ../sha1.txt
upload  libbiosignalml.so.0 linux/
upload  libtypedobject.so.1 linux/
#
more ../sha1.txt
popd > /dev/null
