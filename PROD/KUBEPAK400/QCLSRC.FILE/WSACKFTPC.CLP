/*     ?Program       : WSACKFTPC                                       */
/*     ?Description   : Program to GET Urc Acknowledgement from Eeason  */
/*     ?                into IFS folder using FTP                       */
/*     ?Programmer    : S.Uthayadurga                                   */
/*     ?Date          : 11 APR 2019                                     */
/*     ?Revisions     :                                                 */
/*********************************************************************/
             PGM

             DCL        VAR(&INPUT)  TYPE(*CHAR) LEN(10) VALUE('WSURCEHFTP')
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(10) VALUE('WSURCEHLOG')
             DCL        VAR(&WKBROK) TYPE(*CHAR) LEN(10) VALUE('928')

             OVRDBF     FILE(INPUT)  TOFILE(QFTPSRC) MBR(&INPUT)
             OVRDBF     FILE(OUTPUT) TOFILE(QFTPSRC) MBR(&OUTPUT)

             CLRPFM     FILE(QFTPSRC) MBR(&OUTPUT)

             FTP        RMTSYS(SERVERNOTFOUND)

             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)

/*     ?Pass Broker ID based on the FTP program                      */
             CALL       PGM(WSURCACK02) PARM(&WKBROK)

             ENDPGM
