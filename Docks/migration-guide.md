## 🚀 Migration Workflow

### 1️⃣ Stop Destination MinIO

```bash
sudo systemctl stop minio

### 2️⃣ Run rsync (Core Step)

```bash
sudo rsync -avz --progress \
  --rsync-path='sudo rsync' \
  user@source:/minio/data/ \
  /minio/data/
