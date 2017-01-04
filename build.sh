#!/bin/bash
# Copyright (c) Brian McKenzie <mckenzba@gmail.com>. All rights reserved.
#
# This program and the accompanying materials
# are licensed and made available under the terms and conditions of the BSD License
# which accompanies this distribution.  The full text of the license may be found at
# http://opensource.org/licenses/bsd-license.php
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#

THIS_WORKDIR=`pwd`

BOOT_IMAGE=kernel.img

function do_pi2_build()
{
	cd Pi2BoardPkg/
	source build.sh
	cd ${THIS_WORKDIR}

	retval=$?
}

function do_pi3_build()
{
	cd Pi3BoardPkg/
	source build.sh
	cd ${THIS_WORKDIR}

	retval=$?
}

function do_pi2pi3_build()
{
	# Build Pi2 image
	cd Pi2BoardPkg/
	source build.sh
	cd ${THIS_WORKDIR}

	# Build pi3 image
        cd Pi3BoardPkg/
        source build.sh
        cd ${THIS_WORKDIR}

	retval=$?

	if [ $retval -eq 0 ]; then
		#
		# Generate combined image
		#

		BUILD_ROOT=$WORKSPACE/Build/Pi2Pi3Board/"$TARGET"_"$TARGET_TOOLS"
		TMP_DIR=$BUILD_ROOT/Temp

		PI2_UEFI_BIN=$WORKSPACE/Build/Pi2Board/"$TARGET"_"$TARGET_TOOLS"/FV/PI2BOARD_EFI.fd
		PI3_UEFI_BIN=$WORKSPACE/Build/Pi3Board/"$TARGET"_"$TARGET_TOOLS"/FV/PI3BOARD_EFI.fd

		if [ -d ${BUILD_ROOT} ]; then
			rm -rf $BUILD_ROOT
			mkdir -p $BUILD_ROOT
		else
			mkdir -p $BUILD_ROOT
		fi

		mkdir $TMP_DIR

		echo -e "Composing combined $BOOT_IMAGE...\n"

		#
		# Build startup code
		#
		$WORKSPACE/RaspberryPiPkg/Pi3BoardPkg/Scripts/startup_build.sh $WORKSPACE/RaspberryPiPkg/Pi3BoardPkg/Scripts/startup.S 0x8000 $TMP_DIR/startup.bin

		#
		# Create file padding
		#
		dd if=/dev/zero of=$TMP_DIR/pad.bin bs=1024 count=160 conv=notrunc

		#
		# Generate final firmware image
		#
		cat $TMP_DIR/startup.bin $PI2_UEFI_BIN $TMP_DIR/pad.bin $PI3_UEFI_BIN > $BUILD_ROOT/$BOOT_IMAGE

		echo -e "\nDone Composing combined $BOOT_IMAGE\n"

		#
		# Clean up
		#
		rm -rf $TMP_DIR

		echo -e "Created combined $BOOT_IMAGE $TARGET at $BUILD_ROOT/$BOOT_IMAGE\n"

		echo -e "Pi2Pi3Boot Image Build ## Succeeded ##\n"
	else
		echo -e "Pi2Pi3Boot Image Build ## Failed ##\n"
	fi
}

if [ -z "$2" ]; then
	TARGET=DEBUG
else
	TARGET=RELEASE
fi

case "$1" in
	Pi2)
		do_pi2_build
		;;
	Pi3)
		do_pi3_build
		;;
	Pi2Pi3)
		do_pi2pi3_build
		;;
	*)
		echo "Error: Unknown board flavor."
		echo -e "Usage:\n\t$0 <board> <optional_target>\n"
		echo "Supported board flavors: Pi2 Pi3 Pi2Pi3"
		echo "If no target is specified, DEBUG will be used."
		retval=1
		;;
esac

exit $retval
