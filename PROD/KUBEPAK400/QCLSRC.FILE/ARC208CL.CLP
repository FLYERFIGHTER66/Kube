/*********************************************************************/
/*   PROGRAM-------- ARC208CL                                        */
/*   DATE WRITTEN--- 06/17/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SUMMARY INVOICE POST                            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARC208')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      Summary +
                          A/R Post    ')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARR208)

/*   PURGE INVOICE SUMMARY WORK FILES                                */
             DLTF       FILE(*LIBL/ARENTWK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(TGMSDATA/ARENTWK) SRCMBR(FARENT) +
                          FLAG(20) MBR(RARENT) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FARENT) +
                          TOFILE(TGMSDATA/ARENTWK) MBROPT(*ADD) +
                          INCCHAR(AESTAT 1 *EQ 'A') FMTOPT(*MAP *DROP)
             CLRPFM     FILE(TGMSDATA/FARENT)
             CPYF       FROMFILE(TGMSDATA/ARENTWK) +
                          TOFILE(TGMSDATA/FARENT) MBROPT(*ADD) +
                          INCCHAR(AESTAT 1 *EQ 'A')
             DLTF       FILE(TGMSDATA/ARENTWK)
             MONMSG     MSGID(CPF2105)

 END:        ENDPGM
