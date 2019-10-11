/*********************************************************************/
/* Program? -  KPP015C                                              */
/* Purpose? -  Submit Inventory Purchase Order Print                */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date    Programmer       ?Comment                            ?*/
/* 9/08/2003  Richard E. PiaseckiProgram created                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &PO# &PRTF &OUTQ)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PO#)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRTF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

             OVRPRTF    FILE(KP0015P) PAGESIZE(66 80) OUTQ(&OUTQ)  +
                        FORMTYPE(*NAR)
             CALL PGM(KP0015R) PARM(&POYR &PO# +
                          &PRTF)

             CALL       PGM(KP0016R)

             ENDPGM
