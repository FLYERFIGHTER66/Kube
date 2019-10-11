/*********************************************************************/
/* Program? -  FIXAROPNC                                         */
/* Purpose? -  C/L TO RUN FIXAROPEN PROGRAM                    */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 10/10/03    R. Piasecki     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM

             OVRDBF     FILE(FAROPNPF) TOFILE(TGMSDATA/FAROPN)
             CALL  PGM(KUBEPAK400/FIXAROPN)
             DLTOVR     FILE(*ALL)

             ENDPGM
