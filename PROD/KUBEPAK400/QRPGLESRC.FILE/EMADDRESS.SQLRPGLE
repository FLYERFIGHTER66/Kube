     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

     D EMADDRESS       PR                  ExtPgm('EMADDRESS')
     D  #SelType                      3A
     D  #SelCust                      6P 0
     D  #ToName                      30A
     D  #Em1                         32A
     D  #Em2                         32A
     D  #Em3                         32A
     D  #Em4                         32A
     D  #Em5                         32A
     D  #Em6                         32A
     D  #Em7                         32A
     D  #Em8                         32A
     D EMADDRESS       PI
     D  #SelType                      3A
     D  #SelCust                      6P 0
     D  #ToName                      30A
     D  #Em1                         32A
     D  #Em2                         32A
     D  #Em3                         32A
     D  #Em4                         32A
     D  #Em5                         32A
     D  #Em6                         32A
     D  #Em7                         32A
     D  #Em8                         32A

      *? Local Function Prototypes
     D GetData         PR

      *? Local Field Definitions
     D Blank30         S             30A   Inz(*Blanks)
     D DftEmail        S             32A   Inz('webmaster@kubepak.com')

     D EMAIL_DS        DS
     D  ToName                       30A
     D  Em1                          32A
     D  Em2                          32A
     D  Em3                          32A
     D  Em4                          32A
     D  Em5                          32A
     D  Em6                          32A
     D  Em7                          32A
     D  Em8                          32A

      /Free

         Exec SQL
           SELECT  EMNAME||EMAIL
           INTO   :EMAIL_DS
           FROM    FMEMAIL
           WHERE   EMCODE = 'INV'
             and   EMACCT = :#SelCust
           FETCH FIRST ROW ONLY;

         If Em1 = *Blanks;
           EMAIL_DS = Blank30 + DftEmail;
         ENDIF;

         #ToName = ToName;
         #Em1 = Em1;
         #Em2 = Em2;
         #Em3 = Em3;
         #Em4 = Em4;
         #Em5 = Em5;
         #Em6 = Em6;
         #Em7 = Em7;
         #Em8 = Em8;

         *InLR = *On;
         Return;

      /End-Free
