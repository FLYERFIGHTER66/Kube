/*********************************************************************/
/* Program? -  PIR230C                                              */
/* Purpose? -  Print Poinsettia Availability                        */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date    Programmer       ?Comment                            ?*/
/* 5/15/2003  Richard E. PiaseckiProgram created                     */
/*                                                                   */
/*********************************************************************/
             PGM




             OVRPRTF    FILE(DR0005P) PAGESIZE(66 80) OUTQ(HPOUTQ)
             CALL PGM(DR0005R) PARM(&DIST &STOR)

             ENDPGM
