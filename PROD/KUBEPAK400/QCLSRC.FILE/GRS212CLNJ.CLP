/*********************************************************************/
/*   PROGRAM-------- GRS212CL                                        */
/*   DATE WRITTEN--- 12/21/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRINT SEASON SOW/SHIP REPORT                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*   01/01/03   CHANGED REPORT TO PRINT ON PRINTER P9 INSTEAD        */
/*              OF Q1 (GREENBAR)    C.BUCK                           */
/*   04/27/04   CHANGED REPORT TO PRINT WHERE USER REQUESTED         */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&SORR) TYPE(*CHAR) LEN(1)
 REPEAT:
             CALL       PGM(GRS212P)
             QSYS/RTVDTAARA DTAARA(*LDA (1 1)) RTNVAR(&EOJ)
             QSYS/RTVDTAARA DTAARA(*LDA (17 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (40 1)) RTNVAR(&SORR)

             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             IF         COND(&SORR = 'R') THEN(GOTO CMDLBL(SHIP))

             CALL       PGM(GRS212SWCL) PARM(&PRT)
             IF         COND(&SORR = 'B') THEN(GOTO CMDLBL(SHIP))
             GOTO       CMDLBL(REPEAT)

 SHIP:
             CALL       PGM(GRS212SHCL) PARM(&PRT)
             GOTO       CMDLBL(REPEAT)
 END:        ENDPGM
