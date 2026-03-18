#include <windows.h>
#include <stdio.h>

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

int main(void)
{
    printf("PID: %lu\n", GetCurrentProcessId());
    ft_putstr("essayez de m'injecter une dll\n");

    while (1)
        Sleep(1000);

    return (0);
}