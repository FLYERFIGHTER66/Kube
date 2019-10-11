/*********************************************************************/
/*   PROGRAM-------- ICC605CL                                        */
/*   DATE WRITTEN--- 09/20/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ENTER INVVENTORY COUNT                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NXT) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ICC605')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Enter +
                          Physical Inventory ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ICR605)

                        GOTO END
 END:        ENDPGM
