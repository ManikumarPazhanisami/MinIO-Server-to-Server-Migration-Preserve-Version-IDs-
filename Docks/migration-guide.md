# 📦 MinIO Storage-Level Migration Guide

This guide outlines the process for migrating MinIO data directly at the storage level using `rsync`. This method is critical when you need to preserve object Version IDs exactly as they exist on the source, which standard API-level tools (like `mc mirror`) cannot guarantee.

---

## 🚀 Migration Steps

### 1️⃣ Stop MinIO Services

To prevent data corruption and ensure a consistent metadata state, stop the MinIO service on the destination server (and optionally the source).

```bash
sudo systemctl stop minio
```

---

### 2️⃣ Run rsync (Core Step)

Execute the storage-level copy. This ensures the `.minio.sys` directory (which contains critical backend metadata) is copied along with the raw bucket data. This step is idempotent and resumable.

```bash
sudo rsync -avz --progress \
  --rsync-path='sudo rsync' \
  <SOURCE_USER>@<SOURCE_HOST>:<SOURCE_DATA_PATH>/ \
  <DEST_DATA_PATH>/
```

---

### 3️⃣ Fix Permissions

Ensure the MinIO service user on the destination server owns all the newly migrated directories and files.

```bash
sudo chown -R <DEST_SERVICE_USER>:<DEST_SERVICE_USER> <DEST_DATA_PATH>/
```

---

### 4️⃣ Start MinIO

Bring the MinIO service back online on the destination server.

```bash
sudo systemctl start minio
```

---

## ✅ Verification Phase

Validation is mandatory. After starting the service, validate the migration using the MinIO Client (`mc`).

### 📦 Bucket Count

Verify that the total number of buckets matches between the source and destination.

```bash
minio-mc ls <SOURCE_ALIAS> | wc -l
minio-mc ls <DEST_ALIAS> | wc -l
```

✔ Success Criteria: Both counts must match perfectly.

---

### 📁 Object Count (Optional)

Verify the total number of objects within a specific bucket.

```bash
minio-mc ls --recursive <SOURCE_ALIAS>/<BUCKET_NAME>/ | wc -l
minio-mc ls --recursive <DEST_ALIAS>/<BUCKET_NAME>/ | wc -l
```

---

### 🔥 Version ID Validation (Critical)

Confirm that the original Version IDs were successfully preserved during the transfer.

```bash
minio-mc ls --versions <SOURCE_ALIAS>/<BUCKET_NAME>/<OBJECT_PATH>
minio-mc ls --versions <DEST_ALIAS>/<BUCKET_NAME>/<OBJECT_PATH>
```

✔ Success Criteria: Version IDs must be strictly identical across both environments.

---

## ⚠️ Important Notes

- Always stop MinIO before copying data to ensure consistency  
- Do NOT use `mc mirror` if preserving exact version IDs is a requirement  
- Ensure the `.minio.sys` directory is copied along with bucket data  
- The rsync command can be safely re-run if interrupted  

---

## 🧠 Key DevOps Learnings

- Storage-Level > API-Level Migration  
- Metadata is critical (`.minio.sys`)  
- `rsync` is idempotent and resumable  
- Proper service control prevents corruption  
- Always validate after migration  
