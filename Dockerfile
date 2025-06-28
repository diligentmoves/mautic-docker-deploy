FROM mautic/mautic:5-apache

# Optional: install extra PHP extensions or Composer
RUN apt-get update && apt-get install -y \
    unzip curl git nano \
    && rm -rf /var/lib/apt/lists/*
