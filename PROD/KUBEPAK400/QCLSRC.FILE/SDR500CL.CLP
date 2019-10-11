/*********************************************************************/
/*   PROGRAM-------- SDR500CL                                        */
/*   DATE WRITTEN--- 09/08/00                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SEED PRIVCE LOOKUP                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SER) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&VEND) TYPE(*CHAR) LEN(6)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(4)

             CHGDTAARA  DTAARA(*LDA (1 7)) VALUE('0000000')
             QSYS/RTVDTAARA DTAARA(*LDA (1 6)) RTNVAR(&VEND)
             QSYS/RTVDTAARA DTAARA(*LDA (7 1)) RTNVAR(&FORM)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             QSYS/RTVDTAARA DTAARA(*LDA (1 10)) RTNVAR(&SER)
             CHGDTAARA  DTAARA(*LDA (150 1)) VALUE('N')

             CALL       PGM(SDR500) PARM(&SER &VEND &FORM)

             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
