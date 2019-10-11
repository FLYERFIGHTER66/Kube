/*********************************************************************/
/*   PROGRAM-------- BIR237CLJQ                                      */
/*   DATE WRITTEN---  8/17/00                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- FUTURE ORDER RELEASE PICK SLIP PRINT PORTION    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&NBR) TYPE(*CHAR) LEN(6)
             QSYS/DCL   VAR(&FILE) TYPE(*CHAR) LEN(8)

/* AUTO PRINT SUMMARY PICK TICKET */
             RTVJOBA    NBR(&NBR)
             CHGDTAARA  DTAARA(*LDA (200 2)) VALUE('WF')
             CHGDTAARA  DTAARA(*LDA (202 6)) VALUE(&NBR)
             RTVDTAARA  DTAARA(*LDA (200 8)) RTNVAR(&FILE)
             CLRPFM     FILE(&FILE)
             MONMSG     MSGID(CPF3142) EXEC(DO)
             CRTPF      FILE(&FILE) SRCFILE(KUBEPAK400/QDDSSRC) +
                          SRCMBR(WBIR312) OPTION(*NOSRC *NOLIST) +
                          LVLCHK(*NO)
             ENDDO
             OVRDBF     FILE(WBIR312) TOFILE(&FILE)
             QSYS/RTVDTAARA DTAARA(*LDA (17 8)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(BIR312) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR312)

             QSYS/OVRPRTF FILE(QPK312) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             OVRDBF     FILE(WBIR312) TOFILE(&FILE)
             CALL       PGM(QPK312)
             DLTF       FILE(&FILE)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
