/*********************************************************************/
/*   PROGRAM0------- CHP221CL                                        */
/*   DATE WRITTEN---  4/20/09                                        */
/*   PROGRAMMER----- W. BEHR                                         */
/*   DESCRIPTION---- PRINT WEEKLY SPRAY RUN REPORT BY LOCATION       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             QSYS/OVRPRTF FILE(QPRINT98) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 98) LPI(6) CPI(12) +
                          ALIGN(*NO) OUTQ(Q6) HOLD(*YES) +
                          FORMTYPE(*NAR)

             CALL       PGM(FCP221)

  END:       CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
