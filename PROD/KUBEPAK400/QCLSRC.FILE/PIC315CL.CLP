/*********************************************************************/
/*   PROGRAM-------- PIC315CL                                        */
/*   DATE WRITTEN--- 06/27/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT POINSETTIA AVAILABILITY REPORT            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LEXCEL) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CALL       PGM(PIC315)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (173 1)) RTNVAR(&LEXCEL)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/PIC315CLJQ))
                        GOTO END


 NOJ:        CLRPFM     FILE(FPOIEXCL)
             CALL       PGM(PIC315CLJQ)

             IF         COND(&LEXCEL *EQ 'Y') THEN(DO)
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('"C:\Program Files\Microsoft +
                          Office\Office\excel.exe" +
                          c:\poi\custpoi.xls') PAUSE(*NO)
             ENDDO

END:         CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
