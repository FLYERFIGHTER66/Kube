/*********************************************************************/
/*   PROGRAM-------- ICR200CL                                        */
/*   DATE WRITTEN--- 09/15/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- INVENTORY TRANSACTION ENTRY                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ITEM &SIZE)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SIZE) TYPE(*CHAR) LEN(3)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ICR200')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Inventory +
                          Transaction Entry ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))


             CALL       PGM(ICR200) PARM(&ITEM &SIZE)
 END:        ENDPGM
