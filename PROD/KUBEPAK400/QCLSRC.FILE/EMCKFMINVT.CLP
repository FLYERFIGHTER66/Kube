             PGM

             ADDLIBLE   LIB(MMAIL)
             MONMSG     MSGID(CPF2103)

             OVRPRTF    FILE(QPQUPRFIL) OUTQ(BILLB/BILLB)

             RUNQRY     QRY(CKFMINVT01) QRYFILE((*SAME)) OUTTYPE(*PRINTER)
             RUNQRY     QRY(CKFMINVT02) QRYFILE((*SAME)) OUTTYPE(*PRINTER)
             RUNQRY     QRY(CKFMINVT03) QRYFILE((*SAME)) OUTTYPE(*PRINTER)
             RUNQRY     QRY(CKFMINVT04) QRYFILE((*SAME)) OUTTYPE(*PRINTER)

             MRGJOBSPLF DLTFILES(*YES)

             EMLSPL     SUBJECT('Daily Item Master Setup Audit') +
                          FROMNAME(QSYSOPR) +
                          FROMADDR('webmaster@kubepak.com') +
                          TO('wswanekamp@kubepak.com'/'Bill'/*TO +
                          'bcc@kubepak.net'/'BCC'/*BCC) +
                          SPLF(*YES/*LAST/*N/*N/*CURRENT/JOBSPLFS) +
                          MSGM(QMAILSRC/EMCKFMINVT)

             DLTSPLF    FILE(JOBSPLFS) SPLNBR(*LAST)

             ENDPGM
