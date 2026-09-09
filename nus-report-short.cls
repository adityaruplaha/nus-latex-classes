\ProvidesClass{nus-report-short}[2026/09/10 v1.0 Shortened university report format, NUS defaults]
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

\LoadClass[10pt]{article}
\RequirePackage[utf8]{inputenc}
\RequirePackage{csquotes}
\RequirePackage[english]{babel}
\RequirePackage{geometry,graphicx,wrapfig,indentfirst,setspace}
% Need python Pygments and --shell-escape flag
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{booktabs}
\RequirePackage{fancyhdr,lastpage}
\RequirePackage{hyperref}
% Loaded here, as nus-report.cls does, even though this class does not use
% titling's \thetitle. titling appends a one-argument wrapper to \title, which
% would clobber the optional short-title argument defined below. Requiring it
% now makes a document's own \usepackage{titling} a no-op, so the definitions
% below stay in force whatever the document loads.
\RequirePackage{titling}
\RequirePackage{titlesec}
\RequirePackage{caption,subcaption}
\RequirePackage{multirow}
\RequirePackage{lastpage}

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

% Encodings
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
% optional argument was omitted. Shared by \title, \author, \setdeptname and
% \setcoursename so that a document that supplies no short form behaves exactly
% as before.
\newcommand{\nusr@setshort}[3]{%
  \def\nusr@tmp{#2}%
  \ifx\nusr@tmp\@empty
    \gdef#1{#3}%
  \else
    \gdef#1{#2}%
  \fi
}

% \setdeptname[<short>]{<full>}
% The full name appears in the first-page title block. The short one goes in the
% running header, where it shares a line with the course name and the logo.
\newcommand{\deptname}{DSDS}
\newcommand{\shortdeptname}{DSDS}
\newcommand{\setdeptname}[2][]{%
  \gdef\deptname{#2}%
  \nusr@setshort{\shortdeptname}{#1}{#2}%
}

% \setcoursename[<short>]{<full>}
% As above: full name in the title block, short name in the running header.
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
\hypersetup{
  colorlinks = true,
  urlcolor = blue,
  citecolor = magenta,
  linkcolor = orange
}

\geometry{
  a4paper,
  hmargin=0.85in,
  vmargin=0.65in,
  head=3em,
  includeheadfoot
}

\setlength{\parindent}{0pt}
\setlength{\parskip}{4pt}
\setlength{\headheight}{40pt}
\setlength{\tabcolsep}{4pt}
\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\footrulewidth}{0.5pt}

\titlespacing*{\section}{0pt}{0.8\baselineskip}{0.5\baselineskip}
\titlespacing*{\subsection}{0pt}{0.5\baselineskip}{0.35\baselineskip}

% \author[<short>]{<full>}
% The full form appears in the first-page title block. The optional short form
% is used wherever a single short line is needed, currently the page footer, and
% defaults to the full form when omitted, so existing single-author documents
% are unaffected.
%
% Separate authors with \and, as in standard LaTeX. This class does not build
% the tabular that article's \@maketitle uses -- it suppresses \maketitle
% entirely -- so article's own \and would break the title block; it is given the
% meaning appropriate to each place the author list is typeset. Both places here
% are single lines, so \and is a comma in each.
% The optional argument is layered on top of the existing \title and \author
% rather than replacing them, so whatever titling has already wrapped around
% them still runs and \thetitle and \theauthor keep being set for documents that
% use them -- several assignments name \theauthor in their declaration block.
\gdef\@shortauthor{}
\let\nusr@origauthor\author
\renewcommand{\author}[2][]{%
  \nusr@origauthor{#2}%
  \nusr@setshort{\@shortauthor}{#1}{#2}%
}

% \title[<short>]{<full>}
% The full title heads the first page. The short one goes in the running header,
% whose left box is only 0.4\textwidth wide and sits beside the university
% block, so a long title wraps into it.
\gdef\@shorttitle{}
\let\nusr@origtitle\title
\renewcommand{\title}[2][]{%
  \nusr@origtitle{#2}%
  \nusr@setshort{\@shorttitle}{#1}{#2}%
}

\fancypagestyle{firstpage}{
  \fancyhead{}
  \fancyhead[L]{
    \large{\textit{{\reporttype}} \hspace{10pt} \\[0.2\baselineskip]
      \Large{\textbf{\@title}} \\[0.5\baselineskip]
      \headrule
      \vspace{0.7em}
      \small \textit{Author(s):} {\renewcommand{\and}{\unskip, }\@author} \\[0.2\baselineskip]
      \small \textit{Advisor/Instructor:} \advisor, \advisordesg \\
    \small {\textit{Course:} \coursename} --- {\deptname} --- {\uniname}}
    \vspace{0.7em}
  }
  \fancyhead[R]{
    \includegraphics[height=4em]{\uniimg}
    \vspace{0.4em}
  }
  \fancyfoot{}
  \fancyfoot[L]{\scriptsize {\mydate\@date}}
  \fancyfoot[C]{\scriptsize {\thepage} / \pageref*{LastPage}}
  \fancyfoot[R]{\scriptsize {\renewcommand{\and}{\unskip, }\@shortauthor}}
}
\fancypagestyle{subsequentpages}{
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
  \fancyfoot[C]{\scriptsize {\thepage} / \pageref*{LastPage}}
  \fancyfoot[R]{\scriptsize {\renewcommand{\and}{\unskip, }\@shortauthor}}
}
\AtBeginDocument{\thispagestyle{firstpage}\vspace*{2.5em}}
\pagestyle{subsequentpages}

\renewcommand{\maketitle}{}
