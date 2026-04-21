
## 1️⃣ Import CA certificate into **system trusted store** (most common)

This makes Linux trust certificates signed by `ca.crt` (for curl, browsers, system services).

### ✅ Ubuntu / Debian

```bash
sudo cp ca.crt /usr/local/share/ca-certificates/my-ca.crt
sudo update-ca-certificates
```

Verify:

```bash
ls /etc/ssl/certs | grep my-ca
```

---

### ✅ RHEL / CentOS / Rocky / Alma

```bash
sudo cp ca.crt /etc/pki/ca-trust/source/anchors/my-ca.crt
sudo update-ca-trust
```

---

### ✅ Arch Linux

```bash
sudo cp ca.crt /etc/ca-certificates/trust-source/anchors/my-ca.crt
sudo trust extract-compat
```

---

## 2️⃣ Use certificate + key for a **server (Nginx, Apache, etc.)**

⚠️ **Do NOT import `ca.key` into system trust**  
Private keys must remain protected.

### Example: Nginx

```bash
sudo mkdir -p /etc/ssl/myca
sudo cp ca.crt ca.key /etc/ssl/myca
sudo chmod 600 /etc/ssl/myca/ca.key
```

In `nginx.conf` or site config:

```nginx
ssl_certificate     /etc/ssl/myca/ca.crt;
ssl_certificate_key /etc/ssl/myca/ca.key;
```

Reload:

```bash
sudo systemctl reload nginx
```

---

## 3️⃣ Use for **OpenSSL / curl only (without system install)**

### curl

```bash
curl --cacert ca.crt https://example.com
```

### OpenSSL

```bash
openssl verify -CAfile ca.crt server.crt
```

---

## 4️⃣ Import into **Java (JDK / JVM truststore)**

```bash
sudo keytool -import \
  -trustcacerts \
  -alias my-ca \
  -file ca.crt \
  -keystore $JAVA_HOME/lib/security/cacerts
```

Password (default):

```
changeit
```

---

## 5️⃣ Import into **Docker containers**

### Copy during build

```dockerfile
COPY ca.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates
```

---

## 🔐 Important Security Notes

- ✅ `ca.crt` → safe to distribute
- ❌ `ca.key` → **must remain private**
- Never commit `ca.key` to Git
- Set permissions:

```bash
chmod 600 ca.key
```

---

## ✅ What do you want to use this certificate for?

Tell me **one of these**, and I’ll give you exact commands:

- ✅ HTTPS server (Nginx / Apache)
- ✅ Trust internal TLS (curl, Docker, system)
- ✅ Java application
- ✅ Kubernetes
- ✅ VPN / mTLS
- ✅ Something else

I’ll tailor it precisely.
