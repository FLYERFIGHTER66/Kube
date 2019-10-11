/*********************************************************************/
/*   PROGRAM-------- TRC510CLJQ                                      */
/*   DATE WRITTEN---  1/10/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT TRUCK SCHEDULE       JOBQ                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)

             RTVOBJD    OBJ(*LIBL/FTRHDRW) OBJTYPE(*FILE) RTNLIB(&LIBR)

             QSYS/RTVDTAARA DTAARA(*LDA (23 10)) RTNVAR(&FILE)
             CRTPF      FILE(&LIBR/&FILE) SRCMBR(FTRHDRW) FLAG(20) +
                          MBR(RTRHDRW) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CLRPFM     FILE(&FILE)
             OVRDBF     FILE(FTRHDRW) TOFILE(&FILE)
             CALL       PGM(TRR521)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             IF         COND(&PRT *NE '          ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'P3        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'P7        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q3        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q4        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q5        ') THEN(GOTO CMDLBL(P7))

             QSYS/OVRPRTF FILE(TRR510) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT)

 P7:         QSYS/OVRPRTF FILE(TRR510) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FONT(*CPI) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT)

 PRT:        OVRDBF     FILE(FTRHDRW) TOFILE(&FILE)
             CALL       PGM(TRR510)

 END:        DLTF       FILE(&FILE)
             ENDPGM
