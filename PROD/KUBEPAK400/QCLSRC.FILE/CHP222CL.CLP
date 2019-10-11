/*********************************************************************/
/*   PROGRAM0------- CHP222CL                                        */
/*   DATE WRITTEN---  2/19/03                                        */
/*   PROGRAMMER----- C. BUCK                                         */
/*   DESCRIPTION---- PRINT WEEKLY SPRAY RUN REPORT BY SPRAYER        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             QSYS/OVRPRTF FILE(QPRINT) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) OUTQ(R4) HOLD(*YES) +
                          FORMTYPE(*NAR) SAVE(*YES)

             CALL       PGM(CHP222)

  END:       CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
