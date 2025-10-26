cmake_minimum_required(VERSION 3.16)
Project(HelloDockerCXX LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Conan dependencies for cross-build
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/conan/build/Release/generators")

# Conanが生成する設定ファイルを読み込み
find_package(fmt REQUIRED)
find_package(spdlog REQUIRED)

add_executable(hello src/main.cpp)
target_link_libraries(hello PRIVATE fmt::fmt spdlog::spdlog)