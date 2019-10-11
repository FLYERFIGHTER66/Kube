     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

    ?D $RmvDupWrd      PR           256A   ExtProc('$RmvDupWrd')
    ?D   #dupString#                256A   const
     P $RmvDupWrd      B                   Export
     D $RmvDupWrd      PI           256A
     D   #dupString#                256A   const

      /Free

         DCL-S myString char(256);
         DCL-S blanks256 char(256);
         DCL-S myWord char(30);
         DCL-S foundDup packed(3:0);
         DCL-S startOfWord packed(3:0);
         DCL-S endOfWord packed(3:0);
         DCL-S lengthOfWord packed(3:0);

         myString = #dupString#;
         //  'one  two buckle    my two shoe   three three four  out the door';
         myString = %Trim(myString);
         // Remove extra blanks blanks
         DoW %scan('  ':%Trim(myString):1)<>0;
           myString = %subst(myString:1:%scan('  ':myString:1))
           + %subst(myString+blanks256:%scan('  ':myString:1)+2:256);
         EndDo;
         startOfWord = 1;
         endOfWord = 0;
         lengthOfWord = 0;

         DoW %subst(myString+blanks256:startOfWord + lengthOfWord:256) <> ' ';
           endOfWord = %scan(' ':myString:startOfWord);
           lengthOfWord = endOfWord - startOfWord;
           myWord = %subst(myString:startOfWord:LengthOfWord);
           If lengthOfWord < 0;
              lengthOfWord = 1;
           EndIf;

           // Search for Duplicates and remove
           If myWord <> *Blanks;
             DoW %scan(%Trim(myWord):myString:endOfWord)<>0;
               foundDup = %scan(%Trim(myWord):myString:endOfWord);
               myString = %subst(myString:1:foundDup-1)
               + %subst(myString + blanks256:foundDup + lengthOfWord + 1:256);
             EndDo;
           EndIf;

           startOfWord = endOfWord + 1;

         EndDo;

         *InLR = *On;
         Return myString;

      /End-Free
     P $RmvDupWrd      E
