# syntax=docker/dockerfile:1

FROM your-committed-image

RUN apt update && \
  \
  # Install fonts
  apt install -y fonts-noto-cjk && \
  \
  # Cleanup
  apt autoremove -y && \
  apt clean && \
  rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/*

COPY --chmod=0755 rootfs-windows /
