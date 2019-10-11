/*********************************************************************/
/*   PROGRAM-------- ARR240CL                                        */
/*   DATE WRITTEN--- 06/07/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- A/R SUMMARY COMPANY INQUIRY                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR240')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Company A/R +
                          Summary Balance')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARR240)
 END:        ENDPGM
