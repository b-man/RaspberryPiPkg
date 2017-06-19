#!/bin/bash
#
#  Copyright (c), Brian McKenzie <mckenzba@gmail.com>. All rights reserved.
#
#  This program and the accompanying materials
#  are licensed and made available under the terms and conditions of the BSD License
#  which accompanies this distribution.  The full text of the license may be found at
#  http://opensource.org/licenses/bsd-license.php
#
#  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
#  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#
# This scripts generates the machine code to get executed by all CPU cores from
# physical memory address 0
#

set -e

function usage()
{
	echo "Usage: startup_build.sh <asm_source> <binary_size> <output_binary>"
	exit 1
}

function build_startup_code()
{
	local size=$2
	local fname=$1
	local outfile=$3

	if [ -z $size ]; then
		usage
	fi

	if [ -z $fname ]; then
		usage
	fi

	if [ -z $outfile ]; then
		usage
	fi

	echo -e "# Building `basename $fname` #\n"
	arm-eabi-gcc -c $fname -o /tmp/$$.o -march=armv7-a
	echo -e "# Generating `basename $outfile` #\n"
	arm-eabi-objcopy /tmp/$$.o -O binary --pad-to $size $outfile

	retval=$?

	if [ $retval -eq 0 ]; then
		echo -e "`basename $outfile` Binary Blob Generation ## Succeeded ##\n"
	else
		echo -e "`banename $outfile` Binary Blob Generation ## Failed ##"
	fi

	rm -f /tmp/$$.o
}

build_startup_code "$@"

exit $retval
