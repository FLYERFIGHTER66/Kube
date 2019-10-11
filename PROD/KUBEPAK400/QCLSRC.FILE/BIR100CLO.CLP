/*********************************************************************/
/*   PROGRAM-------- BIR100CL                                        */
/*   DATE WRITTEN--- 12/18/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ORDER ENTRY                                     */
/*   REVISIONS------                                                 */
/*   5/28/97 EFD AUTO PRINT PICK TICKETS.                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ORD# &SEQ#)
             DCL        VAR(&ORD#) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&ORD#@) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SEQ#) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&SEQ#@) TYPE(*CHAR) LEN(3)
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LCANCL) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (8 1)) VALUE('Y')
             CHGVAR     VAR(&ORD#@) VALUE(&ORD#)
             CHGVAR     VAR(&SEQ#@) VALUE(&SEQ#)
             CHGDTAARA  DTAARA(*LDA (9 6)) VALUE(&ORD#@)
             CHGDTAARA  DTAARA(*LDA (15 3)) VALUE(&SEQ#@)
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

 END:
             RTVDTAARA  DTAARA(*LDA (62 1)) RTNVAR(&LCANCL)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (62 1)) VALUE(&LCANCL)
             ENDPGM
