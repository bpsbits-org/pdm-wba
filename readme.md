# Podman based Web Application Server

**pdm-wba** - (*Podman-based Web Application Server*) is a simple toolset that makes it easy to set up and manage containerized web applications on small servers, like your home server or a cloud-hosted machine running specific apps. It uses Podman (a lightweight container engine) and systemd quadlets (easy config files for containers) to automate everything, so you don't need to be a tech expert to get started.

## Why pdm-wba?

Imagine you want to run web apps (like blogs, databases, or custom tools) in containers without the hassle of complex setups. `pdm-wba` does the heavy lifting: it installs the necessary tools, configures security and networking, and lets you "drop" simple files to launch containers automatically. From a DevOps angle, it supports continuous delivery by keeping apps updated automatically and ensuring your setups are consistent across different environments—like dev, testing, staging, and production—without rebuilding servers from scratch. This saves time, reduces errors, and lets teams focus on building apps instead of managing servers.

## Key Purpose and Features

`pdm-wba` streamlines container orchestration for small-scale deployments, focusing on ease and automation:

- **Easy System Setup**: Installs everything you need (like Podman, firewalls, and monitoring tools) with one command. It configures SSH, security policies, and user accounts to keep things safe.
- **Drop-and-Go Containers**: Just place quadlet files (simple text configs for containers, volumes, and networks) in a special folder (/home/wa/install). The system checks them, installs, and starts the containers as services—no manual commands required.
- **Automatic Updates**: Containers check for new versions from online registries and update themselves quietly, often without downtime. This fits into DevOps pipelines, automating deployment and reducing the risk of running outdated software.
- **Real-Time Monitoring**: Watches for changes to your container configs and restarts services as needed. Includes tools for checking logs, status, and troubleshooting.
- **Handy Shortcuts**: Provides simple commands (aliases) for common tasks, like viewing container lists or updating apps, plus a built-in help guide.
- **Built-in Security**: Sets up firewalls, SELinux rules, and opens only needed ports to protect your server.
- **Web-Based Management with Cockpit**: `pdm-wba` enables Cockpit, a user-friendly web interface for server maintenance. Accessible via your browser, it lets you monitor system health, manage services, and view logs without command-line tools. 

## How It Works

1. **Install and Initialize**: Run the install command, and pdm-wba prepares your server with all tools and settings. It runs once to set up the base system.
2. **Add Containers**: Drop quadlet files into the monitored folder. The system validates them (e.g., checks for required sections), applies any custom settings, and starts the containers as systemd services.
3. **Monitor and Update**: Background services watch for file changes or new container versions. If something updates, it restarts smoothly to keep your apps running.
4. **Manage Easily**: Use the provided aliases or commands to check statuses, view logs, or make changes— all without diving into complex commands.

This declarative approach (defining what you want in files) makes it repeatable: copy configs between servers for identical setups in dev, test, or production environments.

## Kubernetes vs. Quadlets

**Why Quadlets Make Container Management Easier?**

In the world of container orchestration, tools like Kubernetes are powerful for managing large-scale clusters across multiple servers, handling complex deployments, scaling, and networking for big teams. However, for small servers—like a personal home setup or a single cloud instance running a few apps—Kubernetes can feel overwhelming: it requires a lot of setup, resources, and expertise to run and maintain, often needing multiple machines and constant tuning.

Quadlets, on the other hand, are a simpler alternative built into Podman and integrated with `systemd` (the standard service manager on Linux). They're essentially easy-to-read config files that define containers, networks, and volumes, much like Kubernetes manifests but without the cluster complexity. With `pdm-wba`, quadlet-based management is far easier because:

- **Less Setup Hassle**: No need for a full cluster or extra servers—just drop a file and let systemd handle the rest, like starting, stopping, and updating containers automatically.
- **Familiar and Lightweight**: Uses systemd, which most Linux servers already have, so it feels like managing regular services. It runs on a single machine, using fewer resources and avoiding the steep learning curve of Kubernetes.
- **Declarative Simplicity**: Define your app setup in plain text files (quadlets), then replicate it across environments (dev to prod) without rebuilding. Changes are applied instantly via monitoring.
- **Built-in Automation**: Integrates auto-updates and dropbox features, fitting perfectly into DevOps for small teams, where you want reliability without the overhead of enterprise tools.
- **Perfect for Small Scales**: Ideal for personal projects, testing, or production on modest servers, where Kubernetes would be overkill but quadlets provide just the right level of control and ease.

In short, quadlets offer the power of container orchestration with the simplicity of a single-server tool, making `pdm-wba` a great choice for anyone wanting automated, low-maintenance deployments without the complexity.

## DevOps Benefits

From a DevOps viewpoint, `pdm-wba` integrates seamlessly into modern workflows:

- **Continuous Delivery**: Auto-updates tie into CI/CD pipelines, pulling new app versions automatically after builds.
- **Environment Consistency**: Replicate server configs easily across stages (dev to prod) without full rebuilds, ensuring reliable deployments.
- **Reduced Manual Work**: Automation handles setup, updates, and monitoring, freeing teams to innovate.
- **Scalability for Small Teams**: Ideal for personal projects or small businesses needing reliable, low-overhead hosting without Kubernetes complexity.

## Installation

To get started on Fedora (or similar RPM-based systems), run this one command:

```shell
dnf upgrade -y && dnf copr enable -y cloud-builder/pdm-wba && dnf install -y pdm-wba
```

After installation, your server will configure itself in the background. Reconnect on port `1022` if prompted, and monitor progress with `journalctl -u pdm-wba-init --no-pager -f`. Then, start adding quadlet files to `/home/wa/install` and watch your containers launch!

For more help, run `wa-help` after setup. 