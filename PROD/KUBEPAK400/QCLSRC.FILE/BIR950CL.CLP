/*********************************************************************/
/*   PROGRAM-------- BIR950CL                                        */
/*   DATE WRITTEN---  5/12/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PURGE POSTED RECORDS FROM OPEN ORDER FILE       */
/*                   BY SELECTED DATE.                               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CAN) TYPE(*CHAR) LEN(1)

             CALL       PGM(BIR950)
             RTVDTAARA  DTAARA(*LDA (1 1)) RTNVAR(&CAN)

             QSYS/RTVDTAARA DTAARA(*LDA (1 1)) RTNVAR(&CAN)
             IF         COND(&CAN = 'X') THEN(GOTO CMDLBL(END))

/*  COPY IORDR   */
             DLTF       FILE(QS36F/IORDRWRK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(QS36F/IORDRWRK) SRCMBR(FIORDR) FLAG(20) +
                          MBR(RIORDR) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(QS36F/FIORDR) +
                          TOFILE(QS36F/IORDRWRK) MBROPT(*ADD)
             CLRPFM     FILE(QS36F/FIORDR)
             CPYF       FROMFILE(QS36F/IORDRWRK) +
                          TOFILE(QS36F/FIORDR) MBROPT(*ADD)
             DLTF       FILE(QS36F/IORDRWRK)
             MONMSG     MSGID(CPF2105)

/*  COPY HORDR   */
             DLTF       FILE(QS36F/HORDRWRK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(QS36F/HORDRWRK) SRCMBR(FHORDR) FLAG(20) +
                          MBR(RHORDR) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(QS36F/FHORDR) +
                          TOFILE(QS36F/HORDRWRK) MBROPT(*ADD)
             CLRPFM     FILE(QS36F/FHORDR)
             CPYF       FROMFILE(QS36F/HORDRWRK) +
                          TOFILE(QS36F/FHORDR) MBROPT(*ADD)
             DLTF       FILE(QS36F/HORDRWRK)
             MONMSG     MSGID(CPF2105)

 END:        ENDPGM
