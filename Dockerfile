FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    python3-pip \
    && pip3 install --no-cache-dir conan \
    && rm -rf /var/lib/apt/lists/*

#python3-pip のインストール
# apt-get install -y python3-pip
# Python 3 用のパッケージ管理ツールである pip をインストールしています。

# conan のインストール
# pip3 install --no-cache-dir conan
# pip を使って、C++ のパッケージマネージャである Conan をインストールしています。
# --no-cache-dir オプションは、インストール時にキャッシュを残さないようにするためのものです。これにより、Docker イメージのサイズを小さく保つことができます。

# 不要なキャッシュの削除
# rm -rf /var/lib/apt/lists/*
# apt-get によって作成されたキャッシュデータを削除しています。これも、Docker イメージのサイズを小さくするための処理です。

#&& を使うことで、実際は以下のような一連のコマンドが実行されることになる。
# apt-get update && apt-get install -y build-essential cmake ninja-build git python3-pip && pip3 install --no-cache-dir conan && rm -rf /var/lib/apt/lists/*

WORKDIR /work
CMD ["bash"]

