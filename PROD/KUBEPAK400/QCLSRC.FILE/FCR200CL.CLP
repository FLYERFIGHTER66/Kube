/*********************************************************************/
/*   PROGRAM-------- FCR200CL                                        */
/*   DATE WRITTEN---  8/09/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- GROWTH RETARDANT WEEKLY REVIEW                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             CALL       PGM(FCR200)

 END:        CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
