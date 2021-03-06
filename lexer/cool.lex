/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();
    private int curr_strLen = 0;

    // For detecting unmatched "(*" symbols
    private int num_nested_comments = 0;


    // For keeping track of line number
    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    	case YYINITIAL:
		/* nothing special to do in the initial state */
		break;
    	case BLOCK_COMMENT:
		yybegin(YYINITIAL);
		return new Symbol(TokenConstants.ERROR, "EOF in comment");
	case STRING:
		yybegin(YYINITIAL);
		return new Symbol(TokenConstants.ERROR, "EOF in string constant");
	case BAD_STRING:
		yybegin(YYINITIAL);
		return new Symbol(TokenConstants.ERROR, "EOF in string constant");
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup

digit = [0-9]
integer = {digit}+
lower = [a-z]
upper = [A-Z]
anyChar = {lower}|{upper}

typeIdentifier = {upper}({anyChar}|{digit}|_)*
objectIdentifier = {lower}({anyChar}|{digit}|_)*

inputChar = [^\r\n]
lineTerminator = [\n\r\013\015]|(\r\n)
whiteSpace = {lineTerminator}|[\ \t\f\v]

inlineComment = "--"{inputChar}*
commentBegin = "(*"
commentEnd = "*)"

quotes = "\""
strEscapes = \\.
legalLineBreak = \\{lineTerminator}

classKeyword = [Cc][Ll][Aa][Ss][Ss]
elseKeyword = [Ee][Ll][Ss][Ee]
falseKeyword = [f][Aa][Ll][Ss][Ee]
fiKeyword = [Ff][Ii]
ifKeyword = [Ii][Ff]
inKeyword = [Ii][Nn]
inheritsKeyword = [Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss]
isvoidKeyword = [Ii][Ss][Vv][Oo][Ii][Dd]
letKeyword = [Ll][Ee][Tt]
loopKeyword = [Ll][Oo][Oo][Pp]
poolKeyword = [Pp][Oo][Oo][Ll]
thenKeyword = [Tt][Hh][Ee][Nn]
whileKeyword = [Ww][Hh][Ii][Ll][Ee]
caseKeyword = [Cc][Aa][Ss][Ee]
esacKeyword = [Ee][Ss][Aa][Cc]
newKeyword = [Nn][Ee][Ww]
ofKeyword = [Oo][Ff]
notKeyword = [Nn][Oo][Tt]
trueKeyword = [t][Rr][Uu][Ee]

%state BLOCK_COMMENT
%state STRING
%state BAD_STRING

%%

<YYINITIAL>"=>" 			{ return new Symbol(TokenConstants.DARROW); }
<YYINITIAL>"(" 				{ return new Symbol(TokenConstants.LPAREN); }
<YYINITIAL>")"	 			{ return new Symbol(TokenConstants.RPAREN); }
<YYINITIAL>"{" 				{ return new Symbol(TokenConstants.LBRACE); }
<YYINITIAL>"}" 				{ return new Symbol(TokenConstants.RBRACE); }
<YYINITIAL>"." 				{ return new Symbol(TokenConstants.DOT); }
<YYINITIAL>"," 				{ return new Symbol(TokenConstants.COMMA); }
<YYINITIAL>"~"				{ return new Symbol(TokenConstants.NEG); }
<YYINITIAL>"<-" 			{ return new Symbol(TokenConstants.ASSIGN); }
<YYINITIAL>";" 				{ return new Symbol(TokenConstants.SEMI); }
<YYINITIAL>":" 				{ return new Symbol(TokenConstants.COLON); }
<YYINITIAL>"+" 				{ return new Symbol(TokenConstants.PLUS); }
<YYINITIAL>"-" 				{ return new Symbol(TokenConstants.MINUS); }
<YYINITIAL>"/" 				{ return new Symbol(TokenConstants.DIV); }
<YYINITIAL>"*"	 			{ return new Symbol(TokenConstants.MULT); }
<YYINITIAL>"=" 				{ return new Symbol(TokenConstants.EQ); }
<YYINITIAL>"<" 				{ return new Symbol(TokenConstants.LT); }
<YYINITIAL>"<=" 			{ return new Symbol(TokenConstants.LE); }
<YYINITIAL>"@"				{ return new Symbol(TokenConstants.AT); }

<YYINITIAL>{classKeyword}		{ return new Symbol(TokenConstants.CLASS); }
<YYINITIAL>{elseKeyword}		{ return new Symbol(TokenConstants.ELSE); }
<YYINITIAL>{falseKeyword}		{ return new Symbol(TokenConstants.BOOL_CONST, false); }
<YYINITIAL>{fiKeyword}			{ return new Symbol(TokenConstants.FI); }
<YYINITIAL>{ifKeyword}			{ return new Symbol(TokenConstants.IF); }
<YYINITIAL>{inKeyword}			{ return new Symbol(TokenConstants.IN); }
<YYINITIAL>{inheritsKeyword}		{ return new Symbol(TokenConstants.INHERITS); }
<YYINITIAL>{isvoidKeyword}		{ return new Symbol(TokenConstants.ISVOID); }
<YYINITIAL>{letKeyword}			{ return new Symbol(TokenConstants.LET); }
<YYINITIAL>{loopKeyword}		{ return new Symbol(TokenConstants.LOOP); }
<YYINITIAL>{poolKeyword}		{ return new Symbol(TokenConstants.POOL); }
<YYINITIAL>{thenKeyword}		{ return new Symbol(TokenConstants.THEN); }
<YYINITIAL>{whileKeyword}		{ return new Symbol(TokenConstants.WHILE); }
<YYINITIAL>{caseKeyword}		{ return new Symbol(TokenConstants.CASE); }
<YYINITIAL>{esacKeyword}		{ return new Symbol(TokenConstants.ESAC); }
<YYINITIAL>{newKeyword}			{ return new Symbol(TokenConstants.NEW); }
<YYINITIAL>{ofKeyword}			{ return new Symbol(TokenConstants.OF); }
<YYINITIAL>{notKeyword}			{ return new Symbol(TokenConstants.NOT); }
<YYINITIAL>{trueKeyword}		{ return new Symbol(TokenConstants.BOOL_CONST, true); }

<YYINITIAL>{integer}				
{
	AbstractSymbol intSymbol = AbstractTable.inttable.addString(yytext());
	return new Symbol(TokenConstants.INT_CONST, intSymbol);
}

<YYINITIAL>{typeIdentifier}		
{
	AbstractSymbol stringSymbol = AbstractTable.idtable.addString(yytext());
	return new Symbol(TokenConstants.TYPEID, stringSymbol);
}

<YYINITIAL>{objectIdentifier}	
{
	AbstractSymbol stringSymbol = AbstractTable.idtable.addString(yytext());
	return new Symbol(TokenConstants.OBJECTID, stringSymbol);
}

<YYINITIAL>{whiteSpace}
{ 	
	if(yytext().equals("\n")){
		curr_lineno++;
	}
}

<YYINITIAL>{inlineComment}			
{ 
//	ignore
}

<YYINITIAL, BLOCK_COMMENT>{commentBegin}			
{ 
	num_nested_comments++;
	yybegin(BLOCK_COMMENT);
}

<YYINITIAL>{quotes} 				
{ 
	yybegin(STRING); 
	if (string_buf.length() > 0) string_buf.delete(0, string_buf.length());
	curr_strLen = 0; 
}

<STRING>{quotes}			
{
	yybegin(YYINITIAL); 
	AbstractSymbol stringSymbol = AbstractTable.stringtable.addString(string_buf.toString());
	return new Symbol(TokenConstants.STR_CONST, stringSymbol);
}

<BAD_STRING>{quotes}
{
	yybegin(YYINITIAL);
}

<BAD_STRING>{legalLineBreak}
{
	curr_lineno++;	
}

<BAD_STRING>{lineTerminator}
{
	yybegin(YYINITIAL);
	curr_lineno++;
}

<BAD_STRING>.
{
	// ignore
}

<STRING>\\\0
{
	yybegin(BAD_STRING);
	return new Symbol(TokenConstants.ERROR, "String contains null character");
}

<STRING>{strEscapes}
{
	curr_strLen++;
	if (curr_strLen >= MAX_STR_CONST ) {
		yybegin(BAD_STRING);
		return new Symbol(TokenConstants.ERROR, "String constant too long");
	}
	if (yytext().equals("\\n")) {
		string_buf.append('\n');
	} else if (yytext().equals("\\t")) {
		string_buf.append('\t');
	} else if (yytext().equals("\\f")) {
		string_buf.append('\f');
	} else if (yytext().equals("\\b")) {
		string_buf.append('\b');
	} else {
		string_buf.append(yytext().substring(1));
	}
}

<STRING>{legalLineBreak}
{
	curr_lineno++;	
	curr_strLen++;
	if (curr_strLen >= MAX_STR_CONST ) {
		yybegin(BAD_STRING);
		return new Symbol(TokenConstants.ERROR, "String constant too long");
	}
	string_buf.append('\n');
}

<STRING>{lineTerminator}
{
	curr_lineno++;
	yybegin(YYINITIAL);
	return new Symbol(TokenConstants.ERROR, "Unterminated string constant");
}

<STRING>.
{
	curr_strLen++;
	string_buf.append(yytext());
	if (curr_strLen >= MAX_STR_CONST) {
		yybegin(BAD_STRING);
		return new Symbol(TokenConstants.ERROR, "String constant too long");
	}
}

<BLOCK_COMMENT>{commentEnd}
{
	num_nested_comments--;
	if (num_nested_comments == 0) yybegin(YYINITIAL); 
}

<YYINITIAL>{commentEnd}
{
	return new Symbol(TokenConstants.ERROR, "Unmatched *)");
}

<BLOCK_COMMENT>{lineTerminator}
{
	curr_lineno++;
}

<YYINITIAL>.               		{ return new Symbol(TokenConstants.ERROR, yytext()); }

<BLOCK_COMMENT>. 			
{
	// ignore
}
