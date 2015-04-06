#!/bin/bash

set +x

BUILD_N_2_0=()
BUILD_N_2_1=()

currentdir=${PWD}
scriptdir=$(dirname $0)
targetfile=${scriptdir}/targets.txt

while read line; do
	read -a array <<< "$line";

	DEVICE=${array[0]}
	BRANCH=${array[1]}
	FREQUENCY=${array[2]}

	if [[ -z "${FREQUENCY}" ]]; then
		echo "Adding \"${DEVICE}\" to \"${BRANCH}\" NIGHTLY builds";
		if [[ "n-2.0" == "${BRANCH}" ]]; then
			BUILD_N_2_0+=("${DEVICE}");
		elif [[ "n-2.1" == "${BRANCH}" ]]; then
			BUILD_N_2_1+=("${DEVICE}");
		fi
	else
		echo "Not implemented yet!";
	fi

done < ${targetfile}

# Newest to oldest, because new is always better!
if [[ "${#BUILD_N_2_1[@]}" -gt 0 ]]; then
	cd /android; repo init -u https://github.com/NamelessRom/android.git -b n-2.1; repo sync -j 100; cd ${currentdir};
	for device in "${BUILD_N_2_1[@]}"; do
		/bin/bash /opt/scripts/build.sh $DEVICE nightly true true true true false /dev/null
	done
else
	echo "No devices queued for n-2.1";
fi

if [[ "${#BUILD_N_2_0[@]}" -gt 0 ]]; then
	cd /android; repo init -u https://github.com/NamelessRom/android.git -b n-2.0; repo sync -j 100; cd ${currentdir};
	for device in "${BUILD_N_2_0[@]}"; do
		/bin/bash /opt/scripts/build.sh $DEVICE nightly true true true true false /dev/null
	done
else
	echo "No devices queued for n-2.1";
fi

exit 0
