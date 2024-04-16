#!/bin/sh

# Logger function
log() {
    local message="$1"
    local type="$2"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local prefix=""

    case "$type" in
        "info") prefix="[INFO]" ;;
        "success") prefix="[SUCCESS]" ;;
        "error") prefix="[ERROR]" ;;
        *) prefix="[LOG]" ;;
    esac

    echo "$timestamp $prefix $message"
}

# Error handler function
handle_error() {
    local exit_code="$1"
    local error_message="$2"
    log "Error: $error_message (Exit Code: $exit_code)" "error"
    exit "$exit_code"
}

# Function to check OpenWRT version and return package URL
get_package_url() {
    local version="$1"
    local base_url="https://raw.githubusercontent.com/xchwarze/frieren-release/master/packages/openwrt"
    local package_url=""

    if [ "$version" = "19" ]; then
        package_url="${base_url}/19/frieren_latest.ipk"
    elif [ "$version" -ge 20 ]; then
        package_url="${base_url}/latest/frieren_latest.ipk"
    else
        log "Unsupported version: OpenWRT $version" "error"
        exit 1
    fi

    echo "$package_url"
}

# Function to uninstall old package
uninstall_old_package() {
    local package_name="frieren"
    if opkg list-installed | grep -q "$package_name"; then
        log "Removing old package $package_name..." "info"
        opkg remove "$package_name" || handle_error 1 "Failed to remove old package $package_name"
    else
        log "No old package $package_name installed, skipping removal." "info"
    fi
}

# Main installation function
install_package() {
    local version="$(awk -F"'" '/DISTRIB_RELEASE/{print $2}' /etc/openwrt_release | cut -d'.' -f1)"
    local package_url="$(get_package_url "$version")"

    if [ -z "$package_url" ]; then
        handle_error 1 "Failed to obtain package URL for version $version"
    fi

    log "Downloading and installing package for OpenWRT $version..." "info"
    wget -qO /tmp/package.ipk "$package_url" && opkg install /tmp/package.ipk

    if [ $? -eq 0 ]; then
        log "Package installation completed successfully" "success"
    else
        handle_error 1 "Package installation failed"
    fi
}

# Display panel URL
display_access_url() {
    local ip_address="$(ip -4 addr show br-lan | awk '/inet/ {print $2}' | cut -d'/' -f1)"
    log "To access the Frieren web interface, open a web browser and navigate to: http://$ip_address:5000/" "info"
}

# Ensure the script is running on OpenWRT
if [ -f "/etc/openwrt_release" ]; then
    log "OpenWRT system detected, proceeding with installation..." "info"
    uninstall_old_package
    install_package
    display_access_url
else
    log "This script is only supported on OpenWRT systems." "error"
    exit 1
fi
