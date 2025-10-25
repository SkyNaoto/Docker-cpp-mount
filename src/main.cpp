#include <spdlog/spdlog.h>

int main() {
    // std::cout << "Hello from Docker (mounted source)!" << std::endl;
    // fmt::print("Hello from Docker + Conan + fmt!\n");
    spdlog::info("Application started successfully.");
    spdlog::warn("This is a warning message.");
    spdlog::error("An error message (example)");
    return 0;
}
