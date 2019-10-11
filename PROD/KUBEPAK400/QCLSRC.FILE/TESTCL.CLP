/*********************************************************************/
/*   PROGRAM-------- BIC550CL                                        */
/*   DATE WRITTEN--- 09/08/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DAILY BILLING POST                              */
/*   REVISIONS------                                                 */
/*  4/13/00 EFD SPLIT INTO TWO FOR NIGHT TO RUN 2ND HALF             */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&NBR) TYPE(*CHAR) LEN(6)
             QSYS/DCL   VAR(&FILE) TYPE(*CHAR) LEN(8)

             RTVJOBA    NBR(&NBR)
             CHGDTAARA  DTAARA(*LDA (200 2)) VALUE('WF')
             CHGDTAARA  DTAARA(*LDA (202 6)) VALUE(&NBR)
             RTVDTAARA  DTAARA(*LDA (200 8)) RTNVAR(&FILE)
             CLRPFM     FILE(&FILE)
             MONMSG     MSGID(CPF3142) EXEC(DO)
             CRTPF      FILE(&FILE) SRCFILE(KUBEPAK400/QDDSSRC) +
                          SRCMBR(WBIR312) LVLCHK(*NO)
             ENDDO

             ENDPGM
