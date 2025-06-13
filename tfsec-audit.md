# Cloud Storage Security Audit Findings

This document summarizes potential security gaps identified by tfsec across Azure, AWS S3, and Google Cloud Storage resources.

---

## Azure Storage Findings

1. **Storage account uses an insecure TLS version**  
   - **Check ID:** `azure-storage-use-secure-tls-policy`  
   - **Severity:** Critical  
   - **Description:** The storage account is still permitting older TLS protocols (for example, TLS 1.0 or 1.1), which have well-documented vulnerabilities such as downgrade attacks and weak cipher suites. Any client – legitimate or malicious – could negotiate an insecure handshake.  
   - **Risk:** Data in transit to or from this account could be intercepted or tampered with.

2. **Container allows public access**  
   - **Check ID:** `azure-storage-no-public-access`  
   - **Severity:** High  
   - **Description:** The container’s `container_access_type = "blob"` setting makes all blobs within it world-readable. There is no private boundary preventing unauthorized data exposure.  
   - **Risk:** Sensitive or internal files could be exfiltrated by anyone on the internet.

---

## AWS S3 Findings

_All of the following relate to the S3 bucket lacking access-blocking controls and default protections._

3. **No public access block so not blocking public ACLs**  
   - **Check ID:** `aws-s3-block-public-acls`  
   - **Severity:** High  
   - **Description:** Without an explicit public-access block, users could upload objects with a public ACL, making individual objects world-readable even if the bucket policy is otherwise restrictive.

4. **No public access block so not blocking public policies**  
   - **Check ID:** `aws-s3-block-public-policy`  
   - **Severity:** High  
   - **Description:** The bucket could be assigned a policy that grants `*` (everyone) principal rights to list or read its contents.

5. **No public access block so not ignoring public ACLs**  
   - **Check ID:** `aws-s3-ignore-public-acls`  
   - **Severity:** High  
   - **Description:** Even if a caller tries to set a public ACL on upload, that ACL will be honored rather than automatically stripped.

6. **No public access block so not restricting public buckets**  
   - **Check ID:** `aws-s3-no-public-buckets`  
   - **Severity:** High  
   - **Description:** Lacking `restrict_public_buckets` means the bucket itself can become public (via ACL or policy) without further guardrails.

7. **Bucket does not have encryption enabled**  
   - **Check ID:** `aws-s3-enable-bucket-encryption`  
   - **Severity:** High  
   - **Description:** Objects stored in the bucket are not automatically encrypted at rest. If an attacker gains direct storage-layer access, they could read raw object data.

8. **Bucket does not encrypt data with a customer managed key**  
   - **Check ID:** `aws-s3-encryption-customer-key`  
   - **Severity:** High  
   - **Description:** Even if server-side encryption is enabled, it relies on AWS-managed keys rather than a customer-managed CMK – limiting auditability and key rotation policies.

9. **Bucket does not have logging enabled**  
   - **Check ID:** `aws-s3-enable-bucket-logging`  
   - **Severity:** Medium  
   - **Description:** No server-access logs means you have no record of who requested or modified objects in the bucket, hampering forensic investigations after a breach.

10. **Bucket does not have versioning enabled**  
    - **Check ID:** `aws-s3-enable-versioning`  
    - **Severity:** Medium  
    - **Description:** Deleted or overwritten objects are immediately gone with no built-in point-in-time recovery or protection against accidental or malicious deletions.

11. **No corresponding public access block**  
    - **Check ID:** `aws-s3-specify-public-access-block`  
    - **Severity:** Low  
    - **Description:** The bucket has no attached `aws_s3_bucket_public_access_block` resource, so you lack a central place to control ACL and policy-based exposure.

---

## Google Cloud Storage Findings

12. **Bucket has uniform bucket-level access disabled**  
    - **Check ID:** `google-storage-enable-ubla`  
    - **Severity:** Medium  
    - **Description:** Using ACLs rather than IAM-only controls increases configuration complexity and the chance of granting unintended permissions.

13. **Storage bucket encryption does not use a customer-managed key**  
    - **Check ID:** `google-storage-bucket-encryption-customer-key`  
    - **Severity:** Low  
    - **Description:** Data at rest is encrypted with Google-managed keys. You do not have direct control over key rotation, permissions, or audit logs.

---

## Summary of Counts

- **Critical:** 1  
- **High:** 7  
- **Medium:** 3  
- **Low:** 2  
