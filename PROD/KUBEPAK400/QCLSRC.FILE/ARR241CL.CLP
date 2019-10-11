/*********************************************************************/
/*   PROGRAM-------- ARR241CL                                        */
/*   DATE WRITTEN--- 08/16/07                                        */
/*   PROGRAMMER----- W. BEHR                                         */
/*   DESCRIPTION---- A/R SUMMARY COMPANY INQUIRY (AUTO SUBMIT)       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR241')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Company A/R +
                          Summary Balance')

             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')
             OVRPRTF    FILE(ARR241P) DEV(P6) FORMTYPE(*NAR) +
                          COPIES(1) HOLD(*NO) SAVE(*NO) OVRSCOPE(*JOB)

             CALL       PGM(ARR241)
 END:        ENDPGM
