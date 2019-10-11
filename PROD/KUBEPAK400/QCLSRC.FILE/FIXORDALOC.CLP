/*********************************************************************/
/*   PROGRAM-------- FIXORDALOC                                      */
/*   DATE WRITTEN---  3/24/2011                                      */
/*   PROGRAMMER----- WILLIAM BEHR                                    */
/*   DESCRIPTION---- RESET ORDER ALLOCATIONS                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             DCLF       FILE(FIXORDALOC)

 SCRN01:
             SNDRCVF
             IF         COND(&IN03 = '1') THEN(GOTO CMDLBL(ENDSCRN01))
             CALL       PGM(FIXFALITE1) PARM(&ORDER#)
             GOTO       CMDLBL(SCRN01)
 ENDSCRN01:

             ENDPGM
