/*********************************************************************/
/*   PROGRAM-------- TRC100CL                                        */
/*   DATE WRITTEN---  8/28/01                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- BUILD TRUCK SCHEDULE                            */
/*   REVISIONS------                                                 */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

/*   UPDATE PRE-TRUCK SCHEDULE                                       */
             CALL       PGM(TRR100)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

/*   BUILD ACTUAL TRUCK SCHEDULE RECORDS                             */
             CALL       PGM(TRR110)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
