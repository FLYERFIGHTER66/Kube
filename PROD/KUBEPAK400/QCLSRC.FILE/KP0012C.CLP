/*********************************************************************/
/* Program? -  KP0012C                                              */
/* Purpose? -  Enter Inventory Purchase Order Detail                */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*   Date  ? Programmer       ? Comment                          ?*/
/* 9/13/2003   Richard E. Piasecki Program created                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &DGPO &MODE)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DGPO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)

             DLTF       FILE(QTEMP/KP0012WK)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(KP0012WK) FROMLIB(TGMSDATA) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF     FILE(KP0012WK) TOFILE(QTEMP/KP0012WK)

             CALL       PGM(KP0012R) PARM(&POYR &DGPO &MODE)

             DLTOVR     FILE(KP0012WK)
             DLTF       FILE(QTEMP/KP0012WK)
             MONMSG     MSGID(CPF2105)



             ENDPGM
