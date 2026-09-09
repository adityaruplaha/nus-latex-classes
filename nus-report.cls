\ProvidesClass{nus-report}[2026/09/10 v1.0 University report format, NUS defaults]
%%
%% Copyright (c) 2026, Adityarup Laha
%% All rights reserved.
%%
%% Licensed under the BSD 3-Clause License. See the LICENSE file in the project
%% root for the full text.
%%
%% The university logo referenced by \uniimg is NOT part of this work and is
%% not distributed with it. See README.md.
%%

\LoadClass{article}
\RequirePackage[utf8]{inputenc}
\RequirePackage{csquotes}
\RequirePackage[english]{babel}
\RequirePackage{geometry,graphicx,wrapfig,indentfirst,setspace}
% Need python Pygments and --shell-escape flag
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{anyfontsize}
\RequirePackage{booktabs}
\RequirePackage{fancyhdr,lastpage}
\RequirePackage{hyperref}
\RequirePackage{titling}
\RequirePackage{titlesec}
\RequirePackage{caption,subcaption}
\RequirePackage{multirow}

\newcommand{\Month}{
  \ifcase \THEMONTH
  \or January
  \or February
  \or March
  \or April
  \or May
  \or June
  \or July
  \or August
  \or September
  \or October
  \or November
  \or December
  \fi
}

\RequirePackage[nodayofweek]{datetime}
\newdateformat{mydate}{\twodigit{\THEDAY}{}\Month\THEYEAR}

% Allow setting >max< width of figure
% Remove if unneeded
\RequirePackage[export]{adjustbox} % 'export' allows adjustbox keys in \includegraphics

% Sub-preambles
% https://github.com/MartinScharrer/standalone

% Encodings & Math
\RequirePackage{amsmath,amssymb,amsfonts,amsthm,gensymb,textcomp}

% Better tables
% Wide tables go to https://tex.stackexchange.com/q/332902
\RequirePackage{array,multicol,multirow,siunitx,tabularx}

% Better enum
\RequirePackage{enumitem}

% Graphics
\RequirePackage{caption,float}
% SVG
\RequirePackage{svg}

\newcommand{\uniname}{National University of Singapore}
\newcommand{\setuniname}[1]{\renewcommand{\uniname}{#1}}

\newcommand{\uniimg}{common-assets/nus_logo.png}
\newcommand{\setuniimg}[1]{\renewcommand{\uniimg}{#1}}

% \nusr@setshort{<macro>}{<short>}{<full>}
% Stores the short form of a field, falling back to the full form when the
% optional argument was omitted. Shared by \title, \author and \setdeptname so
% that a document that supplies no short form behaves exactly as before.
\newcommand{\nusr@setshort}[3]{%
  \def\nusr@tmp{#2}%
  \ifx\nusr@tmp\@empty
    \gdef#1{#3}%
  \else
    \gdef#1{#2}%
  \fi
}

% \setdeptname[<short>]{<full>}
% The full name appears on the cover page, the short one in the running header,
% where it shares a line with the course name and must leave room for the logo.
\newcommand{\deptname}{DSDS}
\newcommand{\shortdeptname}{DSDS}
\newcommand{\setdeptname}[2][]{%
  \gdef\deptname{#2}%
  \nusr@setshort{\shortdeptname}{#1}{#2}%
}

% \setcoursename[<short>]{<full>}
% The full name appears on the cover page. The short one shares the running
% header's right-hand line with the department name and the university logo.
\newcommand{\coursename}{Course name}
\newcommand{\shortcoursename}{Course name}
\newcommand{\setcoursename}[2][]{%
  \gdef\coursename{#2}%
  \nusr@setshort{\shortcoursename}{#1}{#2}%
}

\newcommand{\reporttype}{Assignment Report}
\newcommand{\setreporttype}[1]{\renewcommand{\reporttype}{#1}}

\newcommand{\advisor}{Advisor}
\newcommand{\setadvisor}[1]{\renewcommand{\advisor}{#1}}

\newcommand{\advisordesg}{Advisor Designation}
\newcommand{\setadvisordesg}[1]{\renewcommand{\advisordesg}{#1}}

\newcommand\frontmatter{%
  \clearpage
  \pagenumbering{roman}
}

\newcommand\mainmatter{%
  \clearpage
  \pagenumbering{arabic}
}

\newcommand\backmatter{%
  \clearpage
}

\geometry{
  a4paper,
  vmargin=3cm,
  hmargin=2cm,
  head=3em,
  includeheadfoot
}
\hypersetup{
  colorlinks = true,
  urlcolor = blue,
  citecolor = magenta,
  linkcolor = orange
}

\setlength{\parindent}{0pt}
\setlength{\parskip}{7pt}
\setlength{\headheight}{40pt}
\setlength{\tabcolsep}{4pt}
\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\footrulewidth}{0.5pt}

% \author[<short>]{<full>}
% The full form is used on the cover page, where each author takes a line of
% their own. The optional short form is used wherever a single short line is
% needed, currently the page footer, and defaults to the full form when omitted,
% so existing single-author documents are unaffected.
%
% Separate authors with \and, as in standard LaTeX. This class does not build
% the tabular that article's \@maketitle uses, so article's own \and would break
% the cover page; it is instead given a meaning appropriate to each place the
% author list is typeset -- a line break on the cover, a comma in the footer.
% The optional argument is layered on top of the existing \title and \author
% rather than replacing them, so whatever titling has already wrapped around
% them still runs and \thetitle and \theauthor keep being set for documents that
% use them.
\gdef\@shortauthor{}
\let\nusr@origauthor\author
\renewcommand{\author}[2][]{%
  \nusr@origauthor{#2}%
  \nusr@setshort{\@shortauthor}{#1}{#2}%
}

% \title[<short>]{<full>}
% The full title is set on the cover page. The short one goes in the running
% header, whose left box is only 0.4\textwidth wide and sits beside the
% university block, so a long title wraps into it.
\gdef\@shorttitle{}
\let\nusr@origtitle\title
\renewcommand{\title}[2][]{%
  \nusr@origtitle{#2}%
  \nusr@setshort{\@shorttitle}{#1}{#2}%
}

\pagestyle{fancy}
% Titles and authors are taken from \@title and \@author, not from titling's
% \thetitle and \theauthor. titlesec, loaded above, claims \thetitle for its own
% section-title placeholder, so any document that triggers titlesec's sectioning
% machinery (a \tableofcontents is enough) would otherwise print the current
% section number in the running header instead of the report title.
\fancyhead{}
\fancyhead[L]{
  \parbox{0.4\textwidth}{\textbf{\reporttype} ---\\ \@shorttitle}
  \vspace{0.6em}
}
\fancyhead[R]{
  \newcommand{\arraystretchtemp}{\arraystretch}\renewcommand{\arraystretch}{1}
  \begin{tabular}{rr}
    \textbf{\uniname} & \multirow{2}{*}{\includegraphics[height=2.2em]{\uniimg}} \\
    {\shortdeptname} | {\shortcoursename} &
  \end{tabular}
  \renewcommand{\arraystretch}{\arraystretchtemp}
  \vspace{0.4em}
}

\fancyfoot{}
\fancyfoot[L]{\scriptsize {\mydate\@date}}
\fancyfoot[C]{\scriptsize {\thepage}}
\fancyfoot[R]{\scriptsize {\renewcommand{\and}{\unskip, }\@shortauthor}}

\renewcommand{\maketitle}{
  \thispagestyle{empty}

  \begin{center}
    \textbf{\Large \MakeUppercase{\uniname}}

    \vspace{0.3em}
    {\Large \MakeUppercase{\deptname}}
    \\[3.5\baselineskip]
    \includegraphics[width=0.35\textwidth]{\uniimg}
    \\[2.5\baselineskip]
    \begin{tabular}{c}
      \textbf{\Large \coursename}                          \\
      {}                                                    \\
      \toprule                                              \\
      {\Large \reporttype}                                 \\
      {}                                                    \\
      \textbf{\huge \parbox[c]{16cm}{\centering \@title}}   \\
      {}                                                    \\
      \bottomrule
    \end{tabular}\\
    \vspace{1.4em}
    {\large \mydate\@date}
    \vfill%
    {\large \textbf{\renewcommand{\and}{\unskip\\[1.2ex]}\@author}}
    \vfill%
    {\large \textit{Advisor/Instructor}}\\
    \vspace{0.5em}
    {\Large \textsc{\advisor}}\\
    \vspace{0.3em}
    {\large \textsc{\advisordesg}}
  \end{center}

  \clearpage
}
