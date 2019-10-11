/*********************************************************************/
/*   PROGRAM-------- BIR237CLP                                       */
/*   DATE WRITTEN--- 09/11/09                                        */
/*   PROGRAMMER----- WJB                                             */
/*   DESCRIPTION---- FUTURE ORDER RELEASE  (PASSED PARMS)            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&ORDER &SHIPDATE)

             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ORDER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SHIPDATE) TYPE(*CHAR) LEN(6)

             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE('N')
             CHGDTAARA  DTAARA(*LDA (50 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (89 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (134 1)) VALUE('1')
             CHGDTAARA  DTAARA(*LDA (135 6)) VALUE(&ORDER)
             CHGDTAARA  DTAARA(*LDA (141 6)) VALUE(&SHIPDATE)

             CALL       PGM(BIR237)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
