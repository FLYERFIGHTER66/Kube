/*********************************************************************/
/*   PROGRAM-------- FXMINVTCLJ                                      */
/*   DATE WRITTEN--- 10/31/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- FIX MINVT IF TWO COPIES NEEDED                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             OVRDBF     FILE(FMINVTI) TOFILE(TGMSDATA/FMINVT)

             CALL       PGM(FXMINVT)

 END:        ENDPGM
