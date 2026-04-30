# MinIO-Server-to-Server-Migration-Preserve-Version-IDs-
A practical guide to migrate MinIO data between servers without losing object version IDs, using raw rsync.

# 🚀 MinIO Zero-Loss Migration (DevOps Project)

![Linux](https://img.shields.io/badge/Platform-Linux-blue)
![MinIO](https://img.shields.io/badge/Object_Storage-MinIO-red)
![Rsync](https://img.shields.io/badge/Data_Transfer-rsync-green)
![Status](https://img.shields.io/badge/Migration-Tested-success)
![License](https://img.shields.io/badge/License-MIT-yellow)

> Production-grade MinIO migration strategy preserving **object version IDs**, using raw rsync.

---

## 📖 Problem Statement

Standard MinIO migration (`mc mirror`) **breaks version history** by assigning new version IDs.

This project demonstrates a **DevOps-safe migration approach** that ensures:
- ✅ Zero data loss  
- ✅ Version ID preservation  
- ✅ Metadata integrity  
- ✅ Repeatable automation  

---

## 🧠 Solution Overview

We bypass MinIO API-level transfer and directly copy underlying storage using:

- `rsync` (with sudo over SSH)
- Full `.minio.sys` metadata replication
- Controlled service downtime

---

![Source Version IDs](Screenshots/version-check-source.png)

![Destination Version IDs](Screenshots/version-check-destination.png)

## 🏗️ Architecture

```mermaid
flowchart LR
    A[Source MinIO Server] -->|SSH + rsync| B[Destination MinIO Server]
    A -->|Data Path| A1[/minio/data/]
    B -->|Data Path| B1[/minio/data/]

    A1 -->|Objects + xl.meta| B1
    A1 -->|.minio.sys| B1

    B -->|Restart Service| C[MinIO Running]
    C -->|Verify| D[Version IDs Match ✅]

