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

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD reason, LPVOID lpvReserved)
{
    if(reason == DLL_PROCESS_ATTACH)
    {
        MessageBoxA(0, "DLL injected", "OK", 0);
        ft_putstr("dll is injected in you program\n");
    }
    return (true);
}