/*********************************************************************/
/*   PROGRAM-------- SLC001CL                                        */
/*   DATE WRITTEN--- 10/11/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- CHECK SOWLINE AND SET UP PRINTER                */
/*   REVISIONS------                                                 */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEV) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             RTVJOBA    JOB(&DEV)

             CHGDTAARA  DTAARA(*LDA (80 10)) VALUE(&DEV)

             CALL       PGM(SLC001)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
