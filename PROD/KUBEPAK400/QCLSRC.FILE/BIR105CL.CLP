/*********************************************************************/
/*   PROGRAM-------- BIR105CL                                        */
/*   DATE WRITTEN--- 12/16/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ORDER ENTRY                                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             CHGDTAARA  DTAARA(*LDA (134 1)) VALUE('N')
             OVRDBF     FILE(FMCUSTC) TOFILE(FMCUST)
             OVRDBF     FILE(FMCUSTB) TOFILE(FMCUST)
             CALL       PGM(BIR105)
             ENDPGM
