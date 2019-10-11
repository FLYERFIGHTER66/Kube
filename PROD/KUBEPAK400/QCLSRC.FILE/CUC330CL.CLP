/*********************************************************************/
/*   PROGRAM-------- CUC330CL                                        */
/*   DATE WRITTEN--- 11/07/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- REPRINT CUTTING ORDER                           */
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

             CALL       PGM(CUC330) PARM(&VENDOR)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

                        /* PRINT ORDER */
             CALL       PGM(CUR330CL) PARM(&VENDOR)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
