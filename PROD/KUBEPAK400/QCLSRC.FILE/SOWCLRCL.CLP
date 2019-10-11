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

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)

             ENDWTR     WTR(&PRT) OPTION(*IMMED)
             DLTSPLF    FILE(*SELECT) SELECT(*CURRENT &PRT SOWLABEL)

             /* START PRINTERS */
             IF         COND(&PRT = 'R1        ') THEN(DO)
 R1TRY:      STRPRTWTR  DEV(R1) FORMTYPE(SOWLABEL) ALIGN(*FILE)
 /*          MONMSG     MSGID(CPF3310) EXEC(GOTO CMDLBL(R1TRY))   */
             MONMSG     MSGID(CPF3310)

             ENDDO
             IF         COND(&PRT = 'R2        ') THEN(DO)
 R2TRY:      STRPRTWTR  DEV(R2) FORMTYPE(SOWLABEL) ALIGN(*FILE)
/*           MONMSG     MSGID(CPF3310) EXEC(GOTO CMDLBL(R2TRY))   */
             MONMSG     MSGID(CPF3310)

             ENDDO

 END:        ENDPGM
