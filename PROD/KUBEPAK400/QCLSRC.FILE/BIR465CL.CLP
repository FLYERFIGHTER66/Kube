/*********************************************************************/
/*   PROGRAM-------- BIR455CL                                        */
/*   DATE WRITTEN---  2/05/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRINT CREDIT MEMOS                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOSTMF) TYPE(*CHAR) LEN(130)

             RTVDTAARA  DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             RTVJOBA    DATETIME(&DATETIME)
             CHGVAR     VAR(&TOSTMF) VALUE('/Kube Pak/PDF/CR_MEMO/CRM-' +
                          *TCAT &DATETIME *TCAT '.pdf')
             OVRPRTF    FILE(BIR465A) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) LPI(6) +
                          CPI(12) FRONTMGN(0 0) ALIGN(*NO) PAGRTT(0) +
                          UOM(*INCH) FRONTOVL(CRMEMO 0) TOSTMF(&TOSTMF) +
                          WSCST(*PDF) OPNSCOPE(*JOB)
             CALL       PGM(BIR465)
             DLTOVR     FILE(BIR465A)
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('"//10.151.151.1' *TCAT &TOSTMF *TCAT '"') +
                          PAUSE(*NO)
 END:        ENDPGM
