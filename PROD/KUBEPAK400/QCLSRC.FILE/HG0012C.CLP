/*********************************************************************/
/* Program? -  HG0012C                                              */
/* Purpose? -  Enter Inventory Purchase Order Detail                */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*   Date  ? Programmer       ? Comment                          ?*/
/* 4/26/2004   Richard E. Piasecki Program created                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &DGPO &MODE)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DGPO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)

             DLTF       FILE(QTEMP/HG0012WK)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(HG0012WK) FROMLIB(TGMSDATA) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF     FILE(HG0012WK) TOFILE(QTEMP/HG0012WK)

             CALL       PGM(HG0012R) PARM(&POYR &DGPO &MODE)

             DLTOVR     FILE(HG0012WK)
             DLTF       FILE(QTEMP/HG0012WK)
             MONMSG     MSGID(CPF2105)



             ENDPGM
