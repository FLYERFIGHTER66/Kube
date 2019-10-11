/*********************************************************************/
/*   PROGRAM-------- BIR237CL                                        */
/*   DATE WRITTEN--- 11/06/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- FUTURE ORDER RELEASE                            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(8)
             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE('N')
             CHGDTAARA  DTAARA(*LDA (50 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (89 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (134 13)) VALUE('0000000000000')

             OVRPRTF    FILE(SCR420P) HOLD(*YES)
             CALL       PGM(BIR237)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))

/* AUTO PRINT SUMMARY PICK TICKET */

             SBMJOB     CMD(CALL PGM(BIR237CLJQ))

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
