/*********************************************************************/
/*   PROGRAM-------- BIRPOSCL                                        */
/*   DATE WRITTEN--- 12/18/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- POINT OF SALES                                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&CNC) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (63 1)) VALUE('Y')
             CHGDTAARA  DTAARA(*LDA (41 6)) VALUE('000000')
             OVRDBF     FILE(FMCUSTC) TOFILE(FMCUST)
             OVRDBF     FILE(FMCUSTB) TOFILE(FMCUST)
 NEXT:       CALL       PGM(BIRPOS)
             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&CNC)
             IF         COND(&CNC = 'X') THEN(GOTO CMDLBL(END))
             CALL       PGM(B44POSCL)
             GOTO       CMDLBL(NEXT)
/* END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')   */
   END:      ENDPGM
