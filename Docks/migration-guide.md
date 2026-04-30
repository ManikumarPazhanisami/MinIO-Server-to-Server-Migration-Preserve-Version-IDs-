## 🚀 Migration Workflow

### 1️⃣ Stop Destination MinIO

```bash
sudo systemctl stop minio
2️⃣ Run rsync (Core Step)
sudo rsync -avz --progress \
  --rsync-path='sudo rsync' \
  user@source:/minio/data/ \
  /minio/data/
3️⃣ Fix Permissions
sudo chown -R minio-user:minio-user /minio/data/
4️⃣ Start MinIO
sudo systemctl start minio
✅ Verification
📦 Bucket Parity Check
minio-mc ls source | wc -l
minio-mc ls dest | wc -l

Both counts must match.

🔥 Version ID Validation (Critical)
minio-mc ls --versions source/bucket/object
minio-mc ls --versions dest/bucket/object

✔ Version IDs must match exactly

🧠 Key DevOps Learnings
Storage-level migration is more reliable than API-level migration
.minio.sys is critical for metadata consistency
rsync enables idempotent and resumable transfers
Proper service orchestration prevents corruption
Always validate data after migration
⚠️ Pitfalls Avoided
Mistake	Impact
Using mc mirror	Version loss ❌
Copying while MinIO is running	Data corruption ❌
Missing .minio.sys	Broken buckets ❌
📌 Summary

This approach ensures:

✅ Complete data migration
✅ Version ID preservation
✅ Metadata integrity
✅ Safe and repeatable process

---
