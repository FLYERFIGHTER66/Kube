/*********************************************************************/
/*   PROGRAM-------- ARR002CL                                        */
/*   DATE WRITTEN--- 08/16/98                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- BANK MASTER FILE MAINTENANCE                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LST) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR002')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Bank Master +
                          File Maintenance ')

 NXT:        CALL       PGM(ARR002)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&LST)
             IF         COND(&LST = ' ') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARC102CL)

             GOTO       CMDLBL(NXT)
 END:        ENDPGM
