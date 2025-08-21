include $(TOPDIR)/rules.mk

PKG_NAME:=frieren
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/xchwarze/frieren.git
PKG_SOURCE_VERSION:=master

PKG_MAINTAINER:=DSR! <xchwarze@gmail.com>
PKG_LICENSE:=LGPL-3.0-only

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
HOST_BUILD_DEPENDS:=nodejs/host yarn/host php/host

include $(INCLUDE_DIR)/package.mk

define Package/frieren
	SECTION:=extras
	CATEGORY:=Utilities
	TITLE:=Frieren - universal security tool for routers and SBCs
	URL:=https://github.com/xchwarze/frieren
	DEPENDS:=+nginx +php8-fpm +php8-mod-mbstring +php8-mod-session +php8-mod-sqlite3 +coreutils-nohup +uclient-fetch +usbutils +ttyd
	PKGARCH:=all
endef

define Package/frieren/description
	Frieren, compiled as a universal security tool for routers and SBCs, features a lightweight PHP backend and a React frontend.
endef

define Build/Prepare
	$(call Build/Prepare/Default)

	# Update the .env.prod file with release info
	sed -i 's/PLACEHOLDER_BUILD/master/' $(PKG_BUILD_DIR)/frieren-front/config/.env.prod
endef

define Build/Compile
	# Compile projects
	$(call Compile/Frontend)
	$(call Compile/Backend)

	# Prepare release
	mv $(PKG_BUILD_DIR)/frieren-front/dist $(PKG_BUILD_DIR)/frieren
	mv $(PKG_BUILD_DIR)/frieren-back/dist/api $(PKG_BUILD_DIR)/frieren/api
	mv $(PKG_BUILD_DIR)/frieren-back/dist/modules $(PKG_BUILD_DIR)/frieren/modules
endef

define Compile/Frontend
	# Compile webapp
	cd $(PKG_BUILD_DIR)/frieren-front && \
	cp config/.env.prod .env && \
	yarn workspaces focus --production && \
	yarn install --immutable && \
	yarn build

	# Clean original assets
	cd $(PKG_BUILD_DIR)/frieren-front/dist/assets && \
	rm -f *.js *.css && \
	mv index.js.gz index.js && \
	mv index.css.gz index.css
endef

define Compile/Backend
	# Cleanup .php files to conserve disk space
	php $(PKG_BUILD_DIR)/tools/api-clean.php $(PKG_BUILD_DIR)/frieren-back/api $(PKG_BUILD_DIR)/frieren-back/dist/api
	php $(PKG_BUILD_DIR)/tools/api-clean.php $(PKG_BUILD_DIR)/frieren-back/modules $(PKG_BUILD_DIR)/frieren-back/dist/modules

	# Setup OpenWRT Frieren version
	cp $(CURDIR)/files/config/config.php $(PKG_BUILD_DIR)/frieren-back/dist/api/config

	# Set execute permissions for any scripts that need it
	find $(PKG_BUILD_DIR)/frieren-back/dist/api -name "*.sh" -exec chmod +x {} \;
	find $(PKG_BUILD_DIR)/frieren-back/dist/modules -name "*.sh" -exec chmod +x {} \;
endef

define Package/frieren/install
	$(INSTALL_DIR) $(1)/usr/share/frieren
	$(INSTALL_DIR) $(1)/etc/nginx
	$(INSTALL_DIR) $(1)/etc/nginx/conf.d
	$(INSTALL_DIR) $(1)/etc/php8-fpm.d
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config

	$(INSTALL_CONF) ./files/etc/nginx/uci.conf.template $(1)/etc/nginx/
	$(INSTALL_CONF) ./files/etc/php8-fpm.d/www.conf $(1)/etc/php8-fpm.d/
	$(INSTALL_CONF) ./files/etc/config/nginx $(1)/etc/config/
	$(INSTALL_CONF) ./files/etc/config/frieren $(1)/etc/config/
	$(INSTALL_CONF) ./files/etc/php.ini $(1)/etc/

	$(INSTALL_BIN) ./files/etc/init.d/php8-fpm $(1)/etc/init.d/

	$(CP) ./files/etc/nginx/conf.d/* $(1)/etc/nginx/conf.d/
	$(CP) -r $(PKG_BUILD_DIR)/frieren $(1)/usr/share/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
