#!/bin/bash

PKG_PATH="$GITHUB_WORKSPACE/wrt/package"

#预置HomeProxy数据
# if [ -d *"homeproxy"* ]; then
# 	echo " "

# 	HP_RULE="surge"
# 	HP_PATH="homeproxy/root/etc/homeproxy"

# 	rm -rf ./$HP_PATH/resources/*

# 	git clone -q --depth=1 --single-branch --branch "release" "https://github.com/Loyalsoldier/surge-rules.git" ./$HP_RULE/
# 	cd ./$HP_RULE/ && RES_VER=$(git log -1 --pretty=format:'%s' | grep -o "[0-9]*")

# 	echo $RES_VER | tee china_ip4.ver china_ip6.ver china_list.ver gfw_list.ver
# 	awk -F, '/^IP-CIDR,/{print $2 > "china_ip4.txt"} /^IP-CIDR6,/{print $2 > "china_ip6.txt"}' cncidr.txt
# 	sed 's/^\.//g' direct.txt > china_list.txt ; sed 's/^\.//g' gfw.txt > gfw_list.txt
# 	mv -f ./{china_*,gfw_list}.{ver,txt} ../$HP_PATH/resources/

# 	cd .. && rm -rf ./$HP_RULE/

# 	cd $PKG_PATH && echo "homeproxy date has been updated!"
# fi

#修改argon主题字体和颜色
# if [ -d *"luci-theme-argon"* ]; then
# 	echo " "

# 	cd ./luci-theme-argon/

# 	sed -i "/font-weight:/ { /important/! { /\/\*/! s/:.*/: var(--font-weight);/ } }" $(find ./luci-theme-argon -type f -iname "*.css")
# 	#sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'none'/'bing'/; s/'600'/'normal'/" ./luci-app-argon-config/root/etc/config/argon

# 	cd $PKG_PATH && echo "theme-argon has been fixed!"
# fi

#修改qca-nss-drv启动顺序
NSS_DRV="../feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
	echo " "

	sed -i 's/START=.*/START=85/g' $NSS_DRV

	cd $PKG_PATH && echo "qca-nss-drv has been fixed!"
fi

#修改qca-nss-pbuf启动顺序
NSS_PBUF="./kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
	echo " "

	sed -i 's/START=.*/START=86/g' $NSS_PBUF

	cd $PKG_PATH && echo "qca-nss-pbuf has been fixed!"
fi

#修复TailScale配置文件冲突
# TS_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/tailscale/Makefile")
# if [ -f "$TS_FILE" ]; then
# 	echo " "

# 	sed -i '/\/files/d' $TS_FILE

# 	cd $PKG_PATH && echo "tailscale has been fixed!"
# fi

#修复Rust编译失败
RUST_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
	echo " "

	sed -i 's/ci-llvm=true/ci-llvm=false/g' $RUST_FILE

	cd $PKG_PATH && echo "rust has been fixed!"
fi

sed -i 's,mirrors.vsean.net/openwrt,mirror.nju.edu.cn/immortalwrt,g' $PKG_PATH/emortal/default-settings/files/99-default-settings-chinese && echo "default mirror switched!"

# add an8855 support

curl https://github.com/hanwckf/immortalwrt-mt798x/raw/refs/heads/openwrt-21.02/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-xiaomi-mi-router-ax3000t-an8855-stock.dts -o $GITHUB_WORKSPACE/wrt/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-xiaomi-mi-router-ax3000t-an8855-stock.dts
curl https://github.com/hanwckf/immortalwrt-mt798x/raw/refs/heads/openwrt-21.02/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-xiaomi-mi-router-ax3000t-an8855.dts -o $GITHUB_WORKSPACE/wrt/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-xiaomi-mi-router-ax3000t-an8855.dts
curl https://github.com/hanwckf/immortalwrt-mt798x/raw/refs/heads/openwrt-21.02/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-xiaomi-mi-router.dtsi -o $GITHUB_WORKSPACE/wrt/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-xiaomi-mi-router.dtsi


$GITHUB_WORKSPACE/Scripts/gh-down.sh https://github.com/hanwckf/immortalwrt-mt798x/tree/openwrt-21.02/target/linux/mediatek/files-5.4/drivers/net/dsa/airoha/an8855 $GITHUB_WORKSPACE/wrt/target/linux/mediatek/files-5.4/drivers/net/dsa/airoha/an8855
$GITHUB_WORKSPACE/Scripts/gh-down.sh https://github.com/hanwckf/immortalwrt-mt798x/tree/openwrt-21.02/target/linux/mediatek/files-5.4/drivers/net/phy/airoha/an8855 $GITHUB_WORKSPACE/wrt/target/linux/mediatek/files-5.4/drivers/net/phy/airoha/an8855
$GITHUB_WORKSPACE/Scripts/gh-down.sh https://github.com/hanwckf/immortalwrt-mt798x/tree/openwrt-21.02/target/linux/mediatek/files-5.4/net/dsa $GITHUB_WORKSPACE/wrt/target/linux/mediatek/files-5.4/net/dsa

curl https://github.com/hanwckf/immortalwrt-mt798x/raw/refs/heads/openwrt-21.02/target/linux/mediatek/patches-5.4/999-2739-drivers_net_dsa_add_an8855.patch -o $GITHUB_WORKSPACE/wrt/target/linux/mediatek/patches-5.4/999-2739-drivers_net_dsa_add_an8855.patch
curl https://github.com/hanwckf/immortalwrt-mt798x/raw/refs/heads/openwrt-21.02/target/linux/mediatek/999-2739-drivers_net_phy_add_an8855_gsw.patch -o $GITHUB_WORKSPACE/wrt/target/linux/mediatek/patches-5.4/999-2739-drivers_net_phy_add_an8855_gsw.patch
curl https://github.com/hanwckf/immortalwrt-mt798x/raw/refs/heads/openwrt-21.02/target/linux/mediatek/patches-5.4/999-2739-net_dsa_add_tag_arht.patch -o $GITHUB_WORKSPACE/wrt/target/linux/mediatek/patches-5.4/999-2739-net_dsa_add_tag_arht.patch

echo "CONFIG_AN8855_GSW=y" >> $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7981/config-5.4
echo "# CONFIG_NET_DSA_AN8855 is not set" >> $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7981/config-5.4
echo "# CONFIG_NET_DSA_TAG_AIROHA is not set" >> $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7981/config-5.4
echo "CONFIG_AN8855_GSW=y" >> $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7986/config-5.4
echo "# CONFIG_NET_DSA_AN8855 is not set" >> $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7986/config-5.4
echo "# CONFIG_NET_DSA_TAG_AIROHA is not set" >> $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7986/config-5.4

sed -i "s/mtkhnat-\$\(CONFIG_NET_DSA_MT7530\)\t\t\+= hnat_stag\.o/ifeq \(\$\(CONFIG_NET_DSA_AN8855\), y\)\nmtkhnat-y\t\t\+= hnat_stag\.o\nelse\nmtkhnat-\$\(CONFIG_NET_DSA_MT7530\)\t\t\+= hnat_stag\.o\nendif/g" $GITHUB_WORKSPACE/wrt/target/linux/mediatek/files-5.4/drivers/net/ethernet/mediatek/mtk_hnat/Makefile

# modify mt7981.mk
AWK_BLOCK=$(cat << 'AWK_EOF'

define Device/xiaomi_mi-router-ax3000t-an8855-stock
  DEVICE_VENDOR := Xiaomi
  DEVICE_MODEL := Mi Router AX3000T with AN8855 (stock layout)
  DEVICE_DTS := mt7981-xiaomi-mi-router-ax3000t-an8855-stock
  DEVICE_DTS_DIR := $(DTS_DIR)/mediatek
  UBINIZE_OPTS := -E 5
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  IMAGE_SIZE := 34816k
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += xiaomi_mi-router-ax3000t-an8855-stock

define Device/xiaomi_mi-router-ax3000t-an8855
  DEVICE_VENDOR := Xiaomi
  DEVICE_MODEL := Mi Router AX3000T with AN8855
  DEVICE_DTS := mt7981-xiaomi-mi-router-ax3000t-an8855
  DEVICE_DTS_DIR := $(DTS_DIR)/mediatek
  UBINIZE_OPTS := -E 5
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  IMAGE_SIZE := 114688k
  KERNEL_IN_UBI := 1
  IMAGES += factory.bin
  IMAGE/factory.bin := append-ubi | check-size $$$$(IMAGE_SIZE)
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += xiaomi_mi-router-ax3000t-an8855
AWK_EOF
)

gawk -i inplace -v insert_text="$AWK_BLOCK" '
  1; # 默认动作：打印当前行
  /TARGET_DEVICES += xiaomi_mi-router-ax3000t/{
    print insert_text; # 匹配到目标行后，立即插入文本块
  }
' $GITHUB_WORKSPACE/wrt/target/linux/mediatek/image/mt7981.mk

echo "1111111111"
sed -i 's/^\s*xiaomi,mi-router-ax3000t\*\s*|\\$/\txiaomi,mi-router-ax3000t|\\\n\txiaomi,mi-router-ax3000t-stock|\\/' $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7981/base-files/etc/board.d/02_network
echo "2222222222"
sed -i 's/^[[:space:]]*\*360,t7\*)/\txiaomi,mi-router-ax3000t-an8855|\\\n\txiaomi,mi-router-ax3000t-an8855-stock)\n\t\tucidef_set_interfaces_lan_wan "eth0.1" "eth0.2"\n\t\tucidef_add_switch "switch0" \\\n\t\t\t"1:lan" "2:lan" "3:lan" "0:wan" "5t@eth0"\n\t\t;;\n\t*360,t7*)/'  $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7981/base-files/etc/board.d/02_network
echo "3333333333"
sed -i '/^[[:space:]]*xiaomi,mi-router-ax3000t-stock|\\$/a\\txiaomi,mi-router-ax3000t-an8855-stock|\\' $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh
echo "4444444444"
sed -i '/^[[:space:]]*xiaomi,mi-router-ax3000t|\\$/a\\txiaomi,mi-router-ax3000t-an8855|\\' $GITHUB_WORKSPACE/wrt/target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh