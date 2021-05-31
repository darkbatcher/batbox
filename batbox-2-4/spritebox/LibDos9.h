#ifndef DOS9API_INCLUDED
#define DOS9API_INCLUDED

/** \file LibDos9.h
    \brief Dos9 API's header*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

#include <dirent.h>

#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/stat.h>

/* this code contains all the Dos9 API, this code
    Modifiying these source could cause crash and memory leaks.
    This code is provided as an open source software, you can modify, redistribute it and all of these components under the following condition:
        - distribute with this code the name of all those contributited to it before you
        - distribute under the same licenses conditions
        - any commercial use of this code is strictly forbiden */

/*< Copyright (c) Romain Garbi 2009-2013 */
#if defined WIN32

    #include <windows.h>
    #include <process.h>
    #define stat _stat

    #define DOS9_FILE_ARCHIVE FILE_ATTRIBUTE_ARCHIVE
    #define DOS9_FILE_COMPRESSED FILE_ATTRIBUTE_COMPRESSED
    #define DOS9_FILE_HIDDEN FILE_ATTRIBUTE_HIDDEN
    #define DOS9_FILE_OFFLINE FILE_ATTRIBUTE_OFFLINE
    #define DOS9_FILE_READONLY FILE_ATTRIBUTE_READONLY
    #define DOS9_FILE_SYSTEM FILE_ATTRIBUTE_SYSTEM
    #define DOS9_FILE_DIR FILE_ATTRIBUTE_DIRECTORY
    #include <io.h>

    #define pipe(a,b,c) _pipe(a,b,c)
    #define flushall() _flushall()
    #define dup(a) _dup(a)
    #define dup2(a,b) _dup2(a,b)
	#define write(a,b,c) _write(a,b,c)
	#define read(a,b,c) _read(a,b,c)
    #define O_WRONLY _O_WRONLY
    #define O_RDONLY _O_RDONLY
    #define O_TRUNC _O_TRUNC
    #define O_TEXT _O_TEXT

    #define S_IREAD _S_IREAD
    #define O_IWRITE _S_IWRITE
    #define Dos9_GetFileAttributes(lpcstr) GetFileAttributes(lpcstr)


    #define THREAD int

    #define Dos9_BeginThread _beginthread
    #define Dos9_EndThread _endthread
    #define Dos9_EndThreadEx(a) _endthreadex((unsigned int) a)
    #define Dos9_WaitForThread(a) WaitForSingleObject((HANDLE) a , -1)
    #define Dos9_GetThreadExitCode(a,b) GetExitCodeThread((HANDLE) a , (PDWORD) b)

#else

    #include <unistd.h>
	#include <pthread.h>
	#include <stdarg.h>

    #define pipe(a,b,c) pipe(a)
    #define flushall()
    #define stricmp(a,b) strcasecmp(a,b)
    #define strnicmp(a,b,c) strncasecmp(a,b,c)

    #define DOS9_FILE_DIR S_IFDIR
    #define DOS9_FILE_EXECUTE S_IXUSR
    #define DOS9_FILE_READ S_IRUSR
    #define DOS9_FILE_WRITE S_IRUSR
    #define DOS9_FILE_REGULAR S_IFREG
    #define DOS9_FILE_ARCHIVE 0
    #define DOS9_FILE_COMPRESSED 0
    #define DOS9_FILE_HIDDEN 0
    #define DOS9_FILE_OFFLINE 0
    #define DOS9_FILE_READONLY 0
    #define DOS9_FILE_SYSTEM 0

        /* definition of thread windows lib compatibility */
    #define THREAD pthread_t

    pthread_t Dos9_BeginThread(void(*lpFunction)(void*) , int iMemAmount, void* lpArgList);
    #define Dos9_EndThread() return 0
    #define Dos9_EndThreadEx(a) return a
    #define Dos9_WaitForThread(a)
    #define Dos9_GetThreadExitCode(a,b) pthread_join(a,(void**)b)

#endif


#define DOS9API

#define TRUE 1
#define FALSE 0

typedef struct STACK {
    int iFlag;
    void* ptrContent;
    struct STACK* lpcsPrevious;
} STACK,*LPSTACK;

typedef STACK CALLSTACK,*LPCALLSTACK;

DOS9API     LPSTACK Dos9_PushStack(LPSTACK lpcsStack, void* ptrContent, int iFlag);
DOS9API     LPSTACK Dos9_PopStack(LPSTACK lpcsStack);
DOS9API     int Dos9_GetStack(LPSTACK lpcsStack, void** ptrContent);
DOS9API     int Dos9_ClearStack(LPSTACK lpcsStack);

#define Dos9_PushCallStack Dos9_PushStack
#define Dos9_PopCallStack Dos9_PopStack
#define Dos9_GetCallStack Dos9_GetStack
#define Dos9_GetClearCallStack Dos9_ClearStack

#ifndef DEFAULT_ESTR
	#define DEFAULT_ESTR 32
#endif

#define DOS9_NEWLINE_WINDOWS 0
#define DOS9_NEWLINE_LINUX 1
#define DOS9_NEWLINE_MAC 2

#define Dos9_SetNewLineMode(type) _Dos9_NewLine=type

extern int _Dos9_NewLine;

#define DOS9_

typedef struct ESTR {
    char* ptrString;
    size_t iLenght;
} ESTR, *LPESTR;

#define EsToChar(a) a->ptrString
#define Dos9_EsToChar(a) a->ptrString

/* function used for string allcation */
DOS9API ESTR*           Dos9_EsInit(void);
DOS9API int             Dos9_EsFree(ESTR* ptrESTR);

/* function that interact with files */
DOS9API int             Dos9_EsGet(ESTR* ptrESTR, FILE* ptrFile);

/* function used for C-String/E-String operation */
DOS9API int             Dos9_EsCpy(ESTR* ptrESTR, const char* ptrChaine);
DOS9API int             Dos9_EsCpyN(ESTR* ptrESTR, const char* ptrChaine, size_t iSize);

DOS9API int             Dos9_EsCat(ESTR* ptrESTR, const char* ptrChaine);
DOS9API int             Dos9_EsCatN(ESTR* ptrESTR, const char* ptrChaine, size_t iSize);

DOS9API int             Dos9_EsReplace(ESTR* ptrESTR, const char* ptrPattern, const char* ptrReplace);
DOS9API int             Dos9_EsReplaceN(ESTR* ptrESTR, const char* ptrPattern, const char* ptrReplace, int iN);

DOS9API int             Dos9_EsCpyE(ESTR* ptrDest, const ESTR* ptrSource);
DOS9API int             Dos9_EsCatE(ESTR* ptrDest, const ESTR* ptrSource);

        size_t          _Dos9_EsTotalLen2(const char* ptrChaine, const char* ptrString);
        size_t          _Dos9_EsTotalLen(const char* ptrChaine);
        size_t          _Dos9_EsTotalLen3(const char* ptrChaine, size_t iSize);
        size_t          _Dos9_EsTotalLen4(const size_t iSize);


typedef int COMMANDFLAG;

typedef struct COMMANDLIST
{
    void* lpCommandProc;
    int iLenght;
    char* ptrCommandName;
    COMMANDFLAG cfFlag;
    struct COMMANDLIST* lpclLeftRoot;
    struct COMMANDLIST* lpclRightRoot;
} COMMANDLIST, *LPCOMMANDLIST;

typedef struct COMMANDINFO {
    char* ptrCommandName;
    void* lpCommandProc;
    COMMANDFLAG cfFlag;
} COMMANDINFO,*LPCOMMANDINFO;

DOS9API LPCOMMANDLIST   Dos9_MapCommandInfo(LPCOMMANDINFO lpciCommandInfo, int i);
DOS9API int             Dos9_AddCommandDynamic(LPCOMMANDINFO lpciCommandInfo, LPCOMMANDLIST* lpclListEntry);
DOS9API int             Dos9_FreeCommandList(LPCOMMANDLIST lpclList);
DOS9API COMMANDFLAG     Dos9_GetCommandProc(char* lpCommandLine, LPCOMMANDLIST lpclCommandList,void** lpcpCommandProcedure);
int                     _Dos9_FillCommandList(LPCOMMANDLIST lpclList, LPCOMMANDINFO lpciCommandInfo);
int                     _Dos9_PutSeed(LPCOMMANDINFO lpciCommandInfo, int iSegBottom, int iSegTop, LPCOMMANDLIST* lpclList);
int                     _Dos9_Sort(const void* ptrS, const void* ptrD);

/* *******************************************************************************
   *                            Console Functions                                *
   *******************************************************************************/

typedef int COLOR;

#define DOS9_CURSOR_SHOW 1
#define DOS9_CURSOR_HIDE 1

#if defined WIN32
    #define DOS9_FOREGROUND_RED FOREGROUND_RED
    #define DOS9_FOREGROUND_BLUE FOREGROUND_BLUE
    #define DOS9_FOREGROUND_GREEN FOREGROUND_GREEN
    #define DOS9_BACKGROUND_GREEN BACKGROUND_GREEN
    #define DOS9_BACKGROUND_BLUE BACKGROUND_BLUE
    #define DOS9_BACKGROUND_RED BACKGROUND_RED

    #define DOS9_BACKGROUND_INT BACKGROUND_INTENSITY
    #define DOS9_FOREGROUND_INT FOREGROUND_INTENSITY

    #define DOS9_BACKGROUND_DEFAULT 0
    #define DOS9_FOREGROUND_DEFAULT DOS9_FOREGROUND_GREEN | DOS9_FOREGROUND_RED | DOS9_FOREGROUND_BLUE

    #define DOS9_GET_FOREGROUND(a) (a & 0x0F)
    #define DOS9_GET_BACKGROUND(a) (a & 0xF0)
    #define DOS9_GET_BACKGROUND_(a) ((a & 0xF0)>>4)


    typedef COORD CONSOLECOORD;

#else

    typedef struct CONSOLECOORD {
        short X;
        short Y;
    } CONSOLECOORD, *LPCONSOLECOORD;
    #define DOS9_FOREGROUND_RED 0x01
    #define DOS9_FOREGROUND_BLUE 0x04
    #define DOS9_FOREGROUND_GREEN 0x02
    #define DOS9_BACKGROUND_GREEN 0x20
    #define DOS9_BACKGROUND_BLUE 0x40
    #define DOS9_BACKGROUND_RED 0x10

    #define DOS9_BACKGROUND_INT 0
    #define DOS9_FOREGROUND_INT 0x08

    #define DOS9_BACKGROUND_DEFAULT 0x0100
    #define DOS9_FOREGROUND_DEFAULT 0x0200

    #define DOS9_GET_FOREGROUND(a) (a & 0x20F)
    #define DOS9_GET_FOREGROUND_(a) (a & 0x07)
    #define DOS9_GET_BACKGROUND(a) (a & 0x1F0)
    #define DOS9_GET_BACKGROUND_(a) ((a & 0xF0)>>4)


#endif

#define DOS9_BACKGROUND_IBLUE DOS9_BACKGROUND_BLUE | DOS9_BACKGROUND_INT
#define DOS9_BACKGROUND_IRED DOS9_BACKGROUND_RED | DOS9_BACKGROUND_INT
#define DOS9_BACKGROUND_IGREEN DOS9_BACKGROUND_GREEN | DOS9_BACKGROUND_INT

#define DOS9_BACKGROUND_YELLOW DOS9_BACKGROUND_RED | DOS9_BACKGROUND_GREEN
#define DOS9_BACKGROUND_CYAN DOS9_BACKGROUND_BLUE | DOS9_BACKGROUND_GREEN
#define DOS9_BACKGROUND_MAGENTA DOS9_BACKGROUND_BLUE | DOS9_BACKGROUND_RED
#define DOS9_BACKGROUND_WHITE DOS9_BACKGROUND_BLUE | DOS9_BACKGROUND_RED | DOS9_BACKGROUND_GREEN
#define DOS9_BACKGROUND_BLACK 0

#define DOS9_BACKGROUND_IYELLOW DOS9_BACKGROUND_RED | DOS9_BACKGROUND_GREEN | DOS9_BACKGROUND_INT
#define DOS9_BACKGROUND_ICYAN DOS9_BACKGROUND_BLUE | DOS9_BACKGROUND_GREEN | DOS9_BACKGROUND_INT
#define DOS9_BACKGROUND_IMAGENTA DOS9_BACKGROUND_BLUE | DOS9_BACKGROUND_RED | DOS9_BACKGROUND_INT
#define DOS9_BACKGROUND_IWHITE DOS9_BACKGROUND_BLUE | DOS9_BACKGROUND_RED | DOS9_BACKGROUND_GREEN | DOS9_BACKGROUND_INT
#define DOS9_BACKGROUND_IBLACK DOS9_BACKGROUND_INT

#define DOS9_FOREGROUND_YELLOW DOS9_FOREGROUND_RED | DOS9_FOREGROUND_GREEN
#define DOS9_FOREGROUND_CYAN DOS9_FOREGROUND_BLUE | DOS9_FOREGROUND_GREEN
#define DOS9_FOREGROUND_MAGENTA DOS9_FOREGROUND_BLUE | DOS9_FOREGROUND_RED
#define DOS9_FOREGROUND_WHITE DOS9_FOREGROUND_BLUE | DOS9_FOREGROUND_RED | DOS9_FOREGROUND_GREEN
#define DOS9_FOREGROUND_BLACK 0

#define DOS9_FOREGROUND_IBLUE DOS9_FOREGROUND_BLUE | DOS9_FOREGROUND_INT
#define DOS9_FOREGROUND_IRED DOS9_FOREGROUND_RED | DOS9_FOREGROUND_INT
#define DOS9_FOREGROUND_IGREEN DOS9_FOREGROUND_GREEN | DOS9_FOREGROUND_INT

#define DOS9_FOREGROUND_IYELLOW DOS9_FOREGROUND_RED | DOS9_FOREGROUND_GREEN | DOS9_FOREGROUND_INT
#define DOS9_FOREGROUND_ICYAN DOS9_FOREGROUND_BLUE | DOS9_FOREGROUND_GREEN | DOS9_FOREGROUND_INT
#define DOS9_FOREGROUND_IMAGENTA DOS9_FOREGROUND_BLUE | DOS9_FOREGROUND_RED | DOS9_FOREGROUND_INT
#define DOS9_FOREGROUND_IWHITE DOS9_FOREGROUND_BLUE | DOS9_FOREGROUND_RED | DOS9_FOREGROUND_GREEN | DOS9_FOREGROUND_INT
#define DOS9_FOREGROUND_IBLACK DOS9_FOREGROUND_INT

#define DOS9_COLOR_DEFAULT DOS9_BACKGROUND_DEFAULT | DOS9_FOREGROUND_DEFAULT

DOS9API void Dos9_ClearConsoleScreen(void); /* clears the console screen */
DOS9API void Dos9_SetConsoleColor(COLOR iColor); /* changes the console color */
                                                 /* seems no to be possible on linux */
DOS9API void Dos9_SetConsoleTextColor(COLOR iColor); /* changes the color of console text */
DOS9API void Dos9_SetConsoleCursorPosition(CONSOLECOORD iCoord); /* set the console cursor position */
DOS9API CONSOLECOORD Dos9_GetConsoleCursorPosition(void); /* retrieve console's cursor postion */
DOS9API void Dos9_SetConsoleCursorState(int bVisible, int iSize); /* set the cusor state (whether hidden or visible ) */
DOS9API void Dos9_SetConsoleTitle(char* lpTitle); /* change the console title */

/* *******************************************************************************
   *                         File searching functions                            *
   ******************************************************************************* */

#define Dos9_GetAccessTime(lpList) lpList->stFileStats.st_atime
#define Dos9_GetCreateTime(lpList) lpList->stFileStats.st_ctime
#define Dos9_GetModifTime(lpList) lpList->stFileStats.st_mtime
#define Dos9_GetFileSize(lpList) lpList->stFileStats.st_size
#define Dos9_GetFileMode(lpList) lpList->stFileStats.st_mode

#define DOS9_SEARCH_DEFAULT 0x00
#define DOS9_SEARCH_RECURSIVE 0x01
#define DOS9_SEARCH_GET_FIRST_MATCH 0x02
#define DOS9_SEARCH_NO_STAT 0x04

typedef struct {
    char bStat;
    int iInput;
} FILEPARAMETER,*LPFILEPARAMETER;

typedef struct FILELIST {
    char  lpFileName[FILENAME_MAX];
    struct stat stFileStats;
    struct FILELIST* lpflNext;
} FILELIST,*LPFILELIST;

DOS9API int         Dos9_RegExpMatch(char* lpRegExp, char* lpMatch);
DOS9API int         Dos9_RegExpCaseMatch(char* lpRegExp, char* lpMatch);
DOS9API LPFILELIST  Dos9_GetMatchFileList(char* lpPathMatch, int iFlag);
DOS9API THREAD      Dos9_FreeFileList(LPFILELIST lpflFileList);
DOS9API int         Dos9_FormatFileSize (char* lpBuf, int iLenght, unsigned int iSize);

int                 _Dos9_GetMatchPart(char* lpRegExp, char* lpBuffer, int iLength, int iLvl);
int                 _Dos9_GetMatchDepth(char* lpRegExp);
int                 _Dos9_MakePath(char* lpPathBase, char* lpPathEnd, char* lpBuffer, int iLength);
int                 _Dos9_GetMatchInfo(char* lpRegExp, char* lpBuffer, int iLenght, int* lpDepth, int* lpBaseLvl);
char*               _Dos9_GetFileName(char* lpPath);
char*               _Dos9_SeekPatterns(char* lpSearch, char* lpPattern);
int                 _Dos9_FreeFileList(LPFILELIST lpflFileList);
LPFILELIST          _Dos9_WaitForFileList(LPFILEPARAMETER lpParam);
LPFILELIST          _Dos9_SeekFiles(char* lpDir, char* lpRegExp, int iLvl, int iMaxLvl, int* iThreadNb, int iOutDescriptor, int iSearchFile);
LPFILELIST          _Dos9_SeekFilesRecursive(char* lpDir, char* lpRegExp, int* iThreadNb, int iOutDescriptor);


/* declaration for attributes commands */

#define DOS9_CMD_ATTR_READONLY 0x01
#define DOS9_CMD_ATTR_READONLY_N 0x02
#define DOS9_CMD_ATTR_VOID 0x04
#define DOS9_CMD_ATTR_VOID_N 0x08
#define DOS9_CMD_ATTR_HIDEN 0x10
#define DOS9_CMD_ATTR_HIDEN_N 0x20
#define DOS9_CMD_ATTR_SYSTEM 0x40
#define DOS9_CMD_ATTR_SYSTEM_N 0x80
#define DOS9_CMD_ATTR_ARCHIVE 0x100
#define DOS9_CMD_ATTR_ARCHIVE_N 0x200
#define DOS9_CMD_ATTR_DIR 0x400
#define DOS9_CMD_ATTR_DIR_N 0x800
#define DOS9_CMD_ATTR_ALL 0x000


short Dos9_MakeFileAttributes(const char* lpToken);
int Dos9_CheckFileAttributes(short wAttr, const FILELIST* lpflList);

/* encoding declaration */

extern int _Dos9_TextMode;

#define DOS9_BYTE_ENCODING 0
#define DOS9_UTF8_ENCODING 1

#define Dos9_SetEncoding(encoding) _Dos9_TextMode=encoding

char* Dos9_GetNextChar(char* lpContent);
char* _Dos9_IsFollowingByte(char* lpChar);

/* end of dos9 api declaration */
#endif
