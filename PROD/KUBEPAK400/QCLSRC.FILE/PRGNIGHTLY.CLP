             PGM
             MONMSG     MSGID(CPF2981)

             OVRPRTF    FILE(QPDSPSTS) OUTQ(BILLB/BILLB) FORMTYPE(*NAR)
             DSPSYSSTS  OUTPUT(*PRINT) ASTLVL(*INTERMED)

             CALL       PGM(PRG020) /* Purge FPPO  File */
             CALL       PGM(PRG030) /* Purge FTRAY File */
     /*      CALL       PGM(PRG050) /. Purge FDLOT File ./      */
     /*      CALL       PGM(PRG051) /. Purge FDLOTRD File ./    */
             CALL       PGM(PRG060) /* Purge FINMAN & FINMAND Files */
             CALL       PGM(PRG090) /* Purge FIORDRPART */
             CALL       PGM(PRG100) /* Purge FPUTORD    */
             CALL       PGM(PRG110) /* Purge FTRAYFIXED */
             CALL       PGM(PRG120) /* Purge MOVE SYSTEM*/

             CALL       PGM(PRG_RGZPFM) /* Reorganize Files w/ +
                          deleted records */

             DSPSYSSTS  OUTPUT(*PRINT) ASTLVL(*INTERMED)
             DLTOVR     FILE(QPDSPSTS)

             ENDPGM
