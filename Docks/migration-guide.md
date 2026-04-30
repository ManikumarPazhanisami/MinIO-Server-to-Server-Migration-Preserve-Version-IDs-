## 🚀 MinIO Migration (Zero-Loss, Version IDs Preserved)

---

<details>
<summary>📦 Prerequisites</summary>

- SSH access between servers  
- sudo privileges  
- MinIO installed on both servers  
- Enough disk space on destination  
- MinIO service name (e.g., `minio`)  

</details>

---

<details open>
<summary>⚙️ Migration Steps</summary>

### 1️⃣ Stop Destination MinIO

```bash
sudo systemctl stop minio

### 2️⃣ Run rsync (Core Step)

```bash
sudo rsync -avz --progress \
  --rsync-path='sudo rsync' \
  <SOURCE_USER>@<SOURCE_HOST>:<SOURCE_DATA_PATH>/ \
  <DEST_DATA_PATH>/
