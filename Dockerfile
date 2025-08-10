FROM mcr.microsoft.com/powershell:latest

# Tools for SVG→PNG and fonts
RUN apt-get update && \
    apt-get install -y --no-install-recommends librsvg2-bin fonts-dejavu && \
    rm -rf /var/lib/apt/lists/*

# PSSVG
RUN pwsh -NoLogo -NoProfile -Command "Install-Module PSSVG -Scope AllUsers -Force"

WORKDIR /app
COPY PixelPoSH /app/PixelPoSH

# Optional: set default font via env for consistency
ENV PIXELPOSH_FONT="Arial, Helvetica, DejaVu Sans, sans-serif"

CMD ["pwsh","-NoLogo","-NoProfile","-Command","Import-Module ./PixelPoSH/PixelPoSH.psm1; 'Ready'"]
