/*********************************************************************/
/*   PROGRAM-------- CUR340CL                                        */
/*   DATE WRITTEN--- 11/06/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- TRANSFER OREDES TO P.C.                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&VENDOR) TYPE(*DEC) LEN(6)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRDAPPDIR) TYPE(*CHAR) LEN(150)
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('/CUT/CUT system PC transfer.xlsm"')

             RTVDTAARA  DTAARA(PRDAPPDIR *ALL) RTNVAR(&PRDAPPDIR)
             CHGVAR     VAR(&PCCMD) VALUE('"' *TCAT &PRDAPPDIR *TCAT &PCCMD)


             CALL       PGM(CUR999) PARM(&VENDOR)
             IF         COND(&VENDOR = 0) THEN(DO)
             SNDPGMMSG  MSGID(CUT0001) MSGF(KPMSGF) MSGDTA(*NONE) +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO


             CALL       PGM(CUC340) PARM(&VENDOR)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CLRPFM     FILE(FCUTTXF)

             CALL       PGM(CUR340) PARM(&VENDOR)

             MONMSG     MSGID(IWS4010)

             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
