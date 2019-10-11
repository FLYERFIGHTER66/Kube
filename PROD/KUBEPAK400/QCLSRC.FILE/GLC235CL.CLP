/********************************************************************/
/*                                                                  */
/* 5722SS1 V5R3M0 040528     RTVCLSRC Output     07/27/07 11:51:59  */
/*                                                                  */
/* Program name . . . . . . . . . . . . . . :   GLC235CL          PN*/
/* Library name . . . . . . . . . . . . . . :   KUBEPAK400        PL*/
/* Original source file . . . . . . . . . . :   QCLSRC            SN*/
/* Library name . . . . . . . . . . . . . . :   KUBEPAK400        SL*/
/* Original source member . . . . . . . . . :   GLC235CL          SM*/
/* Source file change                                               */
/*   date/time  . . . . . . . . . . . . . . :   03/28/03 16:08:21 SC*/
/* Patch option . . . . . . . . . . . . . . :   *NOPATCH          PO*/
/* User profile . . . . . . . . . . . . . . :   *USER             UP*/
/* Text . . . : ACCOUNT DETAIL REPORT                             TX*/
/* Owner  . . . . . . . . . . . . . . . . . :   CBUCK             OW*/
/* Patch change ID  . . . . . . . . . . . . :                     PC*/
/* Patch APAR ID  . . . . . . . . . . . . . :                     PA*/
/* User mod flag  . . . . . . . . . . . . . :   *YES              UM*/
/*                                                                ED*/
/********************************************************************/
BEGIN: +
     PGM
     CALL PGM(GLC235)
     CALL PGM(GLR235CL) PARM('(&XXACCT &XXFDAT &XXEDAT)')
END: +
     ENDPGM
