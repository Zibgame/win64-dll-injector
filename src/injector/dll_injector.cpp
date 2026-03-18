#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    // proc_name pid dll
    if (argc < 3 || argc > 3)
    {
        printf("Argument: pid dll");
        return (0);
    }
    DWORD pid;
    char *dll_path;
    HANDLE process;
    LPVOID remote; // LPVOID pointeur sur du vide sur windo
    HANDLE thread;

    pid = atoi(argv[1]);
    dll_path = argv[2];

    process = OpenProcess(PROCESS_ALL_ACCESS, 0, pid);
    if (!process)
    {
        printf("Error: Pid invalid\n");
        return (0);
    }

    remote = VirtualAllocEx(process, 0, strlen(dll_path) + 1, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);
    if (!remote)
    {
        printf("Error: Cant alloc in process\n");
        return (0);
    }

    if (!WriteProcessMemory(process, remote, dll_path, strlen(dll_path) + 1, NULL))
    {
        VirtualFreeEx(process, remote, 0, MEM_RELEASE);
        CloseHandle(process);
        printf("Error: Cant Write in the procces\n");
        return (1);
    }
    thread = CreateRemoteThread(process, NULL, 0, (LPTHREAD_START_ROUTINE)LoadLibraryA, remote, 0, NULL);
    if (!thread)
    {
        VirtualFreeEx(process, remote, 0, MEM_RELEASE);
        CloseHandle(process);
        return (1);
    }
    // attendre load de dll via LoadLibraryA executer avant de free
    WaitForSingleObject(thread, INFINITE);

    // free
    VirtualFreeEx(process, remote, 0, MEM_RELEASE);
    CloseHandle(thread);
    CloseHandle(process);
    printf("injection succes");
    return (0);
}