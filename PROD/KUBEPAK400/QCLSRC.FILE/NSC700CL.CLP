/*********************************************************************/
/*   PROGRAM-------- PSC700CL                                        */
/*   DATE WRITTEN---  2/14/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- DELETE WEEKS RECORDS FROM LOCATION FILE         */
/*   REVISIONS------                                                 */
/* THIS FILE IS REORGANIZED EVERY NIGHT.                             */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&COP) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&SUM) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CALL       PGM(NSC700)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))


             CALL       PGM(NSR700)
 END:        ENDPGM
