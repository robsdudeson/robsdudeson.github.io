---
layout: post
title: Passing a USB Blu-ray Drive to WSL 2
date: 2026-10-20
tags: wsl windows usbipd bluray linux
published: true
---

# Passing a USB Blu-ray Drive to WSL 2

I wanted to image a Blu-ray disc from WSL with GNU ddrescue. Windows could use the drive, but WSL could not see it: no `/dev/sr0`, no optical drive in `lsblk`, and nothing useful under `/dev`.

The key distinction is simple: WSL can read files from Windows drives, but it cannot automatically use physical USB devices. `ddrescue` needs direct access to the drive.

[`usbipd-win`](https://github.com/dorssel/usbipd-win) passes the USB drive from Windows to WSL. Once attached, Linux sees it as a normal optical device, usually `/dev/sr0`.

## Prerequisites

You need:

- WSL 2
- A USB optical drive
- [`usbipd-win`](https://github.com/dorssel/usbipd-win) on Windows
- `ddrescue` in WSL
- Free space for the disc image

On Debian or Ubuntu:

```sh
sudo apt update
sudo apt install gddrescue kmod
```

Other distributions need equivalent `ddrescue` and `kmod` packages.

`kmod` provides `modprobe`, which `usbipd-win` may need while it attaches the device.

## Find and share the drive

Insert the disc, then open **PowerShell as Administrator**:

```powershell
usbipd list
```

Find the optical drive and note its `BUSID`, such as `2-4`. Then share it:

```powershell
usbipd bind --busid 2-4
```

Replace `2-4` with your drive's bus ID.

## Attach it to WSL

In a normal PowerShell window:

```powershell
usbipd attach --wsl --busid 2-4
```

Windows cannot use the drive while WSL owns it.

Back in WSL, verify that Linux sees it:

```sh
ls -l /dev/sr*
lsblk
```

The drive should appear as `/dev/sr0`.

## Fix common failures

### `modprobe` is unavailable

Install `kmod`, then attach the drive again:

```sh
# Debian or Ubuntu
sudo apt install kmod
```

### Windows says the device is busy

Windows may still hold the disc after you close the visible application. Close Explorer windows, media players, ripping tools, and disc-inspection tools, then retry:

```powershell
usbipd attach --wsl --busid 2-4
```

As a last resort, run this from an elevated PowerShell:

```powershell
usbipd bind --busid 2-4 --force
```

`--force` disconnects the drive from Windows, so use it only when closing the process does not work.

## Image the disc

Once WSL exposes `/dev/sr0`, create a destination and start a resumable image:

```sh
mkdir -p ~/images

sudo ddrescue -n -d /dev/sr0 ~/images/disc.iso ~/images/disc.map
sudo ddrescue -d -r3 /dev/sr0 ~/images/disc.iso ~/images/disc.map
```

The first pass copies readable sectors without retrying failures. The second retries failed sectors three times.

Keep the `.map` file. It records completed work, so you can resume safely after an interruption.

Check that the destination has enough space before you begin:

```sh
df -h ~/images
lsblk -b -dn -o NAME,SIZE /dev/sr0
```

## Return the drive to Windows

When you finish, detach it:

```powershell
usbipd detach --busid 2-4
```

USB/IP attachments do not persist across Windows or WSL restarts. Attach the drive again before the next use.

The important point is that Windows-drive access is not USB-device access. Pass the physical drive through with `usbipd-win`, and Linux tools in WSL can use it like a native device.
