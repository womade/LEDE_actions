#!/bin/bash
#==================================================
# Description: DIY script part 1
# File name: diy-part2.sh
# Author: 中國遠徵
# Blog: https://blog.ssss.fun
# Copyright (c) 1998 中國遠徵 <https://i.ssss.fun>
#==================================================

# JDC-1 配置
if grep -q JDC-1 .yuanzheng;
then
echo "加载JDC-1专用配置"
# load dts
echo '载入 mt7621_jdcloud_re-sp-01b.dts'
curl --retry 3 -s --globoff "https://github.com/womade/LEDE_actions/raw/main/patch/mt7621_jdcloud_re-sp-01b.dts" -o target/linux/ramips/dts/mt7621_jdcloud_re-sp-01b.dts
ls -l target/linux/ramips/dts/mt7621_jdcloud_re-sp-01b.dts
# fix2 + fix4.2
echo '修补 mt7621.mk'
sed -i '/Device\/adslr_g7/i\define Device\/jdcloud_re-sp-01b\n  \$(Device\/dsa-migration)\n  \$(Device\/uimage-lzma-loader)\n  IMAGE_SIZE := 32448k\n  DEVICE_VENDOR := JDCloud\n  DEVICE_MODEL := RE-SP-01B\n  DEVICE_PACKAGES := kmod-fs-ext4 kmod-mt7603 kmod-mt7615e kmod-mt7615-firmware kmod-sdhci-mt7620 kmod-usb3 wpad-openssl\nendef\nTARGET_DEVICES += jdcloud_re-sp-01b\n\n' target/linux/ramips/image/mt7621.mk
# fix3 + fix5.2
echo '修补 02-network'
sed -i -e '/lenovo,newifi-d1|\\/i\        jdcloud,re-sp-01b|\\' -e '/ramips_setup_macs/,/}/{/ampedwireless,ally-00x19k/i\        jdcloud,re-sp-01b)\n\t\tlan_mac=$(mtd_get_mac_ascii u-boot-env mac)\n\t\twan_mac=$(macaddr_add "$lan_mac" 1)\n\t\tlabel_mac=$lan_mac\n\t\t;;
}' target/linux/ramips/mt7621/base-files/etc/board.d/02_network
# fix5.1
echo '修补 system.sh 以正常读写 MAC'
sed -i 's#key"'\''=//p'\''#& \| head -n1#' package/base-files/files/lib/functions/system.sh
fi


### 修改为R4A千兆版Breed直刷版
if grep -q MI-R4A .yuanzheng;
then
echo "加载R4A千兆版Breed直刷版专用配置"
export shanchu1=$(grep  -a -n -e '&spi0 {' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi|cut -d ":" -f 1)
export shanchu2=$(grep  -a -n -e '&pcie {' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi|cut -d ":" -f 1)
export shanchu2=$(expr $shanchu2 - 1)
export shanchu2=$(echo $shanchu2"d")
sed -i $shanchu1,$shanchu2 target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi
grep  -Pzo '&spi0[\s\S]*};[\s]*};[\s]*};[\s]*};' target/linux/ramips/dts/mt7621_youhua_wr1200js.dts > youhua.txt
echo "" >> youhua.txt
echo "" >> youhua.txt
export shanchu1=$(expr $shanchu1 - 1)
export shanchu1=$(echo $shanchu1"r")
sed -i "$shanchu1 youhua.txt" target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-3g-v2.dtsi
rm -rf youhua.txt
export imsize1=$(grep  -a -n -e 'define Device/xiaomi_mir3g-v2' target/linux/ramips/image/mt7621.mk|cut -d ":" -f 1)
export imsize1=$(expr $imsize1 + 2)
export imsize1=$(echo $imsize1"s")
sed -i "$imsize1/IMAGE_SIZE := .*/IMAGE_SIZE := 16064k/" target/linux/ramips/image/mt7621.mk
fi
