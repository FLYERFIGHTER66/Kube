/*********************************************************************/
/*   PROGRAM-------- PUC050CL                                        */
/*   DATE WRITTEN---  3/05/01                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- BUILD S-VIA SCHEDULE    T                       */
/*   REVISIONS------                                                 */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CALL       PGM(PUC050)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(PUR050)

/*   COMBINE SAME CUSTOMER AND SHIP VIA                              */
             CALL       PGM(PUR051)

 END:        ENDPGM
