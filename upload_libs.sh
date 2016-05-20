#!/bin/sh
#
BIOSIGNALML_MAJOR_VERSION=0
BIOSIGNALML_MINOR_VERSION=8
BIOSIGNALML_FULL_VERSION=0.8

TYPEDOBJECT_MAJOR_VERSION=1
TYPEDOBJECT_MINOR_VERSION=1
TYPEDOBJECT_FULL_VERSION=1.1
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
cp /Users/dave/biosignalml/libbsml/build/win64/biosignalml.lib     /tmp/upload/release/
cp /Users/dave/biosignalml/libbsml/build/win64/biosignalml.dll     /tmp/upload/release/
cp /Users/dave/biosignalml/typedobject/build/win64/typedobject.lib /tmp/upload/release/
cp /Users/dave/biosignalml/typedobject/build/win64/typedobject.dll /tmp/upload/release/
#
cp /Users/dave/biosignalml/libbsml/build/win64d/biosignalml.lib     /tmp/upload/debug/
cp /Users/dave/biosignalml/libbsml/build/win64d/biosignalml.dll     /tmp/upload/debug/
cp /Users/dave/biosignalml/typedobject/build/win64d/typedobject.lib /tmp/upload/debug/
cp /Users/dave/biosignalml/typedobject/build/win64d/typedobject.dll /tmp/upload/debug/
#
tar xzf /Users/dave/biosignalml/libbsml/build/osx/libBioSignalML-$BIOSIGNALML_FULL_VERSION-Darwin.tar.gz    \
        -C /tmp/upload/release --strip-components 2                                                         \
        libBioSignalML-$BIOSIGNALML_FULL_VERSION-Darwin/lib/libbiosignalml.$BIOSIGNALML_FULL_VERSION.dylib
tar xzf /Users/dave/biosignalml/typedobject/build/osx/TypedObjectLib-$TYPEDOBJECT_FULL_VERSION-Darwin.tar.gz   \
        -C /tmp/upload/release --strip-components 2                                                            \
        TypedObjectLib-$TYPEDOBJECT_FULL_VERSION-Darwin/lib/libtypedobject.$TYPEDOBJECT_FULL_VERSION.dylib
#
tar xzf /Users/dave/biosignalml/libbsml/build/ubuntu/libBioSignalML-$BIOSIGNALML_FULL_VERSION-Linux.tar.gz  \
        -C /tmp/upload/release --strip-components 2                                                         \
        libBioSignalML-$BIOSIGNALML_FULL_VERSION-Linux/lib/libbiosignalml.so.$BIOSIGNALML_FULL_VERSION
tar xzf /Users/dave/biosignalml/typedobject/build/ubuntu/TypedObjectLib-$TYPEDOBJECT_FULL_VERSION-Linux.tar.gz \
        -C /tmp/upload/release --strip-components 2                                                            \
        TypedObjectLib-$TYPEDOBJECT_FULL_VERSION-Linux/lib/libtypedobject.so.$TYPEDOBJECT_FULL_VERSION
#
pushd /tmp/upload > /dev/null
#
rm -f sha1.cmake
#
cd ./release
echo "IF(WIN32)" >> ../sha1.cmake
echo "    IF(RELEASE_MODE)" >> ../sha1.cmake
upload  biosignalml.dll windows/release/ biosignalml.dll
upload  biosignalml.lib windows/release/ biosignalml.lib
upload  typedobject.dll windows/release/ typedobject.dll
upload  typedobject.lib windows/release/ typedobject.lib
#
cd ../debug
echo "    ELSE()" >> ../sha1.cmake
upload  biosignalml.dll windows/debug/ biosignalml.dll
upload  biosignalml.lib windows/debug/ biosignalml.lib
upload  typedobject.dll windows/debug/ typedobject.dll
upload  typedobject.lib windows/debug/ typedobject.lib
echo "    ENDIF()" >> ../sha1.cmake
#
cd ../release
echo "ELSEIF(APPLE)" >> ../sha1.cmake
upload  libbiosignalml.$BIOSIGNALML_FULL_VERSION.dylib osx/ libbiosignalml.\${BIOSIGNALML_MAJOR_VERSION}.dylib
upload  libtypedobject.$TYPEDOBJECT_FULL_VERSION.dylib osx/ libtypedobject.\${TYPEDOBJECT_MAJOR_VERSION}.dylib
#
echo "ELSE()" >> ../sha1.cmake
upload  libbiosignalml.so.$BIOSIGNALML_FULL_VERSION linux/ libbiosignalml.so.\${BIOSIGNALML_MAJOR_VERSION}
upload  libtypedobject.so.$TYPEDOBJECT_FULL_VERSION linux/ libtypedobject.so.\${TYPEDOBJECT_MAJOR_VERSION}
echo "ENDIF()" >> ../sha1.cmake
#
more ../sha1.cmake
popd > /dev/null
