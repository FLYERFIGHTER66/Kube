/*********************************************************************/
/*   PROGRAM-------- PSC190CL                                        */
/*   DATE WRITTEN---  2/13/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- BUILD PLUG SHIPPING LOCATION FILE               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&COP) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&SUM) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CALL       PGM(NSC190)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(NSR190)

             CALL       PGM(NSR195) /* Build Control File */

 END:        ENDPGM
