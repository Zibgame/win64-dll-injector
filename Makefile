NAME = dll_injector.exe
DLL = bin/dll.dll
TARGET = bin/target.exe

CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++11 -Iincludes -Isrc/imgui -Isrc/imgui/backends

SRC = \
	src/main.cpp \
	src/injector/dll_injector.cpp \
	src/imgui/imgui.cpp \
	src/imgui/imgui_draw.cpp \
	src/imgui/imgui_tables.cpp \
	src/imgui/imgui_widgets.cpp \
	src/imgui/imgui_demo.cpp \
	src/imgui/backends/imgui_impl_win32.cpp \
	src/imgui/backends/imgui_impl_dx11.cpp

DLL_SRC = src/dll/dll.cpp
TARGET_SRC = src/target/main.cpp

OBJ = $(SRC:.cpp=.o)

LIBS = -ld3d11 -ldxgi -ld3dcompiler -lgdi32 -ldwmapi

# Detect Windows (disable colors if needed)
ifeq ($(OS),Windows_NT)
	GREEN=
	YELLOW=
	RED=
	CYAN=
	RESET=
else
	GREEN=\x1b[32m
	YELLOW=\x1b[33m
	RED=\x1b[31m
	CYAN=\x1b[36m
	RESET=\x1b[0m
endif

all: $(NAME) $(DLL) $(TARGET)

$(NAME): $(OBJ)
	@echo $(CYAN)[INFO] Killing running injector...$(RESET)
	-taskkill /F /IM dll_injector.exe >nul 2>&1
	@echo $(GREEN)[BUILD] Compiling injector...$(RESET)
	$(CXX) $(OBJ) -o $(NAME) $(LIBS)
	@echo $(GREEN)[OK] Injector built successfully$(RESET)

$(DLL): $(DLL_SRC)
	@echo $(CYAN)[INFO] Cleaning DLL locks...$(RESET)
	-taskkill /F /IM target.exe >nul 2>&1
	-del /Q $(DLL) >nul 2>&1
	@if not exist bin mkdir bin
	@echo $(GREEN)[BUILD] Compiling DLL...$(RESET)
	$(CXX) -shared -o $(DLL) $(DLL_SRC) -luser32
	@echo $(GREEN)[OK] DLL built successfully$(RESET)

$(TARGET): $(TARGET_SRC)
	@echo $(CYAN)[INFO] Building target process...$(RESET)
	@if not exist bin mkdir bin
	$(CXX) $(TARGET_SRC) -o $(TARGET)
	@echo $(GREEN)[OK] Target built successfully$(RESET)

%.o: %.cpp
	@echo $(YELLOW)[COMPILING] $<$(RESET)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	@echo $(RED)[CLEAN] Removing object files...$(RESET)
	-del /Q /S src\*.o >nul 2>&1
	-del /Q /S src\imgui\*.o >nul 2>&1
	-del /Q /S src\imgui\backends\*.o >nul 2>&1
	-del /Q /S src\injector\*.o >nul 2>&1

fclean: clean
	@echo $(RED)[FCLEAN] Removing binaries...$(RESET)
	-del /Q $(NAME) >nul 2>&1
	-del /Q /S bin\*.exe >nul 2>&1
	-del /Q /S bin\*.dll >nul 2>&1

re: fclean all