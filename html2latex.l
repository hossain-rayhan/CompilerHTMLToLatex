
/*Name: Rayhan Hossain
NedId: rhossai2
Course: COSC461-Compilers
Assignment: PA_2
Date: 09-22-2017*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int list_type;
%}

%option       noyywrap nounput yylineno
%x            COMMENT PARA PRE OL UL LI

%%

"<!--" {
    /**************************************************************************
     * Matched an HTML comment so print it out as a LateX comment. The
     * beginning and ending tags are stripped off before the LateX comment
     * is emitted.
     *************************************************************************/
    printf( "%% " );
    BEGIN COMMENT;
}

<COMMENT>"-->" {
    /**************************************************************************
     * Matched an HTML end comment while parsing an HTML comment. Print out
     * a new line and resume normal parsing.
     *************************************************************************/
    printf( "\n" );
    BEGIN 0;
}

<COMMENT>[\n](\r)? {
    /**************************************************************************
     * Matched a newline while parsing an HTML comment. Print out a new
     * line making sure to mark the next line as a comment as well.
     *************************************************************************/
    printf( "\n%% " );
}

<COMMENT>[ \t] {
    /**************************************************************************
     * Matched some white space while parsing an HTML comment. Print out
     * the white space as is.
     *************************************************************************/
    printf( "%s", yytext );
}

<COMMENT>. {
    /**************************************************************************
     * Matched any other text while parsing an HTML comment. Print out
     * the text as is.
     *************************************************************************/
    printf( "%s", yytext );
}



"<ul>" {
//Replacing the functionalities of ul
printf("\\begin{itemize}\n");
}

"</ul>" {
printf("\\end{itemize}\n");
}

"<ol>" {
//Replacing the functionalities of ol
printf("\\begin{enumerate}\n");
}

"</ol>" {
printf("\\end{enumerate}\n");
}

"<li>" {
//Replacing the functionalities of li
printf("\\item ");
}

"</li>" {
printf("\n");
}

"<p>" {
//Replacing the functionalities of p
printf( "\n");
}

"</p>" {
//Replacing the functionalities of p
printf( "\n" );
}

"<big>" {
//Replacing the functionalities of big
printf( "{\\Large " );
}

"</big>" {
printf( "}");
}

"<small>" {
//Replacing the functionalities of small
 printf( "{\\scriptsize ");
}

"</small>" {
 printf( "}");
}

"<b>" {
//Replacing the functionalities of b
printf( "\\textbf{");
}

"</b>" {
printf( "} " );
}

"<i>" {
//Replacing the functionalities of i
 printf( "\\textit {");
}
"</i>" {
 printf( "}");
}

"<strong>" {
//Replacing the functionalities of strong
printf( "\\textmd{");
}
"</strong>" {
 printf( "}");
}
"<em>" {
 printf( "\\emph{");
}
"</em>" {
printf( "} " );
}

"<sup>" {
//Replacing the functionalities of sup
printf( "\\textsuperscript{");
}
"</sup>" {
printf( "} ");
}
"<sub>" {
//Replacing the functionalities of sub
printf( "\\textsubscript{");
}
"</sub>" {
printf( "} ");
}

"<h1>"[^<]*"</h1>" {
    yytext[yyleng-5] = 0;
    printf( "\\section{%s}", yytext+4 );
}

"<h2>"[^<]*"</h2>" {
    yytext[yyleng-5] = 0;
    printf( "\\subsection{%s}", yytext+4 );
}

"<h3>"[^<]*"</h3>" {
    yytext[yyleng-5] = 0;
    printf( "\\subsubsection{%s}", yytext+4 );
}

"<pre>"[^<]*"</pre>" {
    yytext[yyleng-6] = 0;
    printf( "\\begin{verbatim}\n%s\n\\end{verbatim}\n", yytext+5 );
}
%%

/**************************************************************************
 * The main function for the HTML to LateX converter. Here we do three
 * things:
 *  1. Print out the LateX document header.
 *  2. Invoke the lexer to print out the LateX document
 *  3. Print out the LateX footer.
 *************************************************************************/
int main( int argc, const char *argv[] ) {
    printf( "\\documentclass[12pt]{article}\n" );
    printf( "\\usepackage{fixltx2e}\n" );
    printf( "\n" );
    printf( "\\setlength{\\parindent}{0.0in}\n" );
    printf( "\\setlength{\\parskip}{0.125in}\n" );
    printf( "\n\n" );
    printf( "\\begin{document}\n" );
    yylex();
    printf( "\\end{document}\n" );
    return 0;
}
