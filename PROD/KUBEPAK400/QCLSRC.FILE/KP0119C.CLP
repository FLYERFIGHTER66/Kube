/*********************************************************************/
/* Program? -  KP0119C                                              */
/* Purpose? -  Inventory Requirements by Ship Date                  */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 09/17/03    R. Piasecki     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM


             OVRDBF  FILE(FMINVTPF) TOFILE(TGMSDATA/FMINVT)

             CALL       PGM(KP0119R)

             DLTOVR     FILE(*ALL)


             ENDPGM
