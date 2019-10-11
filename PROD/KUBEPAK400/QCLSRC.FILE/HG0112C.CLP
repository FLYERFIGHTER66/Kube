/*********************************************************************/
/* Program? -  HG0112C                                              */
/* Purpose? -  Enter Hard Goods Return Order Detail                 */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*   Date  ? Programmer       ? Comment                          ?*/
/* 5/19/2004   Richard E. Piasecki Program created                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &DGPO &MODE)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DGPO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)

             DLTF       FILE(QTEMP/HG0112WK)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(HG0112WK) FROMLIB(TGMSDATA) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF     FILE(HG0112WK) TOFILE(QTEMP/HG0112WK)

             CALL       PGM(HG0112R) PARM(&POYR &DGPO &MODE)

             DLTOVR     FILE(HG0112WK)
             DLTF       FILE(QTEMP/HG0112WK)
             MONMSG     MSGID(CPF2105)

             ENDPGM
