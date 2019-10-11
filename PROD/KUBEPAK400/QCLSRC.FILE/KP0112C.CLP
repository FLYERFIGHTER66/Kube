/*********************************************************************/
/* Program? -  KP0112C                                              */
/* Purpose? -  Enter Return Order Detail                            */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*   Date  ? Programmer       ? Comment                          ?*/
/* 1/15/2004   Richard E. Piasecki Program created                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &DGPO &MODE)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DGPO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)

             DLTF       FILE(QTEMP/KP0112WK)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(KP0112WK) FROMLIB(TGMSDATA) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF     FILE(KP0112WK) TOFILE(QTEMP/KP0112WK)

             CALL       PGM(KP0112R) PARM(&POYR &DGPO &MODE)

             DLTOVR     FILE(KP0112WK)
             DLTF       FILE(QTEMP/KP0112WK)
             MONMSG     MSGID(CPF2105)

             ENDPGM
