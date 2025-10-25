
1. プロジェクトディレクトリ作成
   mkdir -p docker-cpp-mount/src
   cd docker-cpp-mount

2. Docker image をビルド
   docker build -t cpp-dev:base .

　　意味：-t cpp-dev:base　作成するイメージに名前（タグ）をつける(cpp-devという名前でbaseタグ)
　　　　　. Dockerimage があるビルドコンテキストを指定。ここでは現在のディレクトリ。

　　以下のコマンドでDockerImageの名前とTagが確認できる
    (base) ~/A/S/D/docker-cpp-mount ❯❯❯ docker images
    REPOSITORY                    TAG       IMAGE ID       CREATED         SIZE
    cpp-dev                       bse       e7c25e15bb16   6 minutes ago   743MB
    ubuntu                        latest    66460d557b25   3 weeks ago     139MB

3. Docker コンテナを起動する
   docker run -it --rm -v "$(pwd)":/work cpp-dev:base

    意味：docker run -it cpp-dev:base	作成したイメージをもとにコンテナを起動して使う
         -v "$(pwd)":/work	Mac のカレントフォルダをコンテナにマウント（共有）する
         --rm	コンテナを終了したら自動削除する

4. コンテナ内でビルドする。
    cmake -S . -B build -G Ninja
    cmake --build build
    ./build/hello

    意味：
    | オプション      | 意味                             |
    | ---------- | ------------------------------ |
    | `cmake`    | CMakeを起動（＝ビルド構成ファイルを生成するツール）   |
    | `-S .`     | ソースコードの場所を指定（ここでは「カレントディレクトリ」） |
    | `-B build` | 生成物を置く「ビルドディレクトリ」の場所（なければ自動作成） |
    | `-G Ninja` | ビルドシステムに「Ninja」を使う指定（高速でシンプル）  これを指定しないとデフォルトでは[Unix Makefiles]になる|

    具体的に何をしているか？
    CMakeは『MakefileやNinjaファイル」を生成するツール。
    このコマンドを実行すると：
    １、カレントディレクトリ(.)内のCMakeLists.txtを読む
    ２、設定内容を解析し、 build/ ディレクトリ内にビルド設定ファイルを出力
        ・build/build.ninja
        ・build/CMakeCache.txt
        ・build/hello.dir/ など
    これでビルドの準備を整えている。

    続けて、cmake --build build　は、実際のコンパイル（ビルド）処理を行うコマンド
    | 部分              | 意味                           |
    | --------------- | ---------------------------- |
    | `cmake --build` | 「前段で構成したビルドシステムを使ってビルドを実行せよ」 |
    | `build`         | 先ほど構成したビルドディレクトリを指定          |

    実際にやっていること
    build ディレクトリ内の build.ninja を読み込み
    g++ で src/main.cpp をコンパイル
    hello という実行ファイルを生成

5. Conanの導入「Docker + CMake + Conan開発環境」
    - conanfile.txtを作成
    - Conan プロファイルの初期化を行う為に以下のコマンドをコンテナ内で実行　
        ``` 
        conan profile detect --force
        ```
    <Production版　Debug情報が少なくファイルサイズが小さい>
    - 依存パッケージのインストール
        ```
        conan install . --output-folder=/work/build/conan --build=missing -s build_type=Release
        ```
    - CMakeLists.txt を変更
    - main.cpp を変更（ここではfmtを使うように変更）
    - ビルドを行う。これももちろんコンテナ内で
    ```
    まずはビルドの準備（ビルドに必要な設定ファイルを出力）
    cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=build/conan/build/Release/generators/conan_toolchain.cmake

    ここでビルド
    cmake --build build
    
    実行
    ./build/hello

    ```
    <Debug版 Debug情報が多くファイルサイズが大きい>
    - 依存パッケージのインストール
        ```
        conan install . --output-folder=/work/build_debug/conan --build=missing -s build_type=Debug
        ```
    - CMakeLists.txt を変更
    - main.cpp を変更（ここではfmtを使うように変更）
    - ビルドを行う。これももちろんコンテナ内で
    ```
    cmake -S . -B build_debug -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=build_debug/conan/build/Debug/generators/conan_toolchain.cmake

    cmake --build build
    
    ./build/hello

    ```

