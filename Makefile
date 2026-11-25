# This Makefile only supports Linux. Fail early on macOS and Windows.
UNAME_S := $(shell uname -s 2>/dev/null)
ifneq ($(UNAME_S),Linux)
$(error This Makefile only supports Linux, detected: $(or $(UNAME_S),$(OS),unknown))
endif

SLN        := Skate Custom Server.sln
PROJ_DIR   := Skate Custom Server
CONFIG     := Release
OUT_DIR    := $(PROJ_DIR)/bin/$(CONFIG)/net8.0
SETTINGS   := $(OUT_DIR)/settings.json

.PHONY: build run logs clean

# Build the server and create settings.json next to the binary (kept if it already exists).
build:
	dotnet build "$(SLN)" -c $(CONFIG)
	@test -f "$(SETTINGS)" || printf '{"LocalHost":false,"LocalIPAddress":"127.0.0.1"}' > "$(SETTINGS)"

# Run the server from the output dir (it reads settings.json, wwwroot and writes logs.txt there).
# Port 80 needs privileges on Linux, see README.
run:
	cd "$(OUT_DIR)" && sudo dotnet "Skate Custom Server.dll"

# Stream logs.txt, creating it if missing (Ctrl+C to stop following, q to quit less).
logs:
	@touch "$(OUT_DIR)/logs.txt"
	less +F "$(OUT_DIR)/logs.txt"

# Remove build dirs.
clean:
	rm -rf "$(PROJ_DIR)/bin"
	rm -rf "$(PROJ_DIR)/obj"
