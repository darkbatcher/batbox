#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(int argc, char *argv[])
{
    FILE* pFile;

    char lpLine[81];
    char* lpFileName;
    char* lpToken;
    unsigned char cChar;

    int iX=0, iY=0, iRaw=0, iDisp=0;

    if (argc<1) {
        fprintf(stderr, "spritebox :: ligne de commande incorrecte.");
        return -1;
    }

    lpFileName=argv[1];

    if (lpFileName) {

        if ( !(pFile=fopen(lpFileName, "r")) ) {
            perror("spritebox :: impossible d'ouvrir le fichier");

            return -1;
        }


    } else {
        pFile=stdin;
    }

    printf("batbox");

    while (fgets(lpLine, 81, pFile))
    {
        if ( (lpToken=strchr(lpLine, '\n')) ) {
            lpToken='\0';
        }

        iX=0;
        iRaw=0;
        iDisp=0;
        lpToken=lpLine;


        while (*lpToken) {

            if (*lpToken!= ' '  && *lpToken!=10) {

                if (!iRaw) {
                    if (iDisp){
                        printf("\"");
                    }
                    iDisp=0;
                    printf(" /g %d %d", iX, iY);
                }

                cChar=*lpToken;
                if ((cChar & 0x80) || cChar=='"') {
                    if (iDisp){
                        printf("\"");
                    }
                    printf(" /a %d", (int)cChar);
                    iDisp=0;

                } else {
                    if (!iDisp) {
                        iDisp=1;
                        printf(" /d \"");
                    }
                    printf("%c", cChar);
                }

                iRaw=1;

            } else {

                if (iDisp && iRaw && *lpToken==' ') {
                    printf(" ");
                } else {
                    iRaw=0;
                }
            }

            iX++;
            lpToken++;
        }

        if (iDisp) {
            printf("\"");
        }

        iY++;
    }


    if (pFile!=stdin) fclose (pFile);


}
