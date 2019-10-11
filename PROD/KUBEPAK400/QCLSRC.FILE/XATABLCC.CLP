/*********************************************************************/
/* Program? -  XATABLCC                                             */
/* Purpose? -  Maintain XATABL (AS/400 Native)                 */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 05/16/03    R. PIASECKI     PGM CREATED                           */
/* 08/11/17    W. BEHR         REMOVE HARD CODED LIBRARIES           */
/*********************************************************************/
             PGM

             OVRDBF  FILE(XATABL) TOFILE(XATABL)

             CALL       PGM(XATABLC)

             DLTOVR     FILE(*ALL)

             ENDPGM
