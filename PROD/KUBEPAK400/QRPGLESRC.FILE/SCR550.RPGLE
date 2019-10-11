    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Binding Directory
    ?H DftActGrp(*No)                                                           ?Default Activation
    ?H DatFmt(*usa)                                                             ?Date Format

      *? System Data Structure
     D                SDS
    ?D #Program                1     10                                         ?Program Name
    ?D #Library               81     90                                         ?Library Name
    ?D #User                 254    263                                         ?User ID
    ?D #SrcLib               314    323                                         ?Source Library

      *? Local User Data Structure
     D*               UDS
    ?D*                                                                         ?Program Name

         //?Main Program Logic
      /Free
         *InLR = *On;
      /End-Free
