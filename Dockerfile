FROM mcr.microsoft.com/powershell:latest

# Essentials + rasterizer + fonts
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates tzdata curl \
    librsvg2-bin fonts-dejavu && \
    rm -rf /var/lib/apt/lists/*

ENV POWERSHELL_TELEMETRY_OPTOUT=1

# Install PSSVG non-interactively (pre-install NuGet, trust PSGallery)
RUN pwsh -NoLogo -NoProfile -NonInteractive -Command \
  "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
   Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; \
   Install-Module -Name PSSVG -Repository PSGallery -Scope AllUsers -Force -AllowClobber; \
   Import-Module PSSVG; 'PSSVG installed OK'"

# ... then COPY your module, etc.
WORKDIR /app
COPY PixelPoSH /app/PixelPoSH
CMD [\"pwsh\",\"-NoLogo\",\"-NoProfile\",\"-Command\",\"Import-Module ./PixelPoSH/PixelPoSH.psm1; 'PixelPoSH ready'\"] 