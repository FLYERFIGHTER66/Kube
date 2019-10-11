/*********************************************************************/
/* Program? -  CRTINVC                                           */
/* Purpose? -  C/L TO RUN CRTINVR                               */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 10/10/03    R. Piasecki     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM

             OVRDBF     FILE(FMINVTPF) TOFILE(TGMSDATA/FMINVT)
             CALL  PGM(KUBEPAK400/CRTINV)
             DLTOVR     FILE(*ALL)

             ENDPGM
