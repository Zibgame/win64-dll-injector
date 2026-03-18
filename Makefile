NAME_INJECTOR = bin\dll_injector.exe
NAME_TARGET = bin\main.exe
NAME_DLL = bin\dll.dll

SRC_INJECTOR = src\injector\dll_injector.cpp
SRC_TARGET = src\target\main.c
SRC_DLL = src\dll\dll.cpp

CC = cl

CFLAGS = /W3 /nologo

all: $(NAME_INJECTOR) $(NAME_TARGET) $(NAME_DLL)

$(NAME_INJECTOR):
	$(CC) $(CFLAGS) $(SRC_INJECTOR) /Fe:$(NAME_INJECTOR)

$(NAME_TARGET):
	$(CC) $(CFLAGS) $(SRC_TARGET) /Fe:$(NAME_TARGET)

$(NAME_DLL):
	$(CC) $(CFLAGS) /LD $(SRC_DLL) /Fe:$(NAME_DLL)

clean:
	del /Q *.obj 2>nul

fclean: clean
	del /Q bin\*.exe bin\*.dll 2>nul

re: fclean all

.PHONY: all clean fclean re