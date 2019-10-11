/*********************************************************************/
/*   PROGRAM-------- PUC100CL                                        */
/*   DATE WRITTEN---  8/28/01                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- BUILD S-VIA SCHEDULE                            */
/*   REVISIONS------                                                 */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

/*   UPDATE PRE-S-VIA SCHEDULE                                       */
             CALL       PGM(PUR100)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

/*   BUILD ACTUAL S-VIA SCHEDULE RECORDS                             */
             CALL       PGM(PUR110)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
