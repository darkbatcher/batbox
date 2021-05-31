#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "LibDos9.h"

char* SpriteBox_MakeLineOutput(char* lpLine, int iY, int iOpaque)
{

    int iRaw=0; /* 0 if the last command has been ``/a''
                   1 if the last command is a part of ``/d'' */

    int iX=0;

    unsigned char* lpToken;
    int iTotal, i;

    int iChangedCoords=1;

    while (*lpLine) {



        if ((*lpLine & 0x80 ) || *lpLine=='"') {

            /* this is used to determine wether the current character
               is non ASCII-Compatible, regardless of the encoding
               either UTF-8 or byte based */

            if (iChangedCoords) {

                printf(" /g %d %d", iX, iY);
                iChangedCoords=0;

            }

            if (iRaw) {

                /* if we started a raw line, then we close the text */

                printf("\"");
                iRaw=0;

            }

            if (_Dos9_TextMode==DOS9_BYTE_ENCODING) {

                /* the encoding is BYTE based */

                printf(" /a 0x%X", *lpLine);

            } else {

                /* the encoding is UTF-8 */

                lpToken=lpLine;
                iTotal=(int)*lpToken;

                i=8;

                lpToken++;

                /* we loop until the sequence ends */

                while (_Dos9_IsFollowingByte(lpToken)) {

                    iTotal=iTotal | ( ((int)*lpToken) << i);

                    i+=8;

                    lpToken++;
                }

                printf(" /a 0x%X", iTotal);

            }

        } else if (*lpLine==' ' && !iOpaque) {

            /* if we found a `` '' and if the background is
               not opaque */

            if (iRaw) {

                /* if a raw line has be coming */
                printf("\"");
                iRaw=0;

            }

            iChangedCoords=1; /* then the coords have already been changed */

        } else {

            if (iChangedCoords) {

                printf(" /g %d %d", iX, iY);
                iChangedCoords=0;

            }

            if (!iRaw) {

                /* if a raw is not printed, the  we write a new raw */

                printf(" /d \"");
                iRaw=1;

            }

            printf("%c", *lpLine);

        }


        lpLine=Dos9_GetNextChar(lpLine);
        iX++; /* we have obviously written a character */

    }

    if (iRaw) {

        printf("\"");

    }

    return 0;

}



int main(int argc, char *argv[])
{
    FILE* pFile;

    ESTR* lpLine=Dos9_EsInit();

    char* lpFileName;
    char* lpToken;

    int i=1, iNotEof=1;
    int iY=0;

    int iOpaque=0;

    Dos9_SetNewLineMode(DOS9_NEWLINE_LINUX); /* set line mode to LINUX
                                                ie sets Dos9 loader to
                                                linux mode
                                              */

    if (argc<1) {
        fprintf(stderr, "spritebox :: ligne de commande incorrecte.");
        return -1;
    }

    while (argv[i]) {

        if (!stricmp("/O", argv[i])) {

            iOpaque=1;

        } if (!strnicmp("/E", argv[i], 2)) {

            argv[i]+=2;

            if (*argv[i]==':') argv[i]++;

            if (!stricmp("UTF-8", argv[i])) {

               Dos9_SetEncoding(DOS9_UTF8_ENCODING);

            }

        } else {

            lpFileName=argv[i];
        }

        i++;
    }

    if (lpFileName) {

        if ( !(pFile=fopen(lpFileName, "r")) ) {

            perror("spritebox :: impossible d'ouvrir le fichier");
            return -1;

        }


    } else {
        pFile=stdin;
    }

    printf("BATBOX"); /* obviously, any BatBox command lines starts
                          with ``BATBOX'' */

    SetConsoleOutputCP(CP_UTF8);

    while (iNotEof)
    {

        iNotEof=!Dos9_EsGet(lpLine, pFile);

        /* we make output */

        if (lpToken=strchr(Dos9_EsToChar(lpLine), '\n')) {

            *lpToken='\0'; /* we suppress the command files */

        }

        SpriteBox_MakeLineOutput(Dos9_EsToChar(lpLine), iY, iOpaque);

        iY++;

    }


    if (pFile!=stdin) fclose (pFile);

    return 0;

}
