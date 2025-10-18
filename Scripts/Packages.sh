#!/bin/bash

#安装和更新软件包
UPDATE_PACKAGE() {
	local PKG_NAME=$1
	local PKG_REPO=$2
	local PKG_BRANCH=$3
	local PKG_SPECIAL=$4
	local PKG_LIST=("$PKG_NAME" $5)  # 第5个参数为自定义名称列表
	local REPO_NAME=${PKG_REPO#*/}

	echo " "

	# 删除本地可能存在的不同名称的软件包
	for NAME in "${PKG_LIST[@]}"; do
		# 查找匹配的目录
		echo "Search directory: $NAME"
		local FOUND_DIRS=$(find ../feeds/luci/ ../feeds/packages/ -maxdepth 3 -type d -iname "*$NAME*" 2>/dev/null)

		# 删除找到的目录
		if [ -n "$FOUND_DIRS" ]; then
			while read -r DIR; do
				rm -rf "$DIR"
				echo "Delete directory: $DIR"
			done <<< "$FOUND_DIRS"
		else
			echo "Not fonud directory: $NAME"
		fi
	done

	# 克隆 GitHub 仓库
	git clone --depth=1 --single-branch --branch $PKG_BRANCH "https://github.com/$PKG_REPO.git"

	# 处理克隆的仓库
	if [[ "$PKG_SPECIAL" == "pkg" ]]; then
		find ./$REPO_NAME/*/ -maxdepth 3 -type d -iname "*$PKG_NAME*" -prune -exec cp -rf {} ./ \;
		rm -rf ./$REPO_NAME/
	elif [[ "$PKG_SPECIAL" == "name" ]]; then
		mv -f $REPO_NAME $PKG_NAME
	fi
}
# rm -rf feeds/packages/net/tcping

# 调用示例
# UPDATE_PACKAGE "OpenAppFilter" "destan19/OpenAppFilter" "master" "" "custom_name1 custom_name2"
# UPDATE_PACKAGE "open-app-filter" "destan19/OpenAppFilter" "master" "" "luci-app-appfilter oaf" 这样会把原有的open-app-filter，luci-app-appfilter，oaf相关组件删除，不会出现coremark错误。

# UPDATE_PACKAGE "包名" "项目地址" "项目分支" "pkg/name，可选，pkg为从大杂烩中单独提取包名插件；name为重命名为包名"
UPDATE_PACKAGE "argon" "jerrykuku/luci-theme-argon" "master"
# UPDATE_PACKAGE "kucat" "sirpdboy/luci-theme-kucat" "js"


# UPDATE_PACKAGE "homeproxy" "VIKINGYFY/homeproxy" "main"
#UPDATE_PACKAGE "homeproxy" "kiddin9/kwrt-packages" "main" "" "luci-app-homeproxy"
# UPDATE_PACKAGE "nikki" "nikkinikki-org/OpenWrt-nikki" "main"
# UPDATE_PACKAGE "openclash" "vernesong/OpenClash" "dev" "pkg"
UPDATE_PACKAGE "passwall" "xiaorouji/openwrt-passwall" "main" "pkg"
# UPDATE_PACKAGE "passwall-packages" "xiaorouji/openwrt-passwall-packages" "main" "" "xray-core v2ray-geodata sing-box chinadns-ng dns2socks hysteria ipt2socks microsocks naiveproxy shadowsocks-libev shadowsocks-rust shadowsocksr-libev simple-obfs tcping trojan-plus tuic-client v2ray-plugin xray-plugin geoview shadow-tls"

# UPDATE_PACKAGE "luci-app-tailscale" "asvow/luci-app-tailscale" "main"
# UPDATE_PACKAGE "ddns-go" "sirpdboy/luci-app-ddns-go" "main"
# UPDATE_PACKAGE "easytier" "EasyTier/luci-app-easytier" "main"
# UPDATE_PACKAGE "gecoosac" "lwb1978/openwrt-gecoosac" "main"
# UPDATE_PACKAGE "mosdns" "sbwml/luci-app-mosdns" "v5" "" "v2dat"
# UPDATE_PACKAGE "netspeedtest" "sirpdboy/luci-app-netspeedtest" "js" "" "homebox speedtest"
# UPDATE_PACKAGE "partexp" "sirpdboy/luci-app-partexp" "main"
# UPDATE_PACKAGE "qbittorrent" "sbwml/luci-app-qbittorrent" "master" "" "qt6base qt6tools rblibtorrent"
# UPDATE_PACKAGE "qmodem" "FUjr/QModem" "main"
# UPDATE_PACKAGE "viking" "VIKINGYFY/packages" "main" "" "luci-app-timewol luci-app-wolplus"
# UPDATE_PACKAGE "vnt" "lmq8267/luci-app-vnt" "main"

# UPDATE_PACKAGE "luci-app-dnsfilter" "kiddin9/luci-app-dnsfilter" "main"
# UPDATE_PACKAGE "luci-app-partexp" "sirpdboy/luci-app-partexp" "main"
##UPDATE_PACKAGE "mysing-box" "sos801107/packages" "main" "" "sing-box"


#cp -r mysing-box/sing-box feeds/packages/net

rm -rf $GITHUB_WORKSPACE/wrt/feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone --depth=1 --single-branch https://github.com/xiaorouji/openwrt-passwall-packages $GITHUB_WORKSPACE/wrt/package/passwall-packages

git clone --depth=1 --single-branch https://github.com/stevenjoezhang/luci-app-adguardhome $GITHUB_WORKSPACE/wrt/package/luci-app-adguardhome

# 更新 golang 1.25 版本
rm -rf $GITHUB_WORKSPACE/wrt/feeds/packages/lang/golang
$GITHUB_WORKSPACE/Scripts/gh-down.sh https://github.com/immortalwrt/packages/tree/master/lang/golang $GITHUB_WORKSPACE/wrt/feeds/packages/lang/golang

$GITHUB_WORKSPACE/Scripts/gh-down.sh https://github.com/immortalwrt/immortalwrt/tree/master/package/system/procd $GITHUB_WORKSPACE/wrt/package/system/procd

# rm -rf $GITHUB_WORKSPACE/wrt/package/system/procd
# $GITHUB_WORKSPACE/Scripts/gh-down.sh https://github.com/immortalwrt/immortalwrt/tree/master/package/system/procd $GITHUB_WORKSPACE/wrt/package/system/procd

rm -rf $GITHUB_WORKSPACE/wrt/package/libs/openssl
$GITHUB_WORKSPACE/Scripts/gh-down.sh https://github.com/immortalwrt/immortalwrt/tree/master/package/libs/openssl $GITHUB_WORKSPACE/wrt/package/libs/openssl

# openssl hwrng
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" $GITHUB_WORKSPACE/wrt/package/libs/openssl/Makefile
# openssl -Os
sed -i "s/-O3/-Os/g" $GITHUB_WORKSPACE/wrt/package/libs/openssl/Makefile

# curl - http3/quic
rm -rf $GITHUB_WORKSPACE/wrt/feeds/packages/net/curl
git clone --single-branch --depth=1 https://github.com/sbwml/feeds_packages_net_curl $GITHUB_WORKSPACE/wrt/feeds/packages/net/curl

# ngtcp2
rm -rf $GITHUB_WORKSPACE/wrt/feeds/packages/libs/ngtcp2
git clone --single-branch --depth=1 https://github.com/sbwml/package_libs_ngtcp2 $GITHUB_WORKSPACE/wrt/package/libs/ngtcp2

# BBRv3 - linux-6.6
pushd $GITHUB_WORKSPACE/wrt/target/linux/generic/backport-6.6
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0016-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0017-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
	curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/5b5d6a5b7fe9a20ac6d52304e914be76c4bb1528/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0018-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
popd

#更新软件包版本
UPDATE_VERSION() {
	local PKG_NAME=$1
	local PKG_MARK=${2:-false}
	local PKG_FILES=$(find ./ ../feeds/packages/ -maxdepth 3 -type f -wholename "*/$PKG_NAME/Makefile")

	if [ -z "$PKG_FILES" ]; then
		echo "$PKG_NAME not found!"
		return
	fi

	echo -e "\n$PKG_NAME version update has started!"

	for PKG_FILE in $PKG_FILES; do
		local PKG_REPO=$(grep -Po "PKG_SOURCE_URL:=https://.*github.com/\K[^/]+/[^/]+(?=.*)" $PKG_FILE)
		local PKG_TAG=$(curl -sL "https://api.github.com/repos/$PKG_REPO/releases" | jq -r "map(select(.prerelease == $PKG_MARK)) | first | .tag_name")

		local OLD_VER=$(grep -Po "PKG_VERSION:=\K.*" "$PKG_FILE")
		local OLD_URL=$(grep -Po "PKG_SOURCE_URL:=\K.*" "$PKG_FILE")
		local OLD_FILE=$(grep -Po "PKG_SOURCE:=\K.*" "$PKG_FILE")
		local OLD_HASH=$(grep -Po "PKG_HASH:=\K.*" "$PKG_FILE")

		local PKG_URL=$([[ "$OLD_URL" == *"releases"* ]] && echo "${OLD_URL%/}/$OLD_FILE" || echo "${OLD_URL%/}")

		local NEW_VER=$(echo $PKG_TAG | sed -E 's/[^0-9]+/\./g; s/^\.|\.$//g')
		local NEW_URL=$(echo $PKG_URL | sed "s/\$(PKG_VERSION)/$NEW_VER/g; s/\$(PKG_NAME)/$PKG_NAME/g")
		local NEW_HASH=$(curl -sL "$NEW_URL" | sha256sum | cut -d ' ' -f 1)

		echo "old version: $OLD_VER $OLD_HASH"
		echo "new version: $NEW_VER $NEW_HASH"

		if [[ "$NEW_VER" =~ ^[0-9].* ]] && dpkg --compare-versions "$OLD_VER" lt "$NEW_VER"; then
			sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$NEW_VER/g" "$PKG_FILE"
			sed -i "s/PKG_HASH:=.*/PKG_HASH:=$NEW_HASH/g" "$PKG_FILE"
			echo "$PKG_FILE version has been updated!"
		else
			echo "$PKG_FILE version is already the latest!"
		fi
	done
}

#UPDATE_VERSION "软件包名" "测试版，true，可选，默认为否"
# UPDATE_VERSION "sing-box"
