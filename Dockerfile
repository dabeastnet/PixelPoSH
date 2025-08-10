ARG PS_TAG=latest

# Stage 1: fetch PSSVG on the build platform (downloads module into /out)
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/powershell:${PS_TAG} AS modfetch
RUN pwsh -NoLogo -NoProfile -NonInteractive -Command `
    "Set-PSRepository PSGallery -InstallationPolicy Trusted; `
     Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; `
     Save-Module -Name PSSVG -Path /out -Force"

# Stage 2: final runtime image
FROM mcr.microsoft.com/powershell:${PS_TAG}

# Install dependencies for PNG rendering
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates tzdata librsvg2-bin fonts-dejavu && \
    rm -rf /var/lib/apt/lists/*

# Copy the downloaded module from the build stage
COPY --from=modfetch /out/PSSVG /usr/local/share/powershell/Modules/PSSVG

# Copy your module into /app
WORKDIR /app
COPY PixelPoSH /app/PixelPoSH

# Set default command (JSON array form avoids OS‑signal warnings)
CMD ["pwsh","-NoLogo","-NoProfile","-Command","Import-Module ./PixelPoSH/PixelPoSH.psm1; 'PixelPoSH ready'"]
