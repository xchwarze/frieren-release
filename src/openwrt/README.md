# Building Frieren for OpenWrt

This guide outlines the steps necessary to compile the Frieren package for OpenWrt using the SDK. Frieren is developed and tested for OpenWrt 24.x.

## Prerequisites

- Linux x86_64 build host
- Stable internet connection and sufficient disk space
- Node.js >= 22 with corepack enabled (`corepack enable`)

## Setup

1. **Download and extract the OpenWrt SDK**:
   ```bash
   wget https://downloads.openwrt.org/releases/24.10.6/targets/ramips/rt3883/openwrt-sdk-24.10.6-ramips-rt3883_gcc-13.3.0_musl.Linux-x86_64.tar.zst
   tar --zstd -xf openwrt-sdk-24.10.6-ramips-rt3883_gcc-13.3.0_musl.Linux-x86_64.tar.zst
   mv openwrt-sdk-24.10.6-ramips-rt3883_gcc-13.3.0_musl.Linux-x86_64 openwrt-sdk
   cd openwrt-sdk
   ```

2. **Add additional feeds**:
   ```bash
   echo "src-link frieren /path/to/frieren-release/src/openwrt/latest" >> feeds.conf
   ```

3. **Update and install feeds**:
   ```bash
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   ./scripts/feeds install -p frieren frieren
   ```

4. **Configure the build**:
   ```bash
   echo "CONFIG_PACKAGE_frieren=m" >> .config
   make defconfig
   ```

## Compilation

Compile the Frieren package:
```bash
make -j1 V=s package/frieren/compile
```

The compilation output will be located in:
```
openwrt-sdk/bin/packages/<arch>/<feed_name>/
```

## Notes

- Replace `/path/to/frieren-release/src/openwrt/latest` with the actual path to your local Frieren package source.
- The SDK target (ramips/rt3883) can be changed to match your hardware. The package itself is architecture-independent (`PKGARCH:=all`).
