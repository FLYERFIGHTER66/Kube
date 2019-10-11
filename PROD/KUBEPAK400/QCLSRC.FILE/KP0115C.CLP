/*********************************************************************/
/* Program? -  KP0115C                                              */
/* Purpose? -  Submit Return Order Print                            */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date    Programmer       ?Comment                            ?*/
/* 1/15/2004  Richard E. PiaseckiProgram created                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POYR &PO# &PRTF &OUTQ)

             DCL        VAR(&POYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PO#)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRTF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

             SBMJOB     CMD(CALL PGM(KPP115C) PARM(&POYR &PO# +
                          &PRTF &OUTQ)) JOB(PO_PRINT)

             ENDPGM
