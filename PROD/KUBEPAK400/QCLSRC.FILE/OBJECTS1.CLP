/*********************************************************************/
/* Program? -  OBJECTS                                              */
/* Purpose? -  List All Objects Over 1 meg in Size                  */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 05/20/00    C. Wolinsky     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM
/* FILE OBJECTS IN ALL USER LIBRARIES */

             DSPOBJD   OBJ(TGMSDATA/*ALL) OBJTYPE(*ALL) DETAIL(*FULL) +
                          OUTPUT(*OUTFILE) OUTFILE(TGMSDATA/OBJECTS)

/*           RUNQRY     QRY(DW400/LISTOBJS)             */
/*           RUNQRY     QRY(DW400/LISTOBJS2)            */
             DLTOVR     FILE(*ALL)

 EOJ:        ENDPGM
