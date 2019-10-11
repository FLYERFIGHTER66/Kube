/*********************************************************************/
/*   PROGRAM-------- MOVE1CL                                        */
/*   DATE WRITTEN--- 02/24/03                                        */
/*   PROGRAMMER----- C.BUCK                                          */
/*   DESCRIPTION---- SCANNER INPUT FOR MOVE TRAYS SIGNON             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CALL       PGM(KUBEPAK400/KUBEALLLBL) /* get library +
                          list */

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')


             QSYS/OVRPRTF FILE(QPRINT) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(88 120) LPI(8) CPI(15) +
                          ALIGN(*NO) OUTQ(XERPRT01) FORMTYPE(*NAR) COPIES(1)

             CALL       PGM(MOVR130)

             ENDPGM
