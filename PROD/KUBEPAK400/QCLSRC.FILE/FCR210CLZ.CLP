/*********************************************************************/
/*   PROGRAM-------- FCR210CL                                        */
/*   DATE WRITTEN---  1/14/03                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SPLIT JOB RUN FILE INTO RUN FILE                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             CALL       PGM(FCR210)

 END:        CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
