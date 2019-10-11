/*********************************************************************/
/*   PROGRAM-------- QPCARLCCL                                       */
/*   DATE WRITTEN---  6/06/02                                        */
/*   DESCRIPTION---- CALCULATE LATE CHARGES DAILY                    */
/*                                                                   */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FIRST) TYPE(*CHAR) LEN(1)

/*           CALL       PGM(KUBEPAK400/KUBEALLLBL)      */
/*           CALL       PGM(KUBEPAK400/EFDLIBLTST)      */

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')


NXT:         CALL       PGM(QPCARLCD)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             /* IF FIRST OF MONTH CLEAR MTD TOTAL. */
             QSYS/RTVDTAARA DTAARA(*LDA (7 1)) RTNVAR(&FIRST)
             IF         COND(&FIRST = 'Y') THEN(DO)
             CALL       PGM(QPKARLCC)
             ENDDO

 /* GOTO ADDED BY RP       */
             GOTO CMDLBL(MTH)

             CALL       PGM(QPKARLCD)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 /* ADDED BY RP       */
             CALL       PGM(QPKLCUPT)
             GOTO CMDLBL(END)



MTH:         CALL       PGM(QPKARLCM)
 /* ADDED BY RP       */
             CALL       PGM(QPKLCUPT)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))


/* DELETED BY RP       */
/*           GOTO       NXT                     */

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
