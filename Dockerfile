RUN pwsh -NoLogo -NoProfile -NonInteractive -Command \
  "Set-PSRepository PSGallery -InstallationPolicy Trusted; \
   Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; \
   Save-Module -Name PSSVG -Path /out -Force"
# /out/PSSVG now contains the module (pure .psm1/.psd1, arch-agnostic)

# Stage 2: final runtime image (arm64/amd64/etc.)
FROM mcr.microsoft.com/powershell:latest

# tools + fonts for PNG support
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates tzdata librsvg2-bin fonts-dejavu && \
    rm -rf /var/lib/apt/lists/*

# copy module fetched in stage 1 (no pwsh runs here)
COPY --from=modfetch /out/PSSVG /usr/local/share/powershell/Modules/PSSVG

WORKDIR /app
COPY PixelPoSH /app/PixelPoSH

# JSON-form CMD (quiet the linter warning)
CMD ["pwsh","-NoLogo","-NoProfile","-Command","Import-Module ./PixelPoSH/PixelPoSH.psm1; 'PixelPoSH ready'"]