#include <windows.h>

DWORD ft_putchar(char c)
{
    HANDLE h;
    DWORD len;

    h = GetStdHandle(STD_OUTPUT_HANDLE);
    WriteConsoleA(h, &c, 1, &len, NULL);
    return (len);
}

DWORD ft_putstr(char *str)
{
    DWORD i;

    i = 0;
    while (str[i])
    {
        ft_putchar(str[i]);
        i++;
    }
    return (i);
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved)
{
    if (fdwReason == DLL_PROCESS_ATTACH)
    {
        MessageBoxA(0, "Injected!", "OK", 0);
    }
    return 1;
}