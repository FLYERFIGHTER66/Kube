/*********************************************************************/
/*   PROGRAM-------- BIR100CLS                                       */
/*   DATE WRITTEN---  8/10/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- ORDER ENTRY   SALE                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE('N')
             CHGDTAARA  DTAARA(*LDA (50 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (89 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (100 6)) VALUE('      ')
             CHGDTAARA  DTAARA(*LDA (106 11)) VALUE('00000000000')

             CALL       PGM(SALE01)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIR100CL)

   END:      ENDPGM
