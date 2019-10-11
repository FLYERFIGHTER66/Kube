/*********************************************************************/
/*   PROGRAM-------- WSSNDFTPC                                       */
/*   DATE WRITTEN--- 07 Jun 2018                                     */
/*   PROGRAMMER----- Vimala                                          */
/*   DESCRIPTION---- Program to SEND Inventory and Order Ack XML's   */
/*                   to Brokers using FTP                            */
/*   PARAMETERS----- WSACKEHFTP, WSACKEHLOG  or                      */
/*                   WSACKMCFTP, WSACKMCLOG  or                      */
/*                   WSACKVNFTP, WSACKVNLOG  or                      */
/*                   WSINVMHFTP, WSINVMHLOG                          */
/*                                                                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&INPUT &OUTPUT)

             DCL        VAR(&INPUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(10)

             OVRDBF     FILE(INPUT) TOFILE(QFTPSRC) MBR(&INPUT)
             OVRDBF     FILE(OUTPUT) TOFILE(QFTPSRC) MBR(&OUTPUT)

             CLRPFM     FILE(QFTPSRC) MBR(&OUTPUT)

             FTP        RMTSYS(SERVERNOTFOUND)

             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)

             ENDPGM
