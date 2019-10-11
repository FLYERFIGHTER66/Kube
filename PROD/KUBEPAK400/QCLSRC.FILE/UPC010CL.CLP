/*********************************************************************/
/*   PROGRAM-------- UPC010CL                                        */
/*   DATE WRITTEN--- 05/19/2009                                      */
/*   PROGRAMMER----- William J. Behr                                 */
/*   DESCRIPTION---- Print Non-Inventory UPC Spot Labels             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&LABL) TYPE(*CHAR) LEN(10) +
                          VALUE('UPC15X15')
             DCL        VAR(&GROWNBYLIT) TYPE(*CHAR) LEN(10) +
                          VALUE('Grown by: ')
             DCL        VAR(&GROWNBYNAM) TYPE(*CHAR) LEN(10) +
                          VALUE('Kube Pak  ')
             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(25) +
                          VALUE('Allentown, NJ 08501')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB#) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SIZE) TYPE(*CHAR) LEN(3) VALUE('   ')
             DCL        VAR(&ACROSS) TYPE(*CHAR) LEN(2) VALUE('02')
             DCL        VAR(&CANCEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USERJOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10) VALUE('P4')

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2103)


             RTVJOBA    USER(&USER) NBR(&JOB#)
             CHGVAR     VAR(&USERJOB) VALUE(%SST(&USER 1 4) *CAT &JOB#)

             DLTOVR     FILE(FUPCLABL)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(FUPCLABL) MBR(&USERJOB)
             MONMSG     MSGID(CPF0000)

             ADDPFM     FILE(FUPCLABL) MBR(&USERJOB)
             OVRDBF     FILE(FUPCLABL) TOFILE(*LIBL/FUPCLABL) MBR(&USERJOB)

 UPC2PRINT:  CALL       PGM(UPC010) PARM(&CANCEL &PRT &SIZE &ACROSS +
                          &LABL &GROWNBYLIT &GROWNBYNAM &LOCATION) +
                          /* get UPC's to print */

             IF         COND(&CANCEL = 'X') THEN(GOTO CMDLBL(EOJ))

             TLABARCODE/LBLBATCH   LBLNAM(&LABL) QTYOVR(0001) OUTQ(&PRT) +
                          FORM(&LABL) MRGFILE(FUPCLABL) +
                          MRGMBR(&USERJOB)
             CLRPFM     FILE(FUPCLABL) MBR(&USERJOB)

             GOTO       CMDLBL(UPC2PRINT)
 EOJ:
             RMVM       FILE(FUPCLABL) MBR(&USERJOB)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(FUPCLABL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2104)

             ENDPGM
