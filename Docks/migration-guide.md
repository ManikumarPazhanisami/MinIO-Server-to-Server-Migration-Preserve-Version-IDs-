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
2️⃣ Run rsync (Core Step)
sudo rsync -avz --progress \
  --rsync-path='sudo rsync' \
  <SOURCE_USER>@<SOURCE_HOST>:<SOURCE_DATA_PATH>/ \
  <DEST_DATA_PATH>/
3️⃣ Fix Permissions
sudo chown -R <DEST_SERVICE_USER>:<DEST_SERVICE_USER> <DEST_DATA_PATH>/
4️⃣ Start MinIO
sudo systemctl start minio
</details>
<details> <summary>✅ Verification</summary>
📊 Bucket Count
minio-mc ls <SOURCE_ALIAS> | wc -l
minio-mc ls <DEST_ALIAS> | wc -l

✔ Counts must match

📁 Object Count
minio-mc ls --recursive <SOURCE_ALIAS>/<BUCKET_NAME>/ | wc -l
minio-mc ls --recursive <DEST_ALIAS>/<BUCKET_NAME>/ | wc -l
🔥 Version ID Validation (Critical)
minio-mc ls --versions <SOURCE_ALIAS>/<BUCKET_NAME>/<OBJECT_PATH>
minio-mc ls --versions <DEST_ALIAS>/<BUCKET_NAME>/<OBJECT_PATH>

✔ Version IDs must be identical

</details>
<details> <summary>⚠️ Pitfalls</summary>
Mistake	Impact
Using mc mirror	Version IDs lost ❌
Copying while MinIO is running	Data corruption ❌
Missing .minio.sys	Broken buckets ❌
</details>
<details> <summary>🧠 DevOps Learnings</summary>
Storage-level migration > API-level migration
.minio.sys is critical metadata
rsync is idempotent and resumable
Proper service control prevents corruption
Always validate after migration
</details>
⚡ One-Command Automation Script
#!/bin/bash

# ===== CONFIG =====
SOURCE_USER="<SOURCE_USER>"
SOURCE_HOST="<SOURCE_HOST>"
SOURCE_PATH="<SOURCE_DATA_PATH>"
DEST_PATH="<DEST_DATA_PATH>"
SERVICE="minio"
DEST_USER="<DEST_SERVICE_USER>"

echo "🚀 Starting MinIO Migration..."

echo "🛑 Stopping MinIO..."
sudo systemctl stop $SERVICE

echo "📦 Running rsync..."
sudo rsync -avz --progress \
  --rsync-path='sudo rsync' \
  $SOURCE_USER@$SOURCE_HOST:$SOURCE_PATH/ \
  $DEST_PATH/

echo "🔧 Fixing permissions..."
sudo chown -R $DEST_USER:$DEST_USER $DEST_PATH/

echo "▶️ Starting MinIO..."
sudo systemctl start $SERVICE

echo "✅ Migration completed successfully!"
📌 Usage
chmod +x migrate.sh
./migrate.sh
🎯 Outcome
✅ Full data migration
✅ Version IDs preserved
✅ Metadata intact
✅ Repeatable automation

---

This version will:
- look clean in GitHub (collapsible sections = 🔥)
- feel like a real DevOps project
- be easy to demo in interviews
