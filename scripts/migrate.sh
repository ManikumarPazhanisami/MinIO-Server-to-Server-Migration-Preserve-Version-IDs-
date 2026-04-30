
---

# 🛠️ Step 3 — Add migration script (important)

Create: `scripts/migrate.sh`

```bash
#!/bin/bash

SOURCE_USER="<SOURCE_USER>"
SOURCE_HOST="<SOURCE_HOST>"
SOURCE_PATH="<SOURCE_DATA_PATH>"
DEST_PATH="<DEST_DATA_PATH>"
SERVICE="minio"
DEST_USER="<DEST_SERVICE_USER>"

echo "Stopping MinIO..."
sudo systemctl stop $SERVICE

echo "Running rsync..."
sudo rsync -avz --progress \
  --rsync-path='sudo rsync' \
  $SOURCE_USER@$SOURCE_HOST:$SOURCE_PATH/ \
  $DEST_PATH/

echo "Fixing permissions..."
sudo chown -R $DEST_USER:$DEST_USER $DEST_PATH/

echo "Starting MinIO..."
sudo systemctl start $SERVICE

echo "Done."
