# RZ-BSP 3.0.6+

Renesas RZ BSP environment setup for VLP 3.0.6 onwards. Please refer to the other branches for the older setups.

Please note that Panfrost is not part of the official Renesas BSP package.

## Instructions

Clone this particular branch with the following command:

	git clone --recursive -b dunfell/rz_306 https://github.com/renesas-rz/rz-bsp.git

There are two options to configure and setup the environment afterwards:

### 1. Using the Setup script:
You can use the setup script: bsp_setup.sh:

	USAGE:
	source bsp_setup.sh  [-h] [-b Board] [-v BSP-version] [-p panfrost_enable]
	Set's up the yocto environment for building a BSP Image
	where:
	
	    -h  show this help text

	    -b  board for which you want build the BSP
		rzg2l rzg2lc rzg2ul rzv2l rzg2h rzg2m rzg2n ek874
		rzfive rzg3s

	    -v  version of BSP (default BSP-3.0.6-update4)
		BSP-3.0.6 BSP-3.0.6-update1 BSP-3.0.6-update2 BSP-3.0.6-update3 BSP-3.0.6-update4

	    -p  enable panfrost graphics for supported boards (default disabled)
		Supported boards: rzg2l rzg2lc rzv2l
	
The script will setup the environment for the image build and you can the build the image of your choice with the command:

	MACHINE=<machine> bitbake <target>



Please replace _**machine**_ by the name below according to your requirement:
* HiHope RZ/G2H board: hihope-rzg2h
* HiHope RZ/G2M board: hihope-rzg2m
* HiHope RZ/G2N board: hihope-rzg2n
* EK874 RZ/G2E board: ek874
* RZ/G2L Evaluation Board Kit PMIC version: smarc-rzg2l
* RZ/G2LC Evaluation Board Kit PMIC version: smarc-rzg2lc
* RZ/G2UL Evaluation Board Kit PMIC version: smarc-rzg2u
* RZ/V2L Evaluation Board Kit: smarc-rzv2l
* RZ/FIVE Evaluation Board Kit: smarc-rzfive
* RZ/G3S Evaluation Board Kit: smarc-rzg3s

Common targets are:
* core-image-minimal
* core-image-bsp
* core-image-qt
* core-image-weston (for graphics)


	
### 2. Manual Method:  
1. Checkout the tag for the relevant BSP version. The supported versions are:   
	`BSP-3.0.6 BSP-3.0.6-update1 BSP-3.0.6-update2 BSP-3.0.6-update3 BSP-3.0.6-update4 `
   
   Use the following command to update the submodules:  
   `git submodule update --init --recursive`
   
2. Prepare the configuration files for the target board. Run the commands below in build directory. Please replace _**board**_ by the name below according to your requirement:  

	HiHope RZ/G2H board, HiHope RZ/G2M board, HiHope RZ/G2N board, EK874 RZ/G2E board: hihope-rzg2h  
	RZ/G2L,RZ/G2LC,RZ/G2UL Evaluation Board Kit PMIC version: rzg2l  
	RZ/V2L Evaluation Board Kit: rzv2l  
	RZ/FIVE Evaluation Board Kit: rzfive
	RZ/G3S Evaluation Board Kit: rzg3s
	
	`TEMPLATECONF=$PWD/meta-renesas/meta-<board>/docs/template/conf/ source poky/oe-init-build-env build`

3. If you want to add support for panfrost, please run the following command within the build directory:  
	`bitbake-layers add-layer meta-rz-panfrost`  
	
   Afterwards, add the followng to build/conf/local.conf:  
   
   	`PACKAGECONFIG_append_pn-mesa = " egl kmsro panfrost"`
	
	`IMAGE_INSTALL_append += " mesa weston kmscube"`

4. Build the image of your choice with the command:  


	`MACHINE=<machine> bitbake <target>`

Please replace _**machine**_ by the name below according to your requirement:
* HiHope RZ/G2H board: hihope-rzg2h
* HiHope RZ/G2M board: hihope-rzg2m
* HiHope RZ/G2N board: hihope-rzg2n
* EK874 RZ/G2E board: ek874
* RZ/G2L Evaluation Board Kit PMIC version: smarc-rzg2l
* RZ/G2LC Evaluation Board Kit PMIC version: smarc-rzg2lc
* RZ/G2UL Evaluation Board Kit PMIC version: smarc-rzg2u
* RZ/V2L Evaluation Board Kit: smarc-rzv2l
* RZ/FIVE Evaluation Board Kit: smarc-rzfive
* RZ/G3S Evaluation Board Kit: smarc-rzg3s
	
Common targets are:  
* core-image-minimal  
* core-image-bsp  
* core-image-qt  
* core-image-weston (for graphics)  
