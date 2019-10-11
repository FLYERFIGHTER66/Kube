/*********************************************************************/
/*   PROGRAM-------- BIR280CL                                        */
/*   DATE WRITTEN---  3/01/99                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- BROKER ORDER ENTRY   (FOR INTERNAL USE)         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (1 1)) VALUE('Y')
             CHGDTAARA  DTAARA(*LDA (2 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE('N')
             CHGDTAARA  DTAARA(*LDA (50 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (89 6)) VALUE('000000')

 NXTO:       CALL       PGM(BRK281)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))

             OVRDBF     FILE(FMCUSTC) TOFILE(FMCUST)
             OVRDBF     FILE(FMCUSTB) TOFILE(FMCUST)
             CALL       PGM(BIR100)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))
             CHGDTAARA  DTAARA(*LDA (1 1)) VALUE('Y')
             CHGDTAARA  DTAARA(*LDA (2 6)) VALUE('000000')
             GOTO       CMDLBL(NXTO)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
