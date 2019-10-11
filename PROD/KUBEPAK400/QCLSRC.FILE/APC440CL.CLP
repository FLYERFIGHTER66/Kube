/*********************************************************************/
/*   PROGRAM-------- APC440CL                                        */
/*   DATE WRITTEN--- 05/18/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- START UP POST TO FAPOPN                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CALL       PGM(APC440)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APR440)

             CRTPF      FILE(TGMSDATA/APENTWRK) SRCMBR(FAPENT) FLAG(20) +
                          MBR(RAPENT) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(TGMSDATA/FAPENT) +
                          TOFILE(TGMSDATA/APENTWRK) MBROPT(*ADD) +
                          INCCHAR(ANSTAT 1 *EQ 'A')

             CLRPFM     FILE(TGMSDATA/FAPENT)

             CPYF       FROMFILE(TGMSDATA/APENTWRK) +
                          TOFILE(TGMSDATA/FAPENT) MBROPT(*ADD) +
                          INCCHAR(ANSTAT 1 *EQ 'A')

             DLTF       FILE(TGMSDATA/APENTWRK)
             MONMSG     MSGID(CPF2105)
 END:        ENDPGM
