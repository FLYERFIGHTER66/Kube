/*********************************************************************/
/* Program? -  CRTCRTINVC                                           */
/* Purpose? -  C/L TO COMPILE CRTINVR                               */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 10/09/03    R. Piasecki     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM

             OVRDBF     FILE(FMINVTPF) TOFILE(TGMSDATA/FMINVT)
             CRTRPGPGM  PGM(KUBEPAK400/CRTINV) SRCFILE(KUBEPAK400/QRPGSRC)
             DLTOVR     FILE(*ALL)

             ENDPGM
