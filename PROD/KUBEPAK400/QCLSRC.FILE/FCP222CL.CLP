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

             QSYS/OVRPRTF FILE(QPRINT98) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 98) LPI(6) CPI(12) +
                          ALIGN(*NO) OUTQ(R4) HOLD(*YES) +
                          FORMTYPE(*NAR)

             CALL       PGM(FCP222)

  END:       CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
