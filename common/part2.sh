#!/bin/bash
#==================================================
# Description: common script part 2
# File name: part2.sh
# Author: 中國遠徵
# Blog: https://blog.ssss.fun
# Copyright (c) 1998 中國遠徵 <https://i.ssss.fun>
#==================================================

# 默认密码为空（原：password）
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

# 状态系统增加个性信息
sed -i "s/exit 0//" package/lean/default-settings/files/zzz-default-settings
echo "sed -i '/CPU usage/a\<tr><td width=\"33%\">其他链接</td><td><a class=\"yuanzheng\" href=\"https://i.ssss.fun\">❤️ 特别鸣谢</a>&nbsp;&nbsp;&nbsp;<a class=\"yuanzheng\" href=\"https://pay.ssss.fun\">👍 赞助支持</a>&nbsp;&nbsp;&nbsp;<a class=\"yuanzheng\" href=\"https://msg.ssss.fun\">📃 问题反馈</a></td></tr>' /usr/lib/lua/luci/view/admin_status/index.htm" >> package/lean/default-settings/files/zzz-default-settings
echo "" >> package/lean/default-settings/files/zzz-default-settings
echo "" >> package/lean/default-settings/files/zzz-default-settings
echo "exit 0" >> package/lean/default-settings/files/zzz-default-settings

# 修改默认 IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 修改主机名称
sed -i 's/OpenWrt/SuperNet/g' package/base-files/files/bin/config_generate

# 修改 Banner
cp modify/etc/banner package/base-files/files/etc/banner

# 修改版本号
sed -i 's/OpenWrt /OpenWrt @Y-ZHENG /g' package/lean/default-settings/files/zzz-default-settings
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='SN-$(date +%y.%m)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='YUANZHENG'" >>package/base-files/files/etc/openwrt_release

# 修改无线名称
sed -i 's/OpenWrt/SuperNet/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/OpenWrt_2G/SuperNet_2G/g' package/lean/mt/drivers/mt_wifi/files/mt7603.dat
sed -i 's/OpenWrt_5G/SuperNet_5G/g' package/lean/mt/drivers/mt_wifi/files/mt7612.dat
sed -i 's/OpenWrt_5G/SuperNet_5G/g' package/lean/mt/drivers/mt_wifi/files/mt7615.1.5G.dat
sed -i 's/OpenWrt_5G/SuperNet_5G/g' package/lean/mt/drivers/mt_wifi/files/mt7615.dat
sed -i 's/OpenWrt_5G/SuperNet_5G/g' package/lean/mt/drivers/mt_wifi/files/mt7615.5G.dat

# 添加主题
sed -i 's/# CONFIG_PACKAGE_luci-theme-supernet is not set/CONFIG_PACKAGE_luci-theme-supernet=y/g' .config

# 修改主题
cp -r modify/themes/bootstrap/footer.htm feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm
cp -r modify/themes/netgear/footer.htm feeds/luci/themes/luci-theme-netgear/luasrc/view/themes/netgear/footer.htm
cp -r modify/themes/netgear/nlogo.png feeds/luci/themes/luci-theme-netgear/htdocs/luci-static/netgear/nlogo.png

# 修改默认主题
# sed -i 's/config internal themes/config internal themes\n    option SuperNet  \"\/luci-static\/supernet\"/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 移除重复软件包
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-wrtbwmon
rm -rf feeds/luci/applications/luci-app-dockerman

# 修改默认终端为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

./scripts/feeds update -a
./scripts/feeds install -a
