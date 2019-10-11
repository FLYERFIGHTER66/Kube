/*********************************************************************/
/*   PROGRAM0------- CHP220CL                                        */
/*   DATE WRITTEN---  2/19/03                                        */
/*   PROGRAMMER----- C. BUCK                                         */
/*   DESCRIPTION---- PRINT WEEKLY SPRAY RUN REPORT                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             QSYS/OVRPRTF FILE(QPRINT98) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 98) LPI(6) CPI(12) +
                          ALIGN(*NO) OUTQ(P3) HOLD(*YES) +
                          FORMTYPE(*NAR)

             CALL       PGM(FCP220)

  END:       CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
