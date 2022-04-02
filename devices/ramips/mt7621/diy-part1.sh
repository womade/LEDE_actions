#!/bin/bash
#==================================================
# Description: DIY script part 1
# File name: diy-part2.sh
# Author: 中國遠徵
# Blog: https://blog.ssss.fun
# Copyright (c) 1998 中國遠徵 <https://i.ssss.fun>
#==================================================

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default


if [ ${{ github.event.client_payload.model || github.event.inputs.model }} == "JDC-1" ]; then
  cp -rf $GITHUB_WORKSPACE/JDC-1/* ./
fi
