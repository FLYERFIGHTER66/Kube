/*********************************************************************/
/*   PROGRAM-------- NIGHTAP                                         */
/*   DATE WRITTEN---  4/21/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- NIGHTLY PROCEDURE FOR A/P APPLICATION           */
/*                   ONLY RUN AS PART OF NIGHT IN EFDSYS IF A/P INST.*/
/*   REVISIONS------                                                 */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM

/*   PURGE A/P WORK FILES                                            */
             DLTF       FILE(*LIBL/APWKWRK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(TGMSDATA/APWKWRK) SRCMBR(FAPWK) +
                          FLAG(20) MBR(RAPWK) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FAPWK) +
                          TOFILE(TGMSDATA/APWKWRK) MBROPT(*ADD) +
                          INCCHAR(AWSTAT 1 *EQ 'A') FMTOPT(*MAP *DROP)
             CLRPFM     FILE(TGMSDATA/FAPWK)
             CPYF       FROMFILE(TGMSDATA/APWKWRK) +
                          TOFILE(TGMSDATA/FAPWK) MBROPT(*ADD) +
                          INCCHAR(AWSTAT 1 *EQ 'A')
             DLTF       FILE(TGMSDATA/APWKWRK)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(TGMSDATA/APWKWRK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(TGMSDATA/APWSWRK) SRCMBR(FAPWKS) +
                          FLAG(20) MBR(RAPWKS) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FAPWKS) +
                          TOFILE(TGMSDATA/APWSWRK) MBROPT(*ADD) +
                          INCCHAR(APSTAT 1 *EQ 'A') FMTOPT(*MAP *DROP)
             CLRPFM     FILE(TGMSDATA/FAPWKS)
             CPYF       FROMFILE(TGMSDATA/APWSWRK) +
                          TOFILE(TGMSDATA/FAPWKS) MBROPT(*ADD) +
                          INCCHAR(APSTAT 1 *EQ 'A')
             DLTF       FILE(TGMSDATA/APWSWRK)
             MONMSG     MSGID(CPF2105)

/*   PURGE A/P CHECK                                                 */
             DLTF       FILE(TGMSDATA/APCHKWK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(TGMSDATA/APCHKWK) SRCMBR(FAPCHK) FLAG(20) +
                          MBR(RAPCHK) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FAPCHK) +
                          TOFILE(TGMSDATA/APCHKWK) MBROPT(*ADD) +
                          INCCHAR(ACSTAT 1 *EQ 'A')
             CLRPFM     FILE(TGMSDATA/FAPCHK)
             CPYF       FROMFILE(TGMSDATA/APCHKWK) TOFILE(TGMSDATA/FAPCHK) +
                          MBROPT(*ADD) INCCHAR(ACSTAT 1 *EQ 'A')

/*   PURGE TOPAY FILE                                                */
             DLTF       FILE(TGMSDATA/TOPAYWK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(TGMSDATA/TOPAYWK) SRCMBR(FTOPAY) FLAG(20) +
                          MBR(RTOPAY) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FTOPAY) +
                          TOFILE(TGMSDATA/TOPAYWK) MBROPT(*ADD) +
                          INCCHAR(TPSTAT 1 *EQ 'A')
             CLRPFM     FILE(TGMSDATA/FTOPAY)
             CPYF       FROMFILE(TGMSDATA/TOPAYWK) +
                          TOFILE(TGMSDATA/FTOPAY) MBROPT(*ADD) +
                          INCCHAR(TPSTAT 1 *EQ 'A')

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('NIGHTAP   ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Nightly A/P +
                          Process')
             CALL       PGM(STSUPD)

             ENDPGM
