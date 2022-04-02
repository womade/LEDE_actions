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
  cp -rf $GITHUB_WORKSPACE/patch/JDC-1.tar.gz $GITHUB_WORKSPACE/openwrt
  tar -zxvf JDC-1.tar.gz
  rm -rf JDC-1.tar.gz
fi


### 修改为R4A千兆版Breed直刷版
if grep -q MI-R4A .yuanzheng;
then
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
