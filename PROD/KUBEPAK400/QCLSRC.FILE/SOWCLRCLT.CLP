/*********************************************************************/
/*   PROGRAM-------- SOW1CLRCL                                       */
/*   DATE WRITTEN--- 12/07/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- CLEAR SOWLINE OUTQ                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             CHGDTAARA  DTAARA(*LDA (100 10)) VALUE('Q1')
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)


/*  PRTNOK:     ENDWTR     WTR(&PRT) OPTION(*IMMED)               */
/*             MONMSG     MSGID(CPF3313) EXEC(GOTO CMDLBL(PRTOK)) */
/*           GOTO       CMDLBL(PRTNOK)                            */
/* PRTOK:                                                         */
             DLTSPLF    FILE(*SELECT) SELECT(*CURRENT &PRT)
/*             CLROUTQ    OUTQ(&PRT)                              */
/*             STRPRTWTR  DEV(&PRT)                               */
/*           STRPRTWTR  DEV(&PRT) FORMTYPE(SOWLABEL) ALIGN(*FILE) */
/*           MONMSG     MSGID(CPF3310) EXEC(CHGWTR WTR(R1) +      */
/*                        FORMTYPE(SOWLABEL))                     */

 END:        ENDPGM
