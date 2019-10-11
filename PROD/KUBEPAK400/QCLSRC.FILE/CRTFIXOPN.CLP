/*********************************************************************/
/* Program? -  CRTFIXOPN                                         */
/* Purpose? -  C/L TO CREATE FIXAROPEN PROGRAM                    */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 10/10/03    R. Piasecki     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM

             OVRDBF     FILE(FAROPNPF) TOFILE(TGMSDATA/FAROPN)
             CRTRPGPGM  PGM(KUBEPAK400/FIXAROPN) SRCFILE(KUBEPAK400/QRPGSRC)
             DLTOVR     FILE(*ALL)

             ENDPGM
