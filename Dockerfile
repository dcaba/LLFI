FROM ubuntu:18.04
WORKDIR /project
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    python3 \
    python3-distutils \
    python3-dev \
    libyaml-dev \
    python3-yaml \
    cmake \
    graphviz \
    unzip \
    build-essential \
  && rm -rf /var/lib/apt/lists/*
COPY installer/InstallLLFI.py .
RUN python3 InstallLLFI.py --noGUI
