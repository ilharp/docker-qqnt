# syntax=docker/dockerfile:1

FROM your-committed-image

COPY --chmod=0755 rootfs-windows /
