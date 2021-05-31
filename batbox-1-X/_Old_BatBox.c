#include <stdio.h>
#include <stdlib.h>
#include <windows.h>


#define STRING_LENGHT 256



union type1 {
        char chaine[STRING_LENGHT];
        INPUT_RECORD input;
        int k;
};
union type2 {
        DWORD isInput;
        COORD p;
};

char** ptrParam;

int GetNextParam(void)
{
    ptrParam++;
    if ((*ptrParam)==NULL) exit(0);
    return 1;
}

int main(int argc, char *argv[])
{
    ptrParam=argv;
    HANDLE conOut, conIn;
    union type1 union1;
    union type2 union2;
    conOut=GetStdHandle(STD_OUTPUT_HANDLE);
    conIn=GetStdHandle(STD_INPUT_HANDLE);
    SetConsoleMode(conIn, ENABLE_WINDOW_INPUT | ENABLE_MOUSE_INPUT);
    printf("conIn=%d conOut=%d", conIn, conOut);
    while (GetNextParam())
    {
        if (**ptrParam!='/') return 0;
        switch (toupper(*(*ptrParam+1)))
        {
            case 'G':
            GetNextParam();
            union2.p.X=atol(*ptrParam);
            GetNextParam();
            union2.p.Y=atol(*ptrParam);
            SetConsoleCursorPosition(conOut, union2.p);
            break;

            case 'C':
                GetNextParam();
                SetConsoleTextAttribute(conOut, strtol(*ptrParam,NULL,0));
            break;

            case 'D':
                GetNextParam();
                printf("%s", *ptrParam);
                break;

            case 'A':
                GetNextParam();
                printf("%c", atol(*ptrParam));
		break;

            case 'V':
                GetNextParam();
                GetEnvironmentVariable(*ptrParam, union1.chaine, STRING_LENGHT);
                printf("%s", union1.chaine);
                break;
            case 'W':
                GetNextParam();
                union1.k=clock()+atoi(*ptrParam);
                while (union1.k>clock());
                break;
            case 'K':
                union1.k=0;
                if (_kbhit() || !(int)strchr(*ptrParam, '_'))
                {
                    union1.k=getch();
                    if (union1.k==224) union1.k=255+getch();
                }
                return union1.k;
            case 'M':
                do
                {
                    ReadConsoleInput(conIn, &union1.input, 1, &union2.isInput);
                    if (union1.input.EventType==MOUSE_EVENT)
                    {
                        if (union1.input.Event.MouseEvent.dwEventFlags==2 || union1.input.Event.MouseEvent.dwEventFlags==0)
                        {
                            printf("%d:%d:%d ", union1.input.Event.MouseEvent.dwMousePosition.X, union1.input.Event.MouseEvent.dwMousePosition.Y, union1.input.Event.MouseEvent.dwButtonState+union1.input.Event.MouseEvent.dwEventFlags); /*merci microsoft pour les structures dans les struture :D */
                        } else union2.isInput=0;
                    }
                    else union2.isInput=0;
                } while (!union2.isInput);
            default:
                return 2;
        }
    }
}
