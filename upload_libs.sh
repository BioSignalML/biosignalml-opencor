#!/bin/sh
#
BIOSIGNALML_VERSION=0.8
TYPEDOBJECT_VERSION=1.1
#
RETRIEVE='RETRIEVE_BINARY_FILE_FROM("http://biosignalml.org/binaries" ${RELATIVE_PROJECT_SOURCE_DIR}'
#
function upload {
  SHA1="$(openssl dgst -sha1 $1 | sed 's/SHA1(.*)= //')"
  echo "        $RETRIEVE $3 $SHA1)" >> ../sha1.cmake
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
cp /Users/dave/biosignalml/libbsml/win64/biosignalml.lib          /tmp/upload/release/biosignalml.$BIOSIGNALML_VERSION.lib
cp /Users/dave/biosignalml/libbsml/win64/biosignalml.dll          /tmp/upload/release/biosignalml.$BIOSIGNALML_VERSION.dll
cp /Users/dave/biosignalml/typedobject/win64/typedobject.lib 	  /tmp/upload/release/typedobject.$TYPEDOBJECT_VERSION.lib
cp /Users/dave/biosignalml/typedobject/win64/typedobject.dll 	  /tmp/upload/release/typedobject.$TYPEDOBJECT_VERSION.dll
#
cp /Users/dave/biosignalml/libbsml/win64d/biosignalml_d.lib       /tmp/upload/debug/biosignalml.$BIOSIGNALML_VERSION.lib
cp /Users/dave/biosignalml/libbsml/win64d/biosignalml_d.dll       /tmp/upload/debug/biosignalml.$BIOSIGNALML_VERSION.dll
cp /Users/dave/biosignalml/typedobject/win64d/typedobject_d.lib   /tmp/upload/debug/typedobject.$TYPEDOBJECT_VERSION.lib
cp /Users/dave/biosignalml/typedobject/win64d/typedobject_d.dll   /tmp/upload/debug/typedobject.$TYPEDOBJECT_VERSION.dll
#
cp /Users/dave/biosignalml/libbsml/osx/libbiosignalml.$BIOSIGNALML_VERSION.dylib     /tmp/upload/release
cp /Users/dave/biosignalml/typedobject/osx/libtypedobject.$TYPEDOBJECT_VERSION.dylib /tmp/upload/release
#
cp /Users/dave/biosignalml/libbsml/ubuntu/libbiosignalml.so.$BIOSIGNALML_VERSION     /tmp/upload/release
cp /Users/dave/biosignalml/typedobject/ubuntu/libtypedobject.so.$TYPEDOBJECT_VERSION /tmp/upload/release
#
pushd /tmp/upload > /dev/null
#
rm -f sha1.cmake
#
cd ./release
echo "IF(WIN32)" >> ../sha1.cmake
echo "    IF(RELEASE_MODE)" >> ../sha1.cmake
upload  biosignalml.$BIOSIGNALML_VERSION.dll windows/release/ biosignalml.\${BIOSIGNALML_VERSION}.dll
upload  biosignalml.$BIOSIGNALML_VERSION.lib windows/release/ biosignalml.\${BIOSIGNALML_VERSION}.lib
upload  typedobject.$TYPEDOBJECT_VERSION.dll windows/release/ typedobject.\${TYPEDOBJECT_VERSION}.dll
upload  typedobject.$TYPEDOBJECT_VERSION.lib windows/release/ typedobject.\${TYPEDOBJECT_VERSION}.lib
#
cd ../debug
echo "    ELSE()" >> ../sha1.cmake
upload  biosignalml.$BIOSIGNALML_VERSION.dll windows/debug/ biosignalml.\${BIOSIGNALML_VERSION}.dll
upload  biosignalml.$BIOSIGNALML_VERSION.lib windows/debug/ biosignalml.\${BIOSIGNALML_VERSION}.lib
upload  typedobject.$TYPEDOBJECT_VERSION.dll windows/debug/ typedobject.\${TYPEDOBJECT_VERSION}.dll
upload  typedobject.$TYPEDOBJECT_VERSION.lib windows/debug/ typedobject.\${TYPEDOBJECT_VERSION}.lib
echo "    ENDIF()" >> ../sha1.cmake
#
cd ../release
echo "ELSEIF(APPLE)" >> ../sha1.cmake
upload  libbiosignalml.$BIOSIGNALML_VERSION.dylib osx/ libbiosignalml.\${BIOSIGNALML_VERSION}.dylib
upload  libtypedobject.$TYPEDOBJECT_VERSION.dylib osx/ libtypedobject.\${TYPEDOBJECT_VERSION}.dylib
#
echo "ELSE()" >> ../sha1.cmake
upload  libbiosignalml.so.$BIOSIGNALML_VERSION linux/ libbiosignalml.so.\${BIOSIGNALML_VERSION}
upload  libtypedobject.so.$TYPEDOBJECT_VERSION linux/ libtypedobject.so.\${TYPEDOBJECT_VERSION}
echo "ENDIF()" >> ../sha1.cmake
#
more ../sha1.cmake
popd > /dev/null
