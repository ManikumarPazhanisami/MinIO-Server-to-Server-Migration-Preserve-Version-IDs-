🚀 Migration Workflow
1. Stop destination MinIO
sudo systemctl stop minio
2. Run rsync (core step)
sudo rsync -avz --progress \
  --rsync-path='sudo rsync' \
  user@source:/minio/data/ \
  /minio/data/
3. Fix permissions
sudo chown -R minio-user:minio-user /minio/data/
4. Start MinIO
sudo systemctl start minio
✅ Verification
Bucket parity
minio-mc ls source | wc -l
minio-mc ls dest | wc -l
Version ID validation (critical)
minio-mc ls --versions source/bucket/object
minio-mc ls --versions dest/bucket/object

✔ IDs must match exactly

🔥 Key DevOps Learnings
Storage-level migration > API-level migration
Importance of metadata (.minio.sys)
Idempotent transfers with rsync
Safe service orchestration
Data validation strategies
⚠️ Pitfalls Avoided
Mistake	Impact
Using mc mirror	Version loss ❌
Copy during run	Data corruption ❌
Missing metadata	Broken buckets ❌
