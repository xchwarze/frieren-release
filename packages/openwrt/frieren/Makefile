include $(TOPDIR)/rules.mk

PKG_NAME:=frieren
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/xchwarze/frieren.git
PKG_SOURCE_VERSION:=master
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=nodejs yarn

include $(INCLUDE_DIR)/package.mk

define Package/frieren
    SECTION:=net
    CATEGORY:=Network
    TITLE:=Frieren - universal security tool for routers and SBCs
    DEPENDS:=+nginx +php7-fpm +php7-mod-hash +php7-mod-json +php7-mod-mbstring +php7-mod-session +php7-mod-sqlite3
endef

define Package/frieren/description
    Frieren, compiled as a universal security tool for routers and SBCs, features a lightweight PHP backend and a React frontend.
endef

define Build/Prepare
    $(call Build/Prepare/Default)

    # Fetch release info
    GIT_REV=$$(git -C $(PKG_BUILD_DIR) rev-parse --short HEAD); \
    APP_VERSION=$$(grep '"version":' $(PKG_BUILD_DIR)/frieren-front/package.json | awk -F'"' '{print $$4}'); \

    # Update the .env.release file
    sed -i 's/PLACEHOLDER_BUILD/$${GIT_REV}/' $(PKG_BUILD_DIR)/frieren-front/config/.env.release; \
    sed -i 's/PLACEHOLDER_VERSION/$${APP_VERSION}/' $(PKG_BUILD_DIR)/frieren-front/config/.env.release
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
    yarn install --immutable
endef

define Compile/Backend
    # Cleanup .php files to conserve disk space
    php $(PKG_BUILD_DIR)/tools/api-clean.php $(PKG_BUILD_DIR)/frieren-back/api $(PKG_BUILD_DIR)/frieren-back/dist/api
    php $(PKG_BUILD_DIR)/tools/api-clean.php $(PKG_BUILD_DIR)/frieren-back/modules $(PKG_BUILD_DIR)/frieren-back/dist/modules

    # Set execute permissions for any scripts that need it
    find $(PKG_BUILD_DIR)/frieren-back/dist/api -name "*.sh" -exec chmod +x {} \;
    find $(PKG_BUILD_DIR)/frieren-back/dist/modules -name "*.sh" -exec chmod +x {} \;
endef

define Package/frieren/install
    $(INSTALL_DIR) $(1)/usr/share/frieren
    $(INSTALL_DIR) $(1)/etc/nginx
    $(INSTALL_DIR) $(1)/etc/php7-fpm.d
    $(INSTALL_DIR) $(1)/etc/init.d
    $(INSTALL_DIR) $(1)/lib/upgrade/keep.d

    $(INSTALL_CONF) ./files/nginx/nginx.conf $(1)/etc/nginx/
    $(INSTALL_CONF) ./files/php7-fpm.d/www.conf $(1)/etc/php7-fpm.d/
    $(INSTALL_CONF) ./files/php7-fpm.conf $(1)/etc/
    $(INSTALL_BIN) ./files/etc/init.d/php7-fpm $(1)/etc/init.d/
    $(CP) ./files/lib/upgrade/keep.d/frieren $(1)/lib/upgrade/keep.d/

    $(CP) -r $(PKG_BUILD_DIR)/frieren $(1)/usr/share/
endef

$(eval $(call BuildPackage,frieren))
