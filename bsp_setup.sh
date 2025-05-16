#!/bin/bash

usage="USAGE:
source bsp_setup.sh  [-h] [-b Board] [-v BSP-version] [-p panfrost_enable]
Set's up the yocto environment for building a BSP Image
where:
    -h  show this help text

    -b  board for which you want build the BSP
        rzg2l rzg2lc rzg2ul rzv2l rzg2h rzg2m rzg2n ek874 rzfive rzg3s

    -v  version of BSP (default BSP-3.0.6)
        BSP-3.0.6 BSP-3.0.6-update1 BSP-3.0.6-update2 BSP-3.0.6-update3 BSP-3.0.6-update4 BSP-3.0.7

    -p  enable panfrost graphics for supported boards (default disabled)
        Supported boards: rzg2l rzg2lc rzv2l"

unset board
unset panfrost
unset bsp_version

LIST="rzg2l rzg2lc rzg2ul rzv2l rzg2h rzg2m rzg2n ek874 rzfive rzg3s"
PANFROST_LIST="rzg2l rzg2lc rzv2l"
BSP_LIST="BSP-3.0.6 BSP-3.0.6-update1 BSP-3.0.6-update2 BSP-3.0.6-update3 BSP-3.0.6-update4 BSP-3.0.7"
G2L_family="rzg2l rzg2lc rzg2ul "
V2L_family="rzv2l "
G3S_family="rzg3s "
G2H_family="rzg2h rzg2m rzg2n ek874"


function exists_in_list() {
    LIST=$1
    VALUE=$2
    echo $LIST | tr " " '\n' | grep -F -q -x "$VALUE"
}

while getopts :hb:v:p: option
do
    case "${option}"
        in
	h)	OPTIND=1
		echo "$usage";
		return 0;;
        b)	board=${OPTARG}
                if ! exists_in_list "$LIST" $board; then 
			OPTIND=1
			echo -e >&2 "ERROR: Board specified is incorrect.\nThe following boards are supported: $LIST\n$usage"; return 1;
                fi
	;;
	v)	bsp_version=${OPTARG}
                if ! exists_in_list "$BSP_LIST" $bsp_version; then
                        echo -e "BSP version mentioned not supported or incorrect\nProceeding with BSP-3.0.7";
			bsp_version="BSP-3.0.7"
                fi
	;;
        p)	panfrost=${OPTARG}
                if [ "$panfrost" == "y"  ] && ! exists_in_list "$PANFROST_LIST" $board; then
                        OPTIND=1
                        echo -e >&2 "ERROR: Board specified doesn't support panfrost.\nPanfrost is available for the following: $PANFROST_LIST\n$usage"; return 1;
                fi
        ;;
    esac
done

shift "$((OPTIND-1))"

if [ ! "$board" ]; then
        OPTIND=1
        echo >&2 -e "ERROR: Argument -b must be provided\n$usage"; return 0;
fi


if [ -z "$bsp_version" ]; then
	echo -e "BSP version not specified\nProceeding with BSP-3.0.6-update4";
	bsp_version="BSP-3.0.7"
fi

#echo "BOARD: $board"
#echo "PANFROST_ENABLED: $panfrost"
#echo "BSP: $bsp_version"

cd ./meta-renesas
git checkout "$bsp_version"
cd ..

if exists_in_list "$G2L_family" $board; then
        board="rzg2l"
fi

if exists_in_list "$G2H_family" $board; then
        board="rzg2h"
fi

if exists_in_list "$V2L_family" $board; then
        board="rzv2l"
fi

if exists_in_list "$G3S_family" $board; then
	echo "y"
        board=rzg3s
fi

TEMPLATECONF=$PWD/meta-renesas/meta-$board/docs/template/conf/ source poky/oe-init-build-env build

if [ "$panfrost" == "y" ]; then
	bitbake-layers add-layer ../meta-rz-panfrost/
	sed -i '$a PACKAGECONFIG_append_pn-mesa = " egl kmsro panfrost"' ./conf/local.conf
	sed -i '$a IMAGE_INSTALL_append += " mesa weston kmscube"' ./conf/local.conf
fi

OPTIND=1
