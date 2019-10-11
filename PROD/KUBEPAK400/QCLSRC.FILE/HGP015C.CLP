/*********************************************************************/
/* Program? -  HGP015C                                              */
/* Purpose? -  Submit Inventory Purchase Order Print                */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date    Programmer       ?Comment                            ?*/
/* 4/29/2004  Richard E. PiaseckiProgram created                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &PO# &PRTF &OUTQ)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PO#)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRTF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

             OVRPRTF    FILE(HG0015P) PAGESIZE(66 80) OUTQ(&OUTQ)  +
                        FORMTYPE(*NAR)
             CALL PGM(HG0015R) PARM(&POYR &PO# +
                          &PRTF)

             CALL       PGM(HG0016R)


             ENDPGM
