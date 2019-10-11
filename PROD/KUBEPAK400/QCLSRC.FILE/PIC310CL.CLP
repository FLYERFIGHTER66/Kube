/*********************************************************************/
/*   PROGRAM-------- PIC310CL                                        */
/*   DATE WRITTEN--- 05/31/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT POINSETTIA SPREAD SHEET                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CALL       PGM(PIC310)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/PIC310CLJQ))
                        GOTO END


 NOJ:        CALL       PGM(PIC310CLJQ)

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
