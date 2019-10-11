             PGM

             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10 0)

/*? CHECK THE DAILY FILES AND REPLACE WITH BACKUP IF BLANK ?*/
/*? CHECK DAILY_OP.HTM ?*/
             CRTPF FILE(QTEMP/DAILY_OP) RCDLEN(200)
             MONMSG     MSGID(CPF7302)
             CLRPFM     FILE(QTEMP/DAILY_OP)
             CPYFRMIMPF FROMSTMF('/QDLS/FTP/WEBSITE/DAILY_OP.htm') +
                          TOFILE(QTEMP/DAILY_OP) MBROPT(*REPLACE) +
                          RCDDLM(*CR)
             MONMSG     MSGID(CPF2817 CPF2869)
             QSYS/RTVMBRD FILE(QTEMP/DAILY_OP) NBRCURRCD(&NBRCURRCD)

             IF         COND(&NBRCURRCD *LE 0) THEN(DO)
             CPY        OBJ('/QDLS/FTP/WEBSITE/DAILY_OP.bak') +
                      TOOBJ('/QDLS/FTP/WEBSITE/DAILY_OP.htm') +
                          REPLACE(*YES)
             ENDDO
             ELSE       CMD(DO)
             CPY        OBJ('/QDLS/FTP/WEBSITE/DAILY_OP.htm') +
                      TOOBJ('/QDLS/FTP/WEBSITE/DAILY_OP.bak') +
                          REPLACE(*YES)
             ENDDO

/*? CHECK DAILY_CL.HTM ?*/
             CRTPF FILE(QTEMP/DAILY_CL) RCDLEN(200)
             MONMSG     MSGID(CPF7302)
             CLRPFM     FILE(QTEMP/DAILY_CL)
             CPYFRMIMPF FROMSTMF('/QDLS/FTP/WEBSITE/DAILY_CL.htm') +
                          TOFILE(QTEMP/DAILY_CL) MBROPT(*REPLACE) +
                          RCDDLM(*CR)
             MONMSG     MSGID(CPF2817 CPF2869)
             QSYS/RTVMBRD FILE(QTEMP/DAILY_CL) NBRCURRCD(&NBRCURRCD)

             IF         COND(&NBRCURRCD *LE 0) THEN(DO)
             CPY        OBJ('/QDLS/FTP/WEBSITE/DAILY_CL.bak') +
                      TOOBJ('/QDLS/FTP/WEBSITE/DAILY_CL.htm') +
                          REPLACE(*YES)
             ENDDO
             ELSE       CMD(DO)
             CPY        OBJ('/QDLS/FTP/WEBSITE/DAILY_CL.htm') +
                      TOOBJ('/QDLS/FTP/WEBSITE/DAILY_CL.bak') +
                          REPLACE(*YES)
             ENDDO


 EOJ:        ENDPGM
