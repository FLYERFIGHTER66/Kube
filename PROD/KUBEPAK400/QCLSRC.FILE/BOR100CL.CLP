/*********************************************************************/
/*   PROGRAM-------- BOR100CL                                        */
/*   DATE WRITTEN--- 12/08/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- RELEASE BACK ORDERS                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE('N')
             CHGDTAARA  DTAARA(*LDA (50 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (89 6)) VALUE('000000')
 NXTO:
             CALL       PGM(BOR100)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))
/* AUTO PRINT PICK TICKET */
             SBMJOB     CMD(CALL PGM(BIR310CL)) JOBQ(QINTER)
             MONMSG     MSGID(CPF1241)
             GOTO       CMDLBL(NXTO)

 END:
/*           CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')     */
             ENDPGM
