﻿/* Copyright 2010-2023 Tara McGrew
 * 
 * This file is part of ZILF.
 * 
 * ZILF is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * ZILF is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with ZILF.  If not, see <http://www.gnu.org/licenses/>.
 */

using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Threading.Tasks;

namespace Zilf.Tests.Integration
{
    [TestClass, TestCategory("Code Generation")]
    public class CodeGenTests : IntegrationTestClass
    {
        [TestMethod]
        public async Task TestAddToVariable()
        {
            await AssertRoutine("\"AUX\" X Y", "<SET X <+ .X .Y>>")
                .GeneratesCodeMatchingAsync(@"ADD X,Y >X\r?\n\s*RETURN X");
        }

        [TestMethod]
        public async Task TestAddInVoidContextBecomesINC()
        {
            await AssertRoutine("\"AUX\" X", "<SET X <+ .X 1>> .X")
                .GeneratesCodeMatchingAsync(@"INC 'X\r?\n\s*RETURN X");
        }

        [TestMethod]
        public async Task TestAddInValueContextBecomesINC()
        {
            await AssertRoutine("\"AUX\" X", "<SET X <+ .X 1>>")
                .GeneratesCodeMatchingAsync(@"INC 'X\r?\n\s*RETURN X");
        }

        [TestMethod]
        public async Task TestSubtractInVoidContextThenLessBecomesDLESS()
        {
            await AssertRoutine("\"AUX\" X", "<SET X <- .X 1>> <COND (<L? .X 0> <PRINTI \"blah\">)>")
                .GeneratesCodeMatchingAsync(@"DLESS\? 'X,0");
        }

        [TestMethod]
        public async Task TestSubtractInValueContextThenLessBecomesDLESS()
        {
            await AssertRoutine("\"AUX\" X", "<COND (<L? <SET X <- .X 1>> 0> <PRINTI \"blah\">)>")
                .GeneratesCodeMatchingAsync(@"DLESS\? 'X,0");
        }

        [TestMethod]
        public async Task TestRoutineResultIntoVariable()
        {
            await AssertRoutine("\"AUX\" FOO", "<SET FOO <WHATEVER>>")
                .WithGlobal("<ROUTINE WHATEVER () 123>")
                .InV3()
                .GeneratesCodeMatchingAsync("CALL WHATEVER >FOO");
        }

        [TestMethod]
        public async Task TestPrintiCrlfRtrueBecomesPRINTR()
        {
            await AssertRoutine("", "<PRINTI \"hi\"> <CRLF> <RTRUE>")
                .GeneratesCodeMatchingAsync("PRINTR \"hi\"");
        }

        [TestMethod]
        public async Task TestAdjacentEqualsCombine()
        {
            await AssertRoutine("\"AUX\" X", "<COND (<OR <=? .X 1> <=? .X 2>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? X,1,2 /TRUE");
            await AssertRoutine("\"AUX\" X", "<COND (<OR <EQUAL? .X 1 2> <EQUAL? .X 3 4>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? X,1,2,3 /TRUE");
            await AssertRoutine("\"AUX\" X", "<COND (<OR <EQUAL? .X 1 2 3> <=? .X 4> <EQUAL? .X 5 6>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? X,1,2,3 /TRUE\r?\n\s*EQUAL\? X,4,5,6 /TRUE");
        }

        [TestMethod]
        public async Task TestEqualZeroBecomesZERO_P()
        {
            await AssertRoutine("\"AUX\" X", "<COND (<=? .X 0> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"ZERO\? X /TRUE");
            await AssertRoutine("\"AUX\" X", "<COND (<=? 0 .X> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"ZERO\? X /TRUE");
        }

        [TestMethod]
        public async Task TestAdjacentEqualsCombineEvenIfZero()
        {
            await AssertRoutine("\"AUX\" X", "<COND (<OR <=? .X 0> <=? .X 2>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? X,0,2 /TRUE");
            await AssertRoutine("\"AUX\" X", "<COND (<OR <=? .X 0> <=? .X 0>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? X,0,0 /TRUE");
            await AssertRoutine("\"AUX\" X", "<COND (<OR <EQUAL? .X 1 2> <=? .X 0> <EQUAL? .X 3 4>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? X,1,2,0 /TRUE");
            await AssertRoutine("\"AUX\" X", "<COND (<OR <EQUAL? .X 1 2> <EQUAL? .X 3 0>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? X,1,2,3 /TRUE\r?\n\s*ZERO\? X /TRUE");
        }

        [TestMethod]
        public async Task TestValuePredicateContext()
        {
            await AssertRoutine("\"AUX\" X Y", "<COND (<NOT <SET X <FIRST? .Y>>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"FIRST\? Y >X \\TRUE");
            await AssertRoutine("\"AUX\" X Y", "<COND (<NOT .Y> <SET X <>>) (T <SET X <FIRST? .Y>>)> <OR .X <RTRUE>>")
                .GeneratesCodeMatchingAsync(@"FIRST\? Y >X (?![/\\]TRUE)");
        }

        [TestMethod]
        public async Task TestValuePredicateContext_Calls()
        {
            await AssertRoutine("\"AUX\" X", "<COND (<NOT <SET X <FOO>>> <RTRUE>)>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .GeneratesCodeMatchingAsync(@"CALL FOO >X\r?\n\s*ZERO\? X /TRUE");
        }

        [TestMethod]
        public async Task TestValuePredicateContext_Constants()
        {
            await AssertRoutine("\"AUX\" X", "<COND (<NOT <SET X <>>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"SET 'X,0\r?\n\s*RTRUE");
            await AssertRoutine("\"AUX\" X", "<COND (<NOT <SET X 0>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"SET 'X,0\r?\n\s*RTRUE");
            await AssertRoutine("\"AUX\" X", "<COND (<NOT <SET X 100>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"SET 'X,100\r?\n\s*RFALSE");
            await AssertRoutine("\"AUX\" X", "<COND (<NOT <SET X T>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"SET 'X,1\r?\n\s*RFALSE");
            await AssertRoutine("\"AUX\" X", "<COND (<NOT <SET X \"blah\">> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"SET 'X,STR\?\d+\r?\n\s*RFALSE");
        }

        [TestMethod]
        public async Task TestMergeAdjacentTerminators()
        {
            await AssertRoutine("OBJ \"AUX\" (CNT 0) X",
@"<COND (<SET X <FIRST? .OBJ>>
	<REPEAT ()
		<SET CNT <+ .CNT 1>>
		<COND (<NOT <SET X <NEXT? .X>>> <RETURN>)>>)>
.CNT").WhenCalledWith("<>")
      .GeneratesCodeMatchingAsync(@"NEXT\? X >X /\?L\d+\r?\n\s*\?L\d+:\s*RETURN CNT\r?\n\r?\n");
        }

        [TestMethod]
        public async Task TestBranchToSameCondition()
        {
            await AssertRoutine("\"AUX\" P",
@"<OBJECTLOOP I ,HERE
    <COND (<AND <NOT <FSET? .I ,TOUCHBIT>> <SET P <GETP .I ,P?FDESC>>>
		   <PRINT .P> <CRLF>)>>")
                           .WithGlobal(@"<DEFMAC OBJECTLOOP ('VAR 'LOC ""ARGS"" BODY)
    <FORM REPEAT <LIST <LIST .VAR <FORM FIRST? .LOC>>>
        <FORM COND
            <LIST <FORM LVAL .VAR>
                !.BODY
                <FORM SET .VAR <FORM NEXT? <FORM LVAL .VAR>>>>
            '(ELSE <RETURN>)>>>")
                           .WithGlobal("<GLOBAL HERE <>>")
                           .WithGlobal("<GLOBAL TOUCHBIT <>>")
                           .WithGlobal("<GLOBAL P?FDESC <>>")
                           .GeneratesCodeMatchingAsync(@"\A(?:(?!ZERO I\?).)*PRINT P(?:(?!ZERO\? I).)*\Z");
        }

        [TestMethod]
        public async Task TestReturnOrWithPred()
        {
            await AssertRoutine("\"AUX\" X", "<OR <EQUAL? .X 123> <FOO>>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .GeneratesCodeNotMatchingAsync(@"PUSH|ZERO\?");
        }

        [TestMethod]
        public async Task TestSetOrWithPred()
        {
            await AssertRoutine("\"AUX\" X Y", "<SET Y <OR <EQUAL? .X 123> <FOO>>>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .GeneratesCodeNotMatchingAsync(@"ZERO\?");
        }

        [TestMethod]
        public async Task TestPrintrOverBranch_1()
        {
            await AssertRoutine("\"AUX\" X", "<COND (.X <PRINTI \"foo\">) (T <PRINTI \"bar\">)> <CRLF> <RTRUE>")
                .GeneratesCodeMatchingAsync("PRINTR \"foo\".*PRINTR \"bar\"");

        }
        [TestMethod]
        public async Task TestPrintrOverBranch_2()
        {
            await AssertRoutine("\"AUX\" X", "<COND (.X <PRINTI \"foo\"> <CRLF>) (T <PRINTI \"bar\"> <CRLF>)> <RTRUE>")
                .GeneratesCodeMatchingAsync("PRINTR \"foo\".*PRINTR \"bar\"");
        }

        [TestMethod]
        public async Task TestSimpleAND_1()
        {
            await AssertRoutine("\"AUX\" A", "<AND .A <FOO>>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .GeneratesCodeNotMatchingAsync(@"\?TMP");
        }

        [TestMethod]
        public async Task TestSimpleAND_2()
        {
            await AssertRoutine("\"AUX\" A", "<AND <OR <0? .A> <FOO>> <BAR>>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .WithGlobal("<ROUTINE BAR () <>>")
                .GeneratesCodeNotMatchingAsync(@"\?TMP");
        }

        [TestMethod]
        public async Task TestSimpleOR_1()
        {
            await AssertRoutine("\"AUX\" A", "<OR .A <FOO>>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .GeneratesCodeNotMatchingAsync(@"\?TMP");
        }

        [TestMethod]
        public async Task TestSimpleOR_2()
        {
            await AssertRoutine("\"AUX\" OBJ", "<OR <FIRST? .OBJ> <FOO>>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .GeneratesCodeMatchingAsync(@"RETURN \?TMP.*RSTACK");
        }

        [TestMethod]
        public async Task TestSimpleOR_3()
        {
            await AssertRoutine("\"AUX\" A", "<OR <SET A <FOO>> <BAR>>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .WithGlobal("<ROUTINE BAR () <>>")
                .GeneratesCodeNotMatchingAsync(@"\?TMP");
        }

        [TestMethod]
        public async Task TestNestedTempVariables()
        {
            // this code should use 3 temp variables:
            // ?TMP is the value of GLOB before calling FOO
            // ?TMP?1 is the value returned by FOO
            // ?TMP?2 is the value of GLOB before calling BAR

            await AssertRoutine("\"AUX\" X", @"<PUT ,GLOB <FOO> <+ .X <GET ,GLOB <BAR>>>>")
                .WithGlobal("<GLOBAL GLOB <>>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .WithGlobal("<ROUTINE BAR () <>>")
                .GeneratesCodeMatchingAsync(@"\?TMP\?2");
        }

        [TestMethod]
        public async Task TestNestedBindVariables()
        {
            await AssertRoutine("", @"<BIND (X)
                                  <SET X 0>
                                  <BIND (X)
                                    <SET X 1>
                                    <BIND (X)
                                      <SET X 2>>>>")
                .GeneratesCodeMatchingAsync(@"X\?2");
        }

        [TestMethod]
        public async Task TestTimeHeader_V3()
        {
            await AssertRoutine("", "<>")
                .WithVersionDirective("<VERSION ZIP TIME>")
                .GeneratesCodeMatchingAsync(@"^\s*\.TIME\s*$");
        }

        [TestMethod]
        public async Task TestSoundHeader_V3()
        {
            await AssertRoutine("", "<>")
                .WithGlobal("<SETG SOUND-EFFECTS? T>")
                .InV3()
                .GeneratesCodeMatchingAsync(@"^\s*\.SOUND\s*$");
        }

        [TestMethod]
        public async Task TestCleanStack_V3_NoClean()
        {
            await AssertRoutine("", "<FOO> 456")
                .WithGlobal("<ROUTINE FOO () 123>")
                .InV3()
                .GeneratesCodeNotMatchingAsync(@"FSTACK");
        }

        [TestMethod]
        public async Task TestCleanStack_V3_Clean()
        {
            await AssertRoutine("", "<FOO> 456")
                .WithGlobal("<FILE-FLAGS CLEAN-STACK?>")
                .WithGlobal("<ROUTINE FOO () 123>")
                .InV3()
                .GeneratesCodeMatchingAsync(@"FSTACK");
        }

        [TestMethod]
        public async Task TestCleanStack_V4_NoClean()
        {
            await AssertRoutine("", "<FOO> 456")
                .WithGlobal("<ROUTINE FOO () 123>")
                .InV4()
                .GeneratesCodeNotMatchingAsync(@"FSTACK");
        }

        [TestMethod]
        public async Task TestCleanStack_V4_Clean()
        {
            await AssertRoutine("", "<FOO> 456")
                .WithGlobal("<FILE-FLAGS CLEAN-STACK?>")
                .WithGlobal("<ROUTINE FOO () 123>")
                .InV4()
                .GeneratesCodeMatchingAsync(@"FSTACK");
        }

        [TestMethod]
        public async Task TestReuseTemp()
        {
            // the first G? allocates one temp var, then releases it afterward
            // the BIND consumes the same temp var and binds it to a new atom
            // the second G? allocates a new temp var, which must not collide with the first
            await AssertRoutine("",
                "<COND (<G? <FOO> <BAR>> <RTRUE>)> " +
                "<BIND ((Z 0)) <COND (<G? <BAR> <FOO>> <RFALSE>)>>")
                .WithGlobal("<ROUTINE FOO () 123>")
                .WithGlobal("<ROUTINE BAR () 456>")
                .CompilesAsync();
        }

        [TestMethod]
        public async Task TestNoTempForSet()
        {
            // this shouldn't use any temp vars, since the expressions are going into named variables
            await AssertRoutine("\"AUX\" X Y",
                "<COND (<G? <SET X <FOO>> <SET Y <BAR>>> <RTRUE>)> " +
                "<BIND ((Z 0)) <COND (<G? <SET X <BAR>> <SET Y <FOO>>> <RFALSE>)>>")
                .WithGlobal("<ROUTINE FOO () 123>")
                .WithGlobal("<ROUTINE BAR () 456>")
                .GeneratesCodeNotMatchingAsync(@"\?TMP");

            // this one should, since X is modified in a subsequent arg
            await AssertRoutine("\"AUX\" X Y",
                "<COND (<G? <SET X <FOO>> <SET Y <SET X <BAR>>>> <RTRUE>)> " +
                "<BIND ((Z 0)) <COND (<G? <SET X <BAR>> <SET Y <SET X <FOO>>>> <RFALSE>)>>")
                .WithGlobal("<ROUTINE FOO () 123>")
                .WithGlobal("<ROUTINE BAR () 456>")
                .GeneratesCodeMatchingAsync(@"\?TMP");
        }

        [TestMethod]
        public async Task CHRSET_Should_Generate_Directive()
        {
            await AssertGlobals(
                "<CHRSET 0 \"zyxwvutsrqponmlkjihgfedcba\">")
                .InV5()
                .GeneratesCodeMatchingAsync(@"\.CHRSET 0,122,121,120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101,100,99,98,97");
        }

        [TestMethod]
        public async Task Table_And_Verb_Names_Should_Be_Sanitized()
        {
            await AssertGlobals(
                @"<SYNTAX \,TELL = V-TELL>",
                "<ROUTINE V-TELL () <>>",
                @"<CONSTANT \,TELLTAB1 <ITABLE 1>>",
                @"<GLOBAL \,TELLTAB2 <ITABLE 1>>")
                .GeneratesCodeNotMatchingAsync(@",TELL");
        }

        [TestMethod]
        public async Task Constant_Arithmetic_Operations_Should_Be_Folded()
        {
            // binary operators
            await AssertRoutine("",
                "<+ 1 <* 2 3> <* 4 5>>")
                .GeneratesCodeMatchingAsync("RETURN 27");

            await AssertRoutine("",
                "<+ ,EIGHT ,SIXTEEN>")
                .WithGlobal("<CONSTANT EIGHT 8>")
                .WithGlobal("<CONSTANT SIXTEEN 16>")
                .GeneratesCodeMatchingAsync("RETURN 24");

            await AssertRoutine("",
                "<MOD 1000 16>")
                .GeneratesCodeMatchingAsync("RETURN 8");

            await AssertRoutine("",
                "<ASH -32768 -2>")
                .InV5()
                .GeneratesCodeMatchingAsync("RETURN -8192");

            await AssertRoutine("",
                "<LSH -32768 -2>")
                .InV5()
                .GeneratesCodeMatchingAsync("RETURN 8192");

            await AssertRoutine("",
                "<XORB 25 -1>")
                .GeneratesCodeMatchingAsync("RETURN -26");

            // unary operators
            await AssertRoutine("",
                "<BCOM 123>")
                .GeneratesCodeMatchingAsync("RETURN -124");
        }

        [TestMethod]
        public async Task Constant_Comparisons_Should_Be_Folded()
        {
            // unary comparisons
            await AssertRoutine("",
                "<0? ,FALSE-VALUE>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RTRUE");

            await AssertRoutine("",
                "<1? <- 6 5>>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RTRUE");

            await AssertRoutine("",
                "<T? <+ 1 2 3>>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RTRUE");

            await AssertRoutine("",
                "<F? <+ 1 2 3>>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RFALSE");

            await AssertRoutine("",
                "<NOT <- 6 4 2>>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RTRUE");

            // binary comparisons
            await AssertRoutine("",
                "<L? 1 10>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RTRUE");

            await AssertRoutine("",
                "<G=? ,FALSE-VALUE ,TRUE-VALUE>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RFALSE");

            await AssertRoutine("",
                "<BTST <+ 64 32 8> <+ 32 8>>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RTRUE");

            await AssertRoutine("",
                "<BTST <+ 64 32 8> <+ 16 8>>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RFALSE");

            // varargs equality comparisons
            await AssertRoutine("",
                "<=? 50 10 <- 100 50> 100>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RTRUE");

            await AssertRoutine("",
                "<=? 49 10 <- 100 50> 100>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*RFALSE");

            // here we still have to call the function to get its side effect, but we can ignore its result
            await AssertRoutine("",
                "<=? 50 10 <- 100 50> <FOO>>")
                .WithGlobal("<FILE-FLAGS CLEAN-STACK?>")
                .WithGlobal("<ROUTINE FOO () 100>")
                .GeneratesCodeMatchingAsync(@"\.FUNCT TEST\?ROUTINE\r?\n\s*CALL FOO >STACK\r?\n\s*FSTACK\r?\n\s*RTRUE");

            // here we can't simplify the branch, because <FOO> might return 49, but we can skip testing the constants
            await AssertRoutine("",
                "<=? 49 10 <- 100 50> <FOO>>")
                .WithGlobal("<FILE-FLAGS CLEAN-STACK?>")
                .WithGlobal("<ROUTINE FOO () 100>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? 49,STACK (/TRUE|\\FALSE)");

            await AssertRoutine("",
                "<=? 49 1 <FOO> 2 <FOO> 3 <FOO> 4 <FOO> 5>")
                .WithGlobal("<FILE-FLAGS CLEAN-STACK?>")
                .WithGlobal("<ROUTINE FOO () 100>")
                .GeneratesCodeMatchingAsync(@"EQUAL\? 49(,(STACK|\?TMP(\?\d+)?)){3} /TRUE\r?\n\s*EQUAL\? 49,(STACK|\?TMP(\?\d+)?) (/TRUE|\\FALSE)");
        }

        [TestMethod]
        public async Task BAND_In_Predicate_Context_With_Power_Of_Two_Should_Be_Optimized()
        {
            await AssertRoutine("\"AUX\" X",
                "<COND (<BAND .X 4> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"BTST X,4 (/TRUE|\\FALSE)");

            await AssertRoutine("\"AUX\" X",
                "<COND (<BAND 4 .X> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"BTST X,4 (/TRUE|\\FALSE)");

            // BAND with zero is never true
            await AssertRoutine("\"AUX\" X",
                "<COND (<BAND 0 .X> <RTRUE>)>")
                .GeneratesCodeMatchingAsync("RFALSE");

            await AssertRoutine("\"AUX\" X",
                "<COND (<BAND .X 0> <RTRUE>)>")
                .GeneratesCodeMatchingAsync("RFALSE");

            // doesn't work with non-powers-of-two
            await AssertRoutine("\"AUX\" X",
                "<COND (<BAND .X 6> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"BAND X,6 >STACK\r?\n\s*ZERO\? STACK (\\TRUE|/FALSE)");
        }

        [TestMethod]
        public async Task Stacked_BAND_Or_BOR_Should_Collapse()
        {
            await AssertRoutine("\"AUX\" X",
                "<BAND 48 <BAND .X 96>>")
                .GeneratesCodeMatchingAsync("BAND X,32 >STACK");

            await AssertRoutine("\"AUX\" X",
                "<BOR <BOR 96 .X> 48>")
                .GeneratesCodeMatchingAsync("BOR X,112 >STACK");
        }

        [TestMethod]
        public async Task Predicate_Inside_BIND_Does_Not_Rely_On_PUSH()
        {
            await AssertRoutine("\"AUX\" X",
                "<COND (<BIND ((Y <* 2 .X>)) <G? .Y 123>> <RTRUE>)>")
                .GeneratesCodeMatchingAsync(@"GRTR\? Y,123 (/TRUE|\\FALSE)");
        }

        [TestMethod]
        public async Task POP_In_V6_Stores()
        {
            await AssertRoutine("\"AUX\" X",
                "<SET X <POP>>")
                .InV6()
                .GeneratesCodeMatchingAsync(@"POP >X");
        }

        [TestMethod]
        public async Task IndirectStore_From_Stack_In_V5_Uses_POP()
        {
            await AssertRoutine("\"AUX\" X",
                "<SETG .X <FOO>> <RTRUE>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .InV5()
                .GeneratesCodeMatchingAsync(@"POP X");
        }

        [TestMethod]
        public async Task IndirectStore_From_Stack_In_V6_Uses_SET()
        {
            await AssertRoutine("\"AUX\" X",
                "<SETG .X <FOO>> <RTRUE>")
                .WithGlobal("<ROUTINE FOO () <>>")
                .InV6()
                .GeneratesCodeMatchingAsync(@"SET X,STACK");
        }

        [TestMethod]
        public async Task OR_In_Value_Context_Avoids_Unnecessary_Value_Preservation()
        {
            await AssertRoutine("OBJ", @"
    <OR ;""We can always see the contents of surfaces""
            <FSET? .OBJ ,SURFACEBIT>
            ;""We can see inside containers if they're open, transparent, or
              unopenable (= always-open)""
            <AND <FSET? .OBJ ,CONTBIT>
                 <OR <FSET? .OBJ ,OPENBIT>
                     <FSET? .OBJ ,TRANSBIT>
                     <NOT <FSET? .OBJ ,OPENABLEBIT>>>>>")
                .WithGlobal("<CONSTANT SURFACEBIT 1>")
                .WithGlobal("<CONSTANT CONTBIT 2>")
                .WithGlobal("<CONSTANT OPENBIT 3>")
                .WithGlobal("<CONSTANT TRANSBIT 4>")
                .WithGlobal("<CONSTANT OPENABLEBIT 5>")
                .WhenCalledWith("<>")
                .GeneratesCodeNotMatchingAsync(@"\?TMP");
        }

        [TestMethod]
        public async Task AND_In_Value_Context_Avoids_Unnecessary_Value_Preservation()
        {
            await AssertRoutine("OBJ", @"
    <AND ;""We can always see the contents of surfaces""
            <FSET? .OBJ ,SURFACEBIT>
            ;""We can see inside containers if they're open, transparent, or
              unopenable (= always-open)""
            <AND <FSET? .OBJ ,CONTBIT>
                 <OR <FSET? .OBJ ,OPENBIT>
                     <FSET? .OBJ ,TRANSBIT>
                     <NOT <FSET? .OBJ ,OPENABLEBIT>>>>>")
                .WithGlobal("<CONSTANT SURFACEBIT 1>")
                .WithGlobal("<CONSTANT CONTBIT 2>")
                .WithGlobal("<CONSTANT OPENBIT 3>")
                .WithGlobal("<CONSTANT TRANSBIT 4>")
                .WithGlobal("<CONSTANT OPENABLEBIT 5>")
                .WhenCalledWith("<>")
                .GeneratesCodeNotMatchingAsync(@"\?TMP");
        }

        [TestMethod]
        public async Task ZREST_With_Constant_Table_Uses_Assembler_Math()
        {
            await AssertRoutine("", "<REST ,MY-TABLE 2>")
                .WithGlobal("<CONSTANT MY-TABLE <TABLE 1 2 3 4>>")
                .GeneratesCodeMatchingAsync(@"MY-TABLE\+2");
        }

        [TestMethod]
        public async Task VALUE_VARNAME_Does_Not_Use_An_Instruction()
        {
            await AssertRoutine("", "<VALUE MY-GLOBAL>")
                .WithGlobal("<GLOBAL MY-GLOBAL 123>")
                .GeneratesCodeMatchingAsync("RETURN MY-GLOBAL");
        }

        [TestMethod, TestCategory("NEW-PARSER?")]
        public async Task Words_Containing_Hash_Sign_Compile_Correctly_With_New_Parser()
        {
            await AssertRoutine("", @"<PRINTB ,W?\#FOO>")
                .WithGlobal(VocabTests.SNewParserBootstrap)
                .WithGlobal(@"<SYNTAX \#FOO = V-FOO>")
                .WithGlobal("<ROUTINE V-FOO () <>>")
                .OutputsAsync("#foo");
        }

        [TestMethod]
        public async Task Words_Containing_Hash_Sign_Compile_Correctly_With_Old_Parser()
        {
            await AssertRoutine("", @"<PRINTB ,W?\#FOO>")
                .WithGlobal(@"<SYNTAX \#FOO = V-FOO>")
                .WithGlobal("<ROUTINE V-FOO () <>>")
                .OutputsAsync("#foo");
        }

        [TestMethod]
        public async Task Properties_Containing_Backslash_Compile_Correctly()
        {
            await AssertRoutine("", @"<PRINTN <GETP ,OBJ ,P?FOO\\BAR>>")
                .WithGlobal(@"<OBJECT OBJ (FOO\\BAR 123)>")
                .OutputsAsync("123");
        }

        [TestMethod]
        public async Task Instructions_With_Debug_Line_Info_Should_Not_Be_Duplicated()
        {
            const string ArgSpec =
                @"""OPT"" W PS (P1 -1) ""AUX"" F";
            const string Body = @"
                <COND (<0? .W> <RFALSE>)>
                <SET F <GETB .W ,VOCAB-FL>>
                <SET F <COND (<BTST .F .PS>
                              <COND (<L? .P1 0>
                                     <RTRUE>)
                                    (<==? <BAND .F ,P1MASK> .P1>
                                     <GETB .W ,VOCAB-V1>)
                                    (ELSE <GETB .W ,VOCAB-V2>)>)>>
                .F";

            await AssertRoutine(ArgSpec, Body)
                .WithGlobal("<CONSTANT P1MASK 255>")
                .WithGlobal("<CONSTANT VOCAB-FL 1>")
                .WithGlobal("<CONSTANT VOCAB-V1 2>")
                .WithGlobal("<CONSTANT VOCAB-V2 3>")
                .WithDebugInfo()
                .GeneratesCodeMatchingAsync(@"\.DEBUG-LINE")
                .AndNotMatching(@"(\.DEBUG-LINE ([^\r\n]*)\r?\n).*\1");
        }

        [TestMethod]
        public async Task Local_Variable_Initializers_Should_Have_Debug_Line_Info()
        {
            const string ArgSpec = @"""OPT"" (A <FOO>) ""AUX"" (B <FOO>)";
            const string Body = @"<>";

            await AssertRoutine(ArgSpec, Body)
                .InV5()
                .WithGlobal("<ROUTINE FOO () <>>")
                .WithDebugInfo()
                .GeneratesCodeMatchingAsync(@"\.DEBUG-LINE ([^\r\n]*)\r?\n\s*ASSIGNED\? 'A")
                .AndMatching(@"\.DEBUG-LINE ([^\r\n]*)\r?\n\s*(\S+:\s*)?CALL1 FOO >B");
        }
    }
}
