# ═══════════════════════════════════════════════════════════════════════════════
# BASE STAGE - Common dependencies and configurations
# ═══════════════════════════════════════════════════════════════════════════════
FROM hub.atlantiscloud.ir/alpine:3.23 AS base

RUN echo "https://mirror.arvancloud.ir/alpine/v3.23/main" > /etc/apk/repositories && \
    echo "https://mirror.arvancloud.ir/alpine/v3.23/community" >> /etc/apk/repositories

RUN apk update
RUN apk add --no-cache python3 py3-pip libc6-compat tzdata bind

ENV TZ=Asia/Tehran
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# ═══════════════════════════════════════════════════════════════════════════════
# HTTP-RELAY STAGE - Install Python dependencies and run application
# ═══════════════════════════════════════════════════════════════════════════════
FROM base AS http-relay
WORKDIR /app

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    -i https://mirror-pypi.runflare.com/simple/ \
    --trusted-host mirror-pypi.runflare.com

COPY . .

# RUN addgroup -S -g 1001 appgroup 
# RUN adduser -S -u 1001 -G appgroup appuser
# RUN chown -R appuser:appgroup /app
# USER appuser

EXPOSE 8085

ENTRYPOINT ["python3", "main.py"]
