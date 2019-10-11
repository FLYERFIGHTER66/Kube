/*********************************************************************/
/*   PROGRAM-------- GLR87ACL                                        */
/*   DATE WRITTEN--- 07/15/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- G/L CONSOLIDATION  CONVERT FROM 36 FILES        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             ADDLIBLE   LIB(TGMSDATA)
             ADDLIBLE   LIB(EFDSYS)
             CHGCURLIB  CURLIB(EFDSYS)

             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')

             CHGDTAARA  DTAARA(*LDA (100 10)) VALUE('P1        ')
             CHGDTAARA  DTAARA(*LDA (110 10)) VALUE('*NAR      ')
             CHGDTAARA  DTAARA(*LDA (120 2)) VALUE('01')
             CHGDTAARA  DTAARA(*LDA (123 4)) VALUE('*NO ')
             CHGDTAARA  DTAARA(*LDA (127 4)) VALUE('*NO ')

             CHGDTAARA  DTAARA(*LDA (201 2)) VALUE('01')
             CHGDTAARA  DTAARA(*LDA (203 1)) VALUE('Y')
             CHGDTAARA  DTAARA(*LDA (204 1)) VALUE('Y')
             CHGDTAARA  DTAARA(*LDA (205 3)) VALUE('S36')

             OVRDBF     FILE(GLDET) TOFILE(QS36F/SS.GLPRE)

             CALL       PGM(GLR87A)

             CALL       PGM(GLR870CL)

 END:        ENDPGM
