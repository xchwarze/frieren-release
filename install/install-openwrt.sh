#!/bin/sh

# Define constants
BASE_URL="https://raw.githubusercontent.com/xchwarze/frieren-release/master/packages/openwrt"
PACKAGE_NAME="frieren"

# Logger function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$2] $1"
}

# Error handler function
handle_error() {
    log "Error: $2 (Exit Code: $1)" "ERROR"
    exit "$1"
}

# Function to check OpenWRT version and return package URL
get_package_url() {
    local version="$1"
    local package_url=""

    if [ "$version" = "19" ]; then
        package_url="${BASE_URL}/19/${PACKAGE_NAME}_latest.ipk"
    elif [ "$version" -ge 20 ]; then
        package_url="${BASE_URL}/latest/${PACKAGE_NAME}_latest.ipk"
    fi

    echo "$package_url"
}

# Function to uninstall old package
uninstall_old_package() {
    if opkg list-installed | grep -q "$PACKAGE_NAME"; then
        log "Removing old package $PACKAGE_NAME..." "INFO"
        opkg remove "$PACKAGE_NAME" || handle_error 1 "Failed to remove old package $PACKAGE_NAME"
    fi
}

# Main installation function
install_package() {
    local version="$(awk -F"'" '/DISTRIB_RELEASE/{print $2}' /etc/openwrt_release | cut -d'.' -f1)"
    local package_url="$(get_package_url "$version")"

    if [ -z "$package_url" ]; then
        handle_error 1 "Failed to obtain package URL for version $version"
    fi

    log "Updating package lists..." "INFO"
    opkg update || handle_error 1 "Failed to update package lists"

    log "Downloading and installing package for OpenWRT $version..." "INFO"
    wget -qO /tmp/package.ipk "$package_url" && opkg install /tmp/package.ipk

    [ $? -eq 0 ] || handle_error 1 "Package installation failed"
    log "Package installation completed successfully" "SUCCESS"
}

# Display panel URL
display_access_url() {
    local ip_address="$(ip -4 addr show br-lan | awk '/inet/ {print $2}' | cut -d'/' -f1)"
    log "To access the Frieren web interface, open a web browser and navigate to: http://$ip_address:5000/" "INFO"
}

# Restart necessary services
restart_services() {
    log "Restarting PHP-FPM and NGINX..." "INFO"
    /etc/init.d/nginx restart

    if [ -f "/etc/php8-fpm.conf" ]; then    
        /etc/init.d/php8-fpm restart
    else
        /etc/init.d/php7-fpm restart
    fi
}

# Ensure the script is running on OpenWRT
if [ -f "/etc/openwrt_release" ]; then
    log "OpenWRT system detected, proceeding with installation..." "INFO"
    uninstall_old_package
    install_package
    restart_services
    display_access_url
else
    log "This script is only supported on OpenWRT systems." "ERROR"
    exit 1
fi
