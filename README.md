# nus-latex-classes

LaTeX document classes, a beamer theme, and a style package for university coursework, project reports, the talks that go with them, and exam cheatsheets. The report classes and the theme are for the kind of document that needs an institution's name and logo, a course code, an advisor, and a declaration block, rather than the journal apparatus that `article` and `report` assume.

Nothing here is tied to a particular university. The classes ship with defaults for the National University of Singapore because that is where they were written, and every institutional field is a one-line override. See [Using these elsewhere](#using-these-elsewhere).

| File | Purpose |
| --- | --- |
| `nus-report.cls` | Full report format with a separate cover page, front matter and a table of contents. For project reports and theses. |
| `nus-report-short.cls` | Compact format with no cover page: the title, authors, advisor and course appear as a block at the top of the first page. For homework sets and short assignments. |
| `nus-cheatsheet.cls` | Dense multi-column crib sheet for closed-book examinations that allow a page or two of notes. |
| `codespace.sty` | Code listings and algorithm environments, with the source file embedded in the PDF for download. |
| `nusbeamer/` | Presentation theme for `beamer`, taking the same metadata as the two report classes. For the talk that accompanies a report. |

The two report classes are independent — load one or the other, never both, and the cheatsheet class stands alone. Their `nus-` filenames are historical; the classes themselves are generic. The beamer theme is loaded by `beamer` itself, not alongside a class from this repository.

## Quick start

```latex
\documentclass{nus-report}          % or nus-report-short

\title[Short Title]{The Full Title of the Report}
\author[Team 1]{Ada LOVELACE \and Alan TURING}
\setdeptname[DSDS]{Department of Statistics and Data Science}
\setcoursename[ST0000]{ST0000 Introduction to Everything}
\setreporttype{Interim Report}
\setadvisor{Dr.\ Someone}
\setadvisordesg{Professor, DSDS}

\begin{document}
\maketitle          % draws the cover page; a no-op in nus-report-short
\frontmatter
\tableofcontents
\mainmatter
\section{Introduction}
...
\end{document}
```

## Short forms

Every field that appears in the running header or footer accepts an optional short form. The full form is used on the cover page — or, in `nus-report-short`, in the first-page title block — and the short form is used in the running header and footer, where space is tight and a long value will collide with the university block beside it.

| Command | Full form appears | Short form appears |
| --- | --- | --- |
| `\title[<short>]{<full>}` | Cover page / title block | Running header, left |
| `\author[<short>]{<full>}` | Cover page / title block | Page footer, right |
| `\setdeptname[<short>]{<full>}` | Cover page / title block | Running header, right |
| `\setcoursename[<short>]{<full>}` | Cover page / title block | Running header, right |

Omitting the optional argument makes the short form fall back to the full one, so documents written before short forms existed need no changes.

Separate multiple authors with `\and`, as in standard LaTeX. It renders as a line break where each author gets their own line, and as a comma where the list has to fit on one line.

## Other configuration

| Command | Default |
| --- | --- |
| `\setuniname{<name>}` | `National University of Singapore` |
| `\setuniimg{<path>}` | `common-assets/nus_logo.png` |
| `\setdeptname{<name>}` | `DSDS` |
| `\setcoursename{<name>}` | `Course name` |
| `\setreporttype{<type>}` | `Assignment Report` |
| `\setadvisor{<name>}` | `Advisor` |
| `\setadvisordesg{<designation>}` | `Advisor Designation` |

Both classes define `\frontmatter`, `\mainmatter` and `\backmatter`, which switch page numbering and start a new page, as in the `book` class.

## The presentation theme

`\usetheme{nus}` gives a deck the same institutional furniture as the two report classes, and takes the **same metadata commands**, so a project's report and its talk can share one metadata block and differ only in what `\setreporttype` is set to.

```latex
\documentclass[10pt,aspectratio=169]{beamer}

% Point \usetheme at the symlinked folder. See "Loading it from a folder".
\makeatletter
\def\beamer@calltheme#1#2#3{%
  \def\beamer@themelist{#2}%
  \@for\beamer@themename:=\beamer@themelist\do
    {\usepackage[{#1}]{\beamer@themelocation/#3\beamer@themename}}}
\def\usefolder#1{\def\beamer@themelocation{#1}}
\def\beamer@themelocation{}
\makeatother

\usefolder{nusbeamer}
\usetheme{nus}

\title[Short Title]{The Full Title of the Talk}
\subtitle{An optional subtitle}
\author[Team 1]{Ada LOVELACE \and Alan TURING}
\date{1 January 2026}

\setdeptname[DSDS]{Department of Statistics and Data Science}
\setcoursename[ST0000]{ST0000 Introduction to Everything}
\setreporttype{Interim Presentation}
\setadvisor{Dr.\ Someone}
\setadvisordesg{Professor, DSDS}

\begin{document}
\frame[plain]{\titlepage}

\section{First}
\sectiondescription{One line of context for this section.}   % optional
\frame[plain]{\sectionpage}

\begin{frame}{A frame}
  ...
\end{frame}
\end{document}
```

### Loading it from a folder

`beamer` resolves `\usetheme{nus}` to `beamerthemenus.sty` and looks for it where the document is. TeX does not search subdirectories, so a theme kept in `nusbeamer/` is not found by default, and a document has to point `\usetheme` at the folder. That is what the block above does: it is `beamer`'s own `\beamer@calltheme` with a prefix in front of the theme name, and `\usefolder` sets the prefix.

Putting the indirection in the document rather than in `TEXINPUTS` or a `latexmkrc` is deliberate. A bare `pdflatex`, an editor's build button and Overleaf then all compile the file with no configuration of their own, which matters when a deck is shared with people who do not use the same toolchain.

The alternative, if a document would rather not carry the block, is to symlink the four `.sty` files individually into the document directory and drop `\usefolder` — `\usetheme{nus}` then finds them unaided. Installing `nusbeamer/` into a `texmf` tree works too, and needs neither.

### What differs from the report classes

| | Report classes | Presentation theme |
| --- | --- | --- |
| Short forms on `\title` and `\author` | added by the class | `beamer`'s own, which already work this way |
| `\setreporttype` | `Assignment Report` | `Presentation` |
| `\setadvisor` unset | prints a placeholder on the cover | the advisor block is omitted |
| `\setuniname` | no short form | `\setuniname[<short>]{<full>}`, default short `NUS` |
| `\setuniimg` default | the full-colour logo, for a white cover page | the light-on-dark logo, since every ground in the theme is coloured |
| Aspect ratio | — | pass `aspectratio=169` to `\documentclass`; a theme cannot set it |

`\setuniname` is the one metadata command that takes a short form here and not in the report classes: the deck's footer gives the university, department and course one line between them, and at 4:3 a spelt-out university name wraps it onto two. The report classes' running header gives the university a line of its own, so the question does not arise there.

`\sectiondescription{<text>}` is the theme's only addition to the metadata interface. It sets one line of context on the next section page and is consumed there, so it applies to a single section.

### Colours

The theme defines three colours — `nusBlue`, `nusOrange` and `nusGray` — and refers to nothing by value. Retarget it by redefining them in the preamble under the same names:

```latex
\definecolor{nusBlue}{RGB}{0,61,124}      % #003D7C, Pantone 294
\definecolor{nusOrange}{RGB}{239,124,0}   % #EF7C00, Pantone 152
```

The two defaults are the published NUS corporate colours, from the university's [identity guidelines](https://nus.edu.sg/identity/guidelines/corporate-colours). Take an institution's colours from its specification rather than by sampling a logo file: the raster NUS logo renders its fills at `#1D427C` and `#ED8224`, and neither is the specified colour. The grey is not an institutional colour, only a neutral for secondary text.

The grey is deliberately not called `gray`. `xcolor` already defines that name, and redefining it changes every `\textcolor{gray}` in the document, including inside other packages' output.

### The logo is the light-on-dark one

Every place the theme shows the logo — the title page, the section pages and the frame title bar — has the institutional colour behind it. Only one version of the logo is therefore ever used, and it is the light-on-dark one:

```latex
\setuniimg{common-assets/your-logo-reversed.png}
```

Most institutions publish such a file; look in the identity guidelines for a version described as reversed, white, or for use on a colour background. This is the one default that differs from the report classes, which put their logo on a white cover page and so want the full-colour file. Neither ships with this repository; see [The university logo is not included](#the-university-logo-is-not-included).

### Small caps

Neither Computer Modern Sans nor Latin Modern Sans has a small-caps shape, so `\scshape` in a deck set in the default sans face falls back to the serif small caps without saying so. The theme uses uppercase in a smaller size wherever the report classes use `\textsc`. Do the same in the document, or load a sans face that has real small caps.

## The cheatsheet class

`nus-cheatsheet.cls` sets a crib sheet on A4 in several columns at a small, fixed font size, with a running header bar on every page (title, optional subtitle, author, date, and page x of y), numbered section bars (the number in an orange badge, the title in small caps; a title too long for one line makes the bar two lines deep rather than being clipped) and a framed box per result. It needs `tcolorbox`. The header takes the standard `\title`, `\author` and `\date`, plus `\subtitle`; `\maketitle` is not needed.

```latex
\documentclass[cols=3, size=7.2, pages=2]{nus-cheatsheet}
\title{Course --- Midterm}
\subtitle{Lectures 1--6}   % optional
\author{Name}
% \date defaults to the compile date, as day month year
\begin{document}
\begin{cheatsheet}
\section{Topic}
\begin{entry}{Result}
  statement \cex counterexample \pf proof idea.
  \sub{Related result} statement.
\end{entry}
\end{cheatsheet}
\end{document}
```

| Option | Default | Effect |
| --- | --- | --- |
| `cols=<n>` | `3` | Columns per page. |
| `size=<pt>` | `6.5` | Body font size in points. |
| `leading=<x>` | `1.2` | Baseline skip as a multiple of the font size. |
| `margin=<length>` | `5mm` | Margin on all four sides. |
| `pages=<n>` | `2` | Page budget. The class warns at the end of the run if the sheet is longer. |
| `landscape` | off | Landscape A4. |
| `norules` | off | No rules between columns. |
| `breakboxes` | off | Let entry boxes split across columns and pages. By default a box always moves whole to the next column. |

Each result goes in an `entry` box, whose title is run in at the start of its text; an empty title gives an untitled box, and by default a box never splits across a column or page. Columns are flush: each is stretched to full height, with its spare space shared evenly between the boxes. `\sub{...}` is a run-in heading for a second result inside the same box, and `\kw`, `\cex`, `\pf` and `\warn` mark a keyword, a counterexample (a tag on a light scarlet ground), a proof idea (on light yellow), and a caution. Body text is ragged-right and serif; sans serif is used only in the header and the section bars. The usual workflow is to write the content first and then raise `size` until the sheet just fits the budget; if the size that fits is too small to read, cut content rather than spacing. Text is set in `newtxtext` and `newtxmath`, with TeX Gyre Heros as the sans face; `sensible-math.sty` is loaded when it is on the TeX path, and `amsmath`, `amssymb`, and `amsthm` otherwise. The accent colours are the NUS blue and orange, named `csaccent` and `cssub`; redefine them with `\definecolor` after `\documentclass` to change them.

## Using these elsewhere

The NUS values above are defaults, not assumptions. Point the classes at your own institution in the preamble:

```latex
\setuniname{Your University}
\setuniimg{path/to/your-logo.png}
\setdeptname[SoE]{School of Engineering}
```

Nothing else in either class refers to a specific institution, so that is the whole of it. The file names keep their `nus-` prefix so that existing documents continue to compile; rename them if you prefer, and change the matching `\ProvidesClass` line.

## The university logo is not included

Both classes draw a logo — on the cover page or first-page title block, and again, smaller, in the running header — but no image ships with this repository. A university logo is the institution's trademark and is not part of this work, so none is redistributed here.

Supply your own before building. Either put a file at the default `\uniimg` path, `common-assets/nus_logo.png` relative to the document, or point the class somewhere else entirely. The beamer theme's own default is a different file, the light-on-dark version, for the reason given under [The logo is the light-on-dark one](#the-logo-is-the-light-on-dark-one).

Nothing requires a `common-assets/` directory; it is only where `\uniimg` looks by default. A wide image of roughly 2:1 works best, since the classes scale it to `0.35\textwidth` on the cover and to about one line's height in the running header — a transparent or white background and a wordmark that stays legible when small matter more than resolution. Obtain your institution's logo from its own brand or communications office and follow the guidelines that come with it.

## Expected layout

Paths in `\uniimg` resolve relative to the *document*, not to the class, so each document directory needs its own copy of, or symlink to, whatever the logo path points at. One workable arrangement is a relative symlink from each document directory back to a single shared checkout of this repository:

```sh
ln -s <relative-path>/nus-report.cls .
ln -s <relative-path>/common-assets .
ln -s <relative-path>/codespace.sty .      # only if code listings are needed
```

For a deck, the theme folder and the assets:

```sh
ln -s <relative-path>/nusbeamer .
ln -s <relative-path>/common-assets .
```

`common-assets` is separate because `\uniimg` resolves relative to the document, not to the theme.

Because those symlinks may point outside the document's own repository, run `latexmk` without a sandbox that restricts reads to the project directory.

## Requirements

A full TeX Live installation covers everything here. Build with `latexmk -pdf`, which runs `biber` and reruns as required.

The beamer theme additionally loads `lmodern` and `fontenc`, so that a deck is set in scalable outlines rather than the bitmap Computer Modern that `beamer` would otherwise use, and so that accented names in an author list come out as real glyphs.

`codespace.sty` additionally needs **Pygments** installed and the document compiled with `--shell-escape`, because it uses `minted`. Load it only in documents that typeset code.

## Licence

BSD 3-Clause; see [LICENSE](LICENSE).

The licence covers the classes, the beamer theme, and the style package. It does not extend to any logo you supply, which remains subject to whatever terms its owner sets.

`nusbeamer/` descends from `isibeamer`, a personal template I used at the Indian Statistical Institute, which in turn descends, substantially modified, from the [ZHAW beamer template](https://www.overleaf.com/latex/templates/zhaw-beamer-template/mmxmhmhswrtx) by Martin Oswald.
