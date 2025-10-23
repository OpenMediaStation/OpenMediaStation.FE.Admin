FROM nginx:latest AS base

# Install flutter dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    wget \
    unzip \
    xz-utils \
    zip \
    gdb \
    libstdc++6 \
    libglu1-mesa \
    python3 \
  && rm -rf /var/lib/apt/lists/*

# Clone the flutter repo and checkout version
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
WORKDIR /usr/local/flutter
RUN git checkout 3.35.1

# Set flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v
# Enable flutter web
RUN flutter channel stable
RUN flutter config --enable-web 

COPY ./ /usr/share/temp

RUN cd /usr/share/temp && flutter build web --release

# ---

FROM nginx:latest AS final

COPY --from=base /usr/share/temp/build/web/. /usr/share/nginx/html/