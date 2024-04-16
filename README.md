# Frieren Release Repository

This repository serves as the primary hub for the distribution of the Frieren project's releases and installation scripts. It is intended to complement the main Frieren repository by providing ready-to-deploy packages and the necessary tools to install Frieren on various platforms.

## Repository Structure

- **`/install`**: This directory contains scripts for installing Frieren. These scripts simplify the process of setting up Frieren on different operating systems and environments.
- **`/packages`**: Here you'll find the compiled packages and binaries of Frieren, ready for deployment. Each package is tailored for specific architectures and platforms.

## Installation

Frieren is currently fully supported only on OpenWRT platforms. As a result, distributable releases are specifically compiled for this architecture. Below are the instructions for both automated and manual installation methods on OpenWRT:

### Automatic Installation

We recommend using the automated install script for a convenient and straightforward installation process. This is the preferred method. To install Frieren using the automated script on your OpenWRT device, run the following command in your terminal:

```bash
wget -qO- https://raw.githubusercontent.com/xchwarze/frieren-release/master/install/install-openwrt.sh | sh
```

This command fetches and executes the installation script automatically, ensuring that Frieren is configured and installed correctly on your device.

### Manual Installation

If you prefer to manually install Frieren, or if you need more control over the installation process, follow these steps:

1. **Download the Package**
   Download the latest version of the `frieren_latest.ipk` package from the `packages/openwrt/19` directory in our repository.

2. **Install the Package**
   Install the downloaded package using `opkg`, the default package manager for OpenWRT:

   ```bash
   opkg install /tmp/frieren_latest.ipk
   ```

## Usage

Once installed, Frieren can be accessed through its web interface or via API calls, depending on your installation type and configuration. By default, Frieren is installed in the `/usr/share/frieren` directory on your device.

To access the Frieren web interface, open a web browser and navigate to the IP address of your OpenWRT device followed by port 5000. For a typical installation, you would enter the following URL:

```
http://192.168.1.1:5000/
```

Please ensure that your device’s IP address is correctly configured and that you are connected to the correct network. For more detailed information on using and configuring Frieren, please refer to the [Frieren repository](https://github.com/xchwarze/frieren).

## Contributing

Contributions to the `frieren-release` repository are welcome. Enhancements to installation scripts, packaging, and documentation are particularly valuable. Please submit pull requests or raise issues as needed.

## License

Like the main Frieren project, the contents of this repository are licensed under the LGPL-3.0-only License. This license allows for extensive collaboration and distribution of the software.

## Contact

For more information, support, or to get involved with the Frieren project, please contact the lead developer:
- **DSR!** - xchwarze@gmail.com
