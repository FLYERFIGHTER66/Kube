/*********************************************************************/
/*   PROGRAM-------- APR291CL                                        */
/*   DATE WRITTEN--- 08/16/07                                        */
/*   PROGRAMMER----- W. BEHR                                         */
/*   DESCRIPTION---- SUMMARY COMPANY BALANCE (AUTO SUBMIT)           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR291')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Summary +
                          Company Balance ')

             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')
             OVRPRTF    FILE(APR291P) DEV(P6) FORMTYPE(*NAR) +
                          COPIES(1) HOLD(*NO) SAVE(*NO) OVRSCOPE(*JOB)

             CALL       PGM(APR291)
 END:        ENDPGM
