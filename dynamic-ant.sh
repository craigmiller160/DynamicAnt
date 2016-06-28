#!/bin/bash
# Shell script to trigger the dynamic ant operation

if [ $# -ne 1 ]; then
	echo "Error! The source xml file must be provided for this script to run"
	exit 1
fi

