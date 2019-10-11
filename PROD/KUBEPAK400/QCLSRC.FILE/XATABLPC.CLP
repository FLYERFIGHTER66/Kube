/*********************************************************************/
/* Program? -  XATABLPC                                             */
/* Purpose? -  Print Table Elements by Selected Catagory            */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 05/16/03    R. PIASECKI     PGM CREATED                           */
/* 08/11/17    W. BEHR         REMOVE HARD CODED LIBRARIES           */
/*********************************************************************/
             PGM

             OVRDBF  FILE(XATABL) TOFILE(XATABL)
             OVRDBF  FILE(XATABE1) TOFILE(XATABE1)

             CALL       PGM(XATABPRT)

             DLTOVR     FILE(*ALL)

             ENDPGM
