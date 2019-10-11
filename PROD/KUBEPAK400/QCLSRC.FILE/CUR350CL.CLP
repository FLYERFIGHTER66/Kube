/*********************************************************************/
/*   PROGRAM-------- CUR350CL                                        */
/*   DATE WRITTEN--- 10/26/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- UPDATE CUTTING NEEDS FOR 84 PRODUCTION CONFIRMED*/
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&VENDOR) TYPE(*DEC) LEN(6)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             CALL       PGM(CUR999) PARM(&VENDOR)
             IF         COND(&VENDOR = 0) THEN(DO)
             SNDPGMMSG  MSGID(CUT0001) MSGF(KPMSGF) MSGDTA(*NONE) +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO

             CALL       PGM(CUR350) PARM(&VENDOR)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

                        /* UPDATE FCUTLOT */
             CALL       PGM(CUR360) PARM(&VENDOR)
/*           RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)                   +
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))            */

                        /* PRINT ORDER */
         /*  CALL       PGM(CUR330CL)   */

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
