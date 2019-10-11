/*********************************************************************/
/*   PROGRAM-------- BIR100CL                                        */
/*   DATE WRITTEN--- 12/18/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ORDER ENTRY                                     */
/*   REVISIONS------                                                 */
/*   5/28/97 EFD AUTO PRINT PICK TICKETS.                            */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE('N')
             CHGDTAARA  DTAARA(*LDA (50 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (89 6)) VALUE('000000')
 NXTO:       OVRDBF     FILE(FMCUSTC) TOFILE(FMCUST)
             OVRDBF     FILE(FMCUSTB) TOFILE(FMCUST)
             CALL       PGM(BIR100)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))
/* AUTO PRINT PICK TICKET */
/*           SBMJOB     CMD(CALL PGM(DILLON/BIR310CL))  */
/*           MONMSG     MSGID(CPF1241)                  */
/*           GOTO       CMDLBL(NXTO)                    */

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
