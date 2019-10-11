/*********************************************************************/
/* Program? -  HG0013C                                              */
/* Purpose? -  Enter Hard Goods Purchase Order Receipts             */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*   Date  ? Programmer       ? Comment                          ?*/
/* 4/28/2004   Richard E. Piasecki Program created                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &PO# &RDATE &OUTQ)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PO#) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

             DLTF       FILE(QTEMP/HG0013WK)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(HG0013WK) FROMLIB(TGMSDATA) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF     FILE(HG0013WK) TOFILE(QTEMP/HG0013WK)
             OVRPRTF    FILE(HG0013P) PAGESIZE(66 80) OUTQ(&OUTQ) +
                        FORMTYPE(*NAR)

             CALL       PGM(HG0013R) PARM(&POYR &PO# &RDATE)

             DLTOVR     FILE(HG0013WK)
             DLTF       FILE(QTEMP/HG0013WK)
             MONMSG     MSGID(CPF2105)

             ENDPGM
