/*********************************************************************/
/* Program? -  CRTKP0119C                                           */
/* Purpose? -  C/L TO COMPILE KP0119R                               */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 09/17/03    R. Piasecki     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM

             OVRDBF     FILE(FMINVTPF) TOFILE(TGMSDATA/FMINVT)
             CRTRPGPGM  PGM(KUBEPAK400/KP0119R) SRCFILE(KUBEPAK400/QRPGSRC)
             DLTOVR     FILE(*ALL)

             ENDPGM
