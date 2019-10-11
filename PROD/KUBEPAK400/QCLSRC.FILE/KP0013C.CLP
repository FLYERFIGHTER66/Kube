/*********************************************************************/
/* Program? -  KP0013C                                              */
/* Purpose? -  Enter Maintenance Purchase Order Receipts            */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*   Date  ? Programmer       ? Comment                          ?*/
/* 9/13/2003   Richard E. Piasecki Program created                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &PO# &RDATE &OUTQ)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PO#) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

             DLTF       FILE(QTEMP/KP0013WK)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(KP0013WK) FROMLIB(TGMSDATA) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF     FILE(KP0013WK) TOFILE(QTEMP/KP0013WK)
             OVRPRTF    FILE(KP0013P) PAGESIZE(66 80) OUTQ(&OUTQ) +
                        FORMTYPE(*NAR)

             CALL       PGM(KP0013R) PARM(&POYR &PO# &RDATE)

             DLTOVR     FILE(KP0013WK)
             DLTF       FILE(QTEMP/KP0013WK)
             MONMSG     MSGID(CPF2105)

             ENDPGM
