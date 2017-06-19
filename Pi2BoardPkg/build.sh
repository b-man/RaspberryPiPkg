#!/bin/bash
# Copyright (c) 2008 - 2009, Apple Inc. All rights reserved.<BR>
#
# This program and the accompanying materials
# are licensed and made available under the terms and conditions of the BSD License
# which accompanies this distribution.  The full text of the license may be found at
# http://opensource.org/licenses/bsd-license.php
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#

set -e
shopt -s nocasematch

# The final firmware image name
if [ -z "${BOOT_IMAGE}" ]; then
	BOOT_IMAGE=kernel.img
fi

#
# Setup workspace if it is not set
#
if [ -z "${WORKSPACE:-}" ]
then
  echo Initializing workspace
  cd ../../
  export EDK_TOOLS_PATH=`pwd`/BaseTools
  source edksetup.sh BaseTools
else
  echo Building from: $WORKSPACE
fi

#
# Pick a default tool type for a given OS if no toolchain already defined
#
if [ -z "${TARGET_TOOLS:-}" ]
then
  case `uname` in
    CYGWIN*)
      TARGET_TOOLS=RVCT31CYGWIN
      ;;
    Linux*)
      TARGET_TOOLS=GCC5
      export GCC5_ARM_PREFIX=arm-eabi-
      ;;
    Darwin*)
      Major=$(uname -r | cut -f 1 -d '.')
      if [[ $Major == 9 ]]
      then
        # Not supported by this open source project
        TARGET_TOOLS=XCODE31
      else
        TARGET_TOOLS=XCODE32
      fi
      ;;
  esac
fi

if [ -z "${TARGET}" ]; then
  for arg in "$@"; do
    if [[ $arg == "RELEASE" ]]; then
      TARGET=RELEASE
    fi
  done

  if [ -z "${TARGET}" ]; then
    TARGET=DEBUG
  fi
fi

BUILD_ROOT=$WORKSPACE/Build/Pi2Board/"$TARGET"_"$TARGET_TOOLS"
TMP_DIR=$BUILD_ROOT/Temp

# Create directory for temporary files
if [ -d $TMP_DIR ]; then
  rm -rf $TMP_DIR
  mkdir -p $TMP_DIR
else
  mkdir -p $TMP_DIR
fi

if  [[ ! -e $EDK_TOOLS_PATH/Source/C/bin ]];
then
  # build the tools if they don't yet exist
  echo Building tools: $EDK_TOOLS_PATH
  make -C $EDK_TOOLS_PATH
else
  echo using prebuilt tools
fi

#
# Build the edk2 RaspberryPi code
#
if [[ $TARGET == RELEASE ]]; then
  build -p $WORKSPACE/RaspberryPiPkg/Pi2BoardPkg/Pi2BoardPkg.dsc -a ARM -t $TARGET_TOOLS -b $TARGET -D DEBUG_TARGET=RELEASE ${2:-} ${3:-} ${4:-} ${5:-} ${6:-} ${7:-} ${8:-}
else
  build -p ${WORKSPACE:-}/RaspberryPiPkg/Pi2BoardPkg/Pi2BoardPkg.dsc -a ARM -t $TARGET_TOOLS -b $TARGET ${1:-} ${2:-} ${3:-} ${4:-} ${5:-} ${6:-} ${7:-} ${8:-}
fi

retval=$?

for arg in "$@"
do
  if [[ $arg == clean ]]; then
    # no need to post process if we are doing a clean
    exit
  elif [[ $arg == cleanall ]]; then
    make -C $EDK_TOOLS_PATH clean
    exit
  fi
done

if [ $retval -eq 0 ]; then
  echo -e "Composing $BOOT_IMAGE...\n"

  #
  # Build startup code
  #
  $WORKSPACE/RaspberryPiPkg/Pi3BoardPkg/Scripts/startup_build.sh $WORKSPACE/RaspberryPiPkg/Pi3BoardPkg/Scripts/startup.S 0x8000 $TMP_DIR/startup.bin

  #
  # Generate final firmware image
  #
  cat $TMP_DIR/startup.bin $BUILD_ROOT/FV/PI2BOARD_EFI.fd > $BUILD_ROOT/$BOOT_IMAGE

  echo -e "\nDone Composing $BOOT_IMAGE\n"

  #
  # Clean up
  #
  rm -rf $TMP_DIR

  echo -e "Created $BOOT_IMAGE $TARGET at $BUILD_ROOT/$BOOT_IMAGE\n"
  echo -e "Pi2Boot Image Build ## Succeeded ##\n"
else
  echo -e "Pi2Boot Image Build ## Failed ##\n"
fi
