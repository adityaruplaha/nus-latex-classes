% nus-cheatsheet.cls -- dense, multi-column crib sheets for closed-book exams.
%
% Usage:
%   \documentclass[cols=3, size=6.5]{nus-cheatsheet}
%   \title{ST6101 --- Midterm} \subtitle{Lectures 1--6} \author{Name} \date{30 Sep 2026}
%   \begin{document}
%   \begin{cheatsheet}
%     \section{...}
%     \begin{entry}{Result} text ... \sub{Related result} text ... \end{entry}
%   \end{cheatsheet}
%   \end{document}
%
% Options (key=value):
%   cols=<n>        number of columns per page (default 3)
%   size=<pt>       body font size in pt (default 6.5)
%   leading=<x>     baselineskip as a multiple of size (default 1.2)
%   margin=<len>    page margin on all sides (default 5mm)
%   landscape       landscape A4
%   norules         no vertical rules between columns
%   breakboxes      let entry boxes split across columns and pages (default: never split)
%   pages=<n>       page budget; a warning is issued at \end{document} if exceeded (default 2)

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nus-cheatsheet}[2026/09/29 Dense multi-column exam cheatsheet]

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=cs, prefix=cs@}
\DeclareStringOption[3]{cols}
\DeclareStringOption[6.5]{size}
\DeclareStringOption[5mm]{margin}
\DeclareStringOption[2]{pages}
\DeclareStringOption[1.2]{leading}
\DeclareBoolOption{landscape}
\DeclareBoolOption{norules}
\DeclareBoolOption{breakboxes}
\ProcessKeyvalOptions*

\LoadClass[8pt, a4paper]{extarticle}

% ---------- Page and fonts ----------
\ifcs@landscape
  \RequirePackage[a4paper, landscape, margin=\cs@margin, includehead, headheight=15pt, headsep=3pt]{geometry}
\else
  \RequirePackage[a4paper, margin=\cs@margin, includehead, headheight=15pt, headsep=3pt]{geometry}
\fi
\RequirePackage[T1]{fontenc}
\RequirePackage{newtxtext}
% sensible-math (personal texmf) supplies \Expec, \Prob, \dif, ...; fall back to the AMS set without it
\IfFileExists{sensible-math.sty}
  {\RequirePackage{sensible-math}}
  {\RequirePackage{amsmath, amssymb, amsthm}}
% newtxmath redefines symbols that amssymb and amsthm already provide
\let\Bbbk\relax
\let\openbox\relax
\RequirePackage{newtxmath}
\RequirePackage{microtype}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{multicol}
\RequirePackage{ragged2e}
\RequirePackage[explicit]{titlesec}
\RequirePackage{enumitem}
\RequirePackage{mathtools}
\RequirePackage{array, tabularx, booktabs}
\RequirePackage[hidelinks]{hyperref}

\newcommand*{\cs@fontsize}{%
  \fontsize{\cs@size pt}{\fpeval{round(\cs@leading*\cs@size, 2)}pt}\selectfont}
\AtBeginDocument{\cs@fontsize}

\setlength{\parindent}{0pt}
\setlength{\parskip}{2pt plus 1pt}
\setlength{\columnsep}{4mm}
\ifcs@norules
  \setlength{\columnseprule}{0pt}
\else
  \setlength{\columnseprule}{0.2pt}
  \def\columnseprulecolor{\color{black!35}}
\fi
% Flush columns: each column is stretched to full height, and since the only
% stretch is in the gaps between boxes (and above section bars), the spare
% height is shared out evenly between them. The stretch is kept small on
% purpose: large stretch changes where multicols breaks columns and costs space;
% TeX stretches past the nominal amount anyway, so the columns still end flush.
\vbadness=10000
\flushcolumns

% Tight display maths
\AtBeginDocument{%
  \setlength{\abovedisplayskip}{3pt plus 1pt}%
  \setlength{\belowdisplayskip}{3pt plus 1pt}%
  \setlength{\abovedisplayshortskip}{1pt plus 1pt}%
  \setlength{\belowdisplayshortskip}{2pt plus 1pt}%
  \setlength{\jot}{2pt}}
\setlength{\arraycolsep}{3pt}
\setlength{\tabcolsep}{3pt}
\renewcommand{\arraystretch}{1.25}

% ---------- Headings ----------
\definecolor{csaccent}{HTML}{003D7C} % NUS blue
\definecolor{cssub}{HTML}{EF7C00}    % NUS orange
% Section bar: numbered, with the number in an orange badge at the left end;
% title in real small caps (TeX Gyre Heros has a bold sc shape).
\setcounter{secnumdepth}{1}
\newlength{\cs@barheight}
\titleformat{\section}
  {\normalfont\bfseries\sffamily\color{white}}
  {}{0pt}
  {\setlength{\cs@barheight}{\dimexpr\baselineskip+4pt\relax}%
   \setlength{\fboxsep}{0pt}%
   \colorbox{csaccent}{\parbox[c]{\linewidth}{%
     \colorbox{cssub}{\parbox[c][\cs@barheight][c]{2em}{\centering\thesection}}%
     \hspace{0.5em}%
     % a title too long for one line grows the bar rather than being clipped or hyphenated
     \parbox[c]{\dimexpr\linewidth-2.5em\relax}{\RaggedRight\hyphenpenalty=10000\exhyphenpenalty=10000
       \strut\scshape #1\strut}}}}
\titlespacing*{\section}{0pt}{6pt plus 2pt}{3pt}
\titleformat{\subsection}[runin]
  {\normalfont\bfseries\color{csaccent}}{}{0pt}{#1.}
\titlespacing*{\subsection}{0pt}{3pt}{0.4em}

% Entries. Each result sits in its own box so boundaries are visible at a glance:
%   \begin{entry}{Fatou} statement ... \end{entry}
% Boxes never split across columns unless the breakboxes option is given.
% An empty title gives an untitled box. \sub{...} is a run-in heading for use inside a box.
\RequirePackage[most]{tcolorbox}
\ifcs@breakboxes
  \tcbset{cs@break/.style={breakable}}
\else
  \tcbset{cs@break/.style={}}
\fi
\newtcolorbox{entry}[1]{%
  enhanced jigsaw, cs@break, sharp corners,
  colback=white, colframe=csaccent!55, boxrule=0.4pt,
  left=2pt, right=2pt, top=0.8pt, bottom=0.8pt, boxsep=0pt,
  before skip=1.2pt plus 2pt, after skip=1.2pt plus 2pt,
  before upper={\RaggedRight\parskip=1.5pt\ifx\relax#1\relax\else\textbf{\color{csaccent}#1.}\ \fi}}
\newcommand*{\sub}[1]{\textbf{\color{csaccent}#1.}\ \ignorespaces}
% Keyword emphasis and warnings
\newcommand*{\kw}[1]{\textbf{#1}}
\newcommand*{\warn}[1]{{\color{BrickRed}\textbf{!}\,#1}}
% Inline tags: a bold label on a subtle background.
\definecolor{csscarlet}{HTML}{E3170A}
\definecolor{cspfbg}{HTML}{FFF2A8}
\newcommand*{\cs@tag}[3]{{\setlength{\fboxsep}{0.7pt}\colorbox{#1}{\textcolor{#2}{\textbf{#3}}}}\,}
% Counterexample marker
\newcommand*{\cex}{\cs@tag{csscarlet!14}{csscarlet!85!black}{CE}}
% Proof-idea marker
\newcommand*{\pf}{\cs@tag{cspfbg}{cssub!80!black}{Pf}}
% Implication arrow used in running text
\newcommand*{\imp}{\Rightarrow}

\setlist{nosep, leftmargin=1.9em, labelsep=0.3em, topsep=0.5pt, itemsep=0.8pt}
\setlist[itemize]{label=\textcolor{csaccent}{\tiny$\blacktriangleright$}}

% ---------- Running header ----------
% A bar on every page: title and subtitle on the left; author, date and page x/y on the right.
% Set with the standard \title and \author, plus \subtitle (optional); \date defaults to the compile date.
% \maketitle is not needed and does nothing.
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\newcommand*{\cs@subtitle}{}
\newcommand*{\subtitle}[1]{\renewcommand*{\cs@subtitle}{#1}}
\renewcommand*{\maketitle}{}
% Default date: the compile date, day month year
\date{\number\day\space\ifcase\month\or January\or February\or March\or April\or May\or June\or July\or August\or September\or October\or November\or December\fi\space\number\year}
\newcommand*{\cs@sep}{\hspace{0.6em}{\color{white!55!csaccent}|}\hspace{0.6em}}
\newcommand*{\cs@header}{%
  \setlength{\fboxsep}{0pt}%
  \colorbox{csaccent}{\parbox[c][14pt][c]{\headwidth}{%
    \fontsize{8}{9.6}\selectfont\sffamily\color{white}%
    \hspace{4pt}\textbf{\@title}%
    \ifx\cs@subtitle\@empty\else\cs@sep\cs@subtitle\fi
    \hfill
    \textbf{\@author}\cs@sep\@date\hspace{0.6em}%
    \colorbox{cssub}{\parbox[c][14pt][c]{3.6em}{\centering\bfseries\thepage\,/\,\pageref*{LastPage}}}}}}
\fancypagestyle{cheatsheet}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \fancyhead[C]{\cs@header}}
\pagestyle{cheatsheet}

\newenvironment{cheatsheet}
  {\begin{multicols*}{\cs@cols}\RaggedRight}
  {\end{multicols*}}

% ---------- Page budget check ----------
\AtEndDocument{%
  \clearpage
  \ifnum\numexpr\value{page}-1\relax>\cs@pages\relax
    \ClassWarningNoLine{nus-cheatsheet}{Cheatsheet runs to \the\numexpr\value{page}-1\relax\space pages, over the budget of \cs@pages}%
  \fi}

\endinput
