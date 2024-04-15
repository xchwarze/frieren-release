# Building Frieren for OpenWRT

This guide outlines the steps necessary to compile the Frieren package for OpenWRT using the SDK. Follow these instructions to setup and build the package.

## Prerequisites

Ensure you have a stable internet connection and sufficient disk space on your system to handle the SDK and the build outputs.

## Setup

1. **Download and extract the OpenWRT SDK**:
   ```bash
   wget https://downloads.openwrt.org/releases/19.07.7/targets/ar71xx/generic/openwrt-sdk-19.07.7-ar71xx-generic_gcc-7.5.0_musl.Linux-x86_64.tar.xz
   tar xJf openwrt-sdk-19.07.7-ar71xx-generic_gcc-7.5.0_musl.Linux-x86_64.tar.xz
   mv openwrt-sdk-19.07.7-ar71xx-generic_gcc-7.5.0_musl.Linux-x86_64 openwrt-sdk-19.07.7-ar71xx-generic
   cd openwrt-sdk-19.07.7-ar71xx-generic
   ```

2. **Add additional feeds**:
   ```bash
   echo "src-link frieren /path/to/frieren-release/packages/openwrt" >> feeds.conf
   ```

3. **Update and install feeds**:
   ```bash
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   ```

4. **Install the Frieren package specifically**:
   ```bash
   ./scripts/feeds install -p frieren frieren
   ```

5. **Configure the build**:
   ```bash
   make menuconfig
   ```
   Navigate to the section where `frieren` is located (typically under 'Extras' or your specific category) and select it for inclusion in the build.

## Compilation

1. **Download any necessary sources for the Frieren package**:
   ```bash
   make package/frieren/download
   ```

2. **Compile the Frieren package**:
   ```bash
   make package/frieren/compile
   ```

   The compilation output will be located in:
   ```
   openwrt-sdk-19.07.7-ar71xx-generic_gcc-7.5.0_musl.Linux-x86_64/bin/packages/<arch>/<feed_name>/
   ```

## Notes

- Replace `/path/to/frieren-release/packages/openwrt` with the actual path to your local `frieren` package source.
- Adjust the architecture in the final path as needed depending on the target architecture for your build.
