/********************************************************************/
/*                                                                  */
/* 5716SS1 V3R7M0 961108     RTVCLSRC Output     05/18/00 08:51:00  */
/*                                                                  */
/* Program name . . . . . . . . . . . . . . :   NIGHT             PN*/
/* Library name . . . . . . . . . . . . . . :   KUBEPAK400        PL*/
/* Original source file . . . . . . . . . . :   QCLSRC            SN*/
/* Library name . . . . . . . . . . . . . . :   KUBEPAK400        SL*/
/* Original source member . . . . . . . . . :   NIGHT             SM*/
/* Source file change                                               */
/*   date/time  . . . . . . . . . . . . . . :   04/13/00 18:41:38 SC*/
/* Patch option . . . . . . . . . . . . . . :   *NOPATCH          PO*/
/* User profile . . . . . . . . . . . . . . :   *USER             UP*/
/* Text . . . : Nightly Procedure: Save and exception reports     TX*/
/* Owner  . . . . . . . . . . . . . . . . . :   EFD               OW*/
/* Patch change ID  . . . . . . . . . . . . :                     PC*/
/* Patch APAR ID  . . . . . . . . . . . . . :                     PA*/
/* User mod flag  . . . . . . . . . . . . . :   *YES              UM*/
/*                                                                ED*/
/********************************************************************/
     PGM
     CALL PGM(KUBEPAK400/KUBEALLLBL)
     ENDSBS SBS(QINTER) OPTION(*IMMED)
     ENDSBS SBS(QBATCH) OPTION(*IMMED)
     CALL PGM(BIC550ACL)
     CALL PGM(TSAVE)
     STRSBS SBSD(QINTER)
     MONMSG MSGID(CPF1010)
     STRSBS SBSD(QBATCH)
     MONMSG MSGID(CPF1010)
NOSAVE:
     CALL PGM(FXSOWD)
     CALL PGM(RBVALOO)
     CALL PGM(UPDCARBL)
     CALL PGM(BIR900)
     CALL PGM(CALCALOCL)
     CALL PGM(BLDLKITMCL)
     CHGDTAARA DTAARA(*LDA (201 44)) VALUE(' ')
     CHGDTAARA DTAARA(*LDA (201 10)) VALUE('NIGHT     ')
     CHGDTAARA DTAARA(*LDA (211 2)) VALUE('00')
     CHGDTAARA DTAARA(*LDA (213 2)) VALUE('00')
     CHGDTAARA DTAARA(*LDA (215 30)) VALUE('NIGHTLY PROCESS')
     CALL PGM(STSUPD)
 /*  CALL PGM(EFDGL/NIGHTGL)  */
     CALL PGM(NIGHTGL)
     CLROUTQ OUTQ(QEZJOBLOG)
     ENDPGM
