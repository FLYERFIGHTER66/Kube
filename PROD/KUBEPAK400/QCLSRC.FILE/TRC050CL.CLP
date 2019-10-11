/*********************************************************************/
/*   PROGRAM-------- TRC050CL                                        */
/*   DATE WRITTEN---  3/05/01                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- BUILD TRUCK SCHEDULE    T                       */
/*   REVISIONS------                                                 */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CALL       PGM(TRC050)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(TRR050)

/*   COMBINE SAME CUSTOMER AND SHIP VIA                              */
      /*     CALL       PGM(TRR051)     */

 END:        ENDPGM
