/*********************************************************************/
/*   PROGRAM-------- TRC750CLJQ                                      */
/*   DATE WRITTEN---  3/08/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- RE-ORGANIZE TRUCK SCHEDULE FILES  JOBQ          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT2) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             QSYS/RTVDTAARA DTAARA(*LDA (90 10)) RTNVAR(&PRT2)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)


             CALL       PGM(TRR750)

/*   REORGANIZE HEADER FILE                                       */
             RGZPFM     FILE(FTRHDRH)
             MONMSG     MSGID(CPF2981)

/*   REORGANIZE DETAIL FILE                                       */
             RGZPFM     FILE(FTRSCHD)
             MONMSG     MSGID(CPF2981)

/*   REORGANIZE TRUCK ORDER FILE                                  */
             RGZPFM     FILE(FTRUCKO)
             MONMSG     MSGID(CPF2981)

 END:        ENDPGM
