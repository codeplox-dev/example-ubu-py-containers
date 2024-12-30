ARG PY_311_VERS=3.11.10
ARG PY_312_VERS=3.12.8
ARG PY_313_VERS=3.13.1

ARG UBUNTU_VERS=ubuntu:noble-20241118.1


###############################################################################
# Builder, to establish built Python versions from source
###############################################################################
FROM ${UBUNTU_VERS}

ARG PY_311_VERS
ARG PY_312_VERS
ARG PY_313_VERS

SHELL ["/bin/bash", "-c", "-l"]
WORKDIR /root

RUN apt-get update && \
  apt-get upgrade -yq && \
  apt-get install -yq wget pkg-config && \
  apt-get install -yq tar xz-utils build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev

COPY scripts scripts

RUN ./scripts/fetch-python-tgz ${PY_311_VERS} && \
  ./scripts/fetch-python-tgz ${PY_312_VERS} && \
  ./scripts/fetch-python-tgz ${PY_313_VERS} && \
  wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py &>/dev/null && \
  # Install Python 3.13.x; this is as how they describe it in
  # their docs; Note: We 'altinstall' bc we have multiple
  # versions installed, and don't want this as the default
  mkdir -p /usr/local/src || true && \
  tar zxf Python-${PY_313_VERS}.tgz -C /usr/local/src && \
  pushd $PWD && cd /usr/local/src/Python-${PY_313_VERS} && \
  echo "Configuring python ${PY_313_VERS}" && \
  ./configure --quiet &>/dev/null && \
  make -j &>/dev/null && make altinstall --quiet &>/dev/null && popd && \
  python3.13 get-pip.py && rm -rf /usr/local/src/Python* && \
  # Install Python 3.12.x
  tar zxf Python-${PY_312_VERS}.tgz -C /usr/local/src && \
  pushd $PWD && cd /usr/local/src/Python-${PY_312_VERS} && \
  echo "Configuring python ${PY_312_VERS}" && \
  ./configure --quiet &>/dev/null && \
  make -j &>/dev/null && make altinstall --quiet &>/dev/null && popd && \
  python3.12 get-pip.py && rm -rf /usr/local/src/Python* && \
  # Install Python 3.11.x; Make it default Python as well
  tar zxf Python-${PY_311_VERS}.tgz -C /usr/local/src && \
  pushd $PWD && cd /usr/local/src/Python-${PY_311_VERS} && \
  echo "Configuring python ${PY_311_VERS}" && \
  ./configure --quiet &>/dev/null && \
  make -j &>/dev/null && make install --quiet &>/dev/null && popd && \
  python3.11 get-pip.py && rm -rf /usr/local/src/Python* && \
  ln -sf /usr/local/bin/python3.11 /usr/local/bin/python && \
  ln -sf /usr/local/bin/python3.11 /usr/local/bin/python3 && \
  apt-get autoremove --purge build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev wget
