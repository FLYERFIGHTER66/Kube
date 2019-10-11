/*********************************************************************/
/*   PROGRAM NAME...  APSAVE                                         */
/*   DATE...........  02/05/97                                       */
/*   PROGRAMMER.....  GD                                             */
/*   DESCRIPTION....  SAVE TGMS A/P FILES TO TAPE                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             INZTAP     DEV(TAP01) NEWVOL(APYEAR) CHECK(*NO) +
                          DENSITY(*QIC525) CLEAR(*YES)
             SAVOBJ     OBJ(FAPCHK FAPCTL FAPDET FAPDTP FAPENT +
                          FAPMTH FAPOPN FAPREC FAPWK FAPWKS FCHKIT +
                          FMVEND FTOPAY FVENDCM FV1099 FYVEND) +
                          LIB(TGMSDATA) DEV(TAP01) UPDHST(*NO)
             ENDPGM
