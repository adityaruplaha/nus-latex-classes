# University student report classes

Two LaTeX document classes and one style package for university coursework and project reports — the kind of document that needs an institution's name and logo, a course code, an advisor and a declaration block, rather than the journal apparatus that `article` and `report` assume.

Nothing here is tied to a particular university. The classes ship with defaults for the National University of Singapore because that is where they were written, and every institutional field is a one-line override. See [Using these elsewhere](#using-these-elsewhere).

| File | Purpose |
| --- | --- |
| `nus-report.cls` | Full report format with a separate cover page, front matter and a table of contents. For project reports and theses. |
| `nus-report-short.cls` | Compact format with no cover page: the title, authors, advisor and course appear as a block at the top of the first page. For homework sets and short assignments. |
| `codespace.sty` | Code listings and algorithm environments, with the source file embedded in the PDF for download. |

The two classes are independent — load one or the other, never both. Their `nus-` filenames are historical; the classes themselves are generic.

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

Supply your own before building. Either put a file at the default `\uniimg` path, `common-assets/nus_logo.png` relative to the document, or point the class somewhere else entirely.

Nothing requires a `common-assets/` directory; it is only where `\uniimg` looks by default. A wide image of roughly 2:1 works best, since the classes scale it to `0.35\textwidth` on the cover and to about one line's height in the running header — a transparent or white background and a wordmark that stays legible when small matter more than resolution. Obtain your institution's logo from its own brand or communications office and follow the guidelines that come with it.

## Expected layout

Paths in `\uniimg` resolve relative to the *document*, not to the class, so each document directory needs its own copy of, or symlink to, whatever the logo path points at. One workable arrangement is a relative symlink from each document directory back to a single shared checkout of this repository:

```sh
ln -s <relative-path>/nus-report.cls .
ln -s <relative-path>/common-assets .
ln -s <relative-path>/codespace.sty .      # only if code listings are needed
```

Because those symlinks may point outside the document's own repository, run `latexmk` without a sandbox that restricts reads to the project directory.

## Requirements

A full TeX Live installation covers everything the two classes need. Build with `latexmk -pdf`, which runs `biber` and reruns as required.

`codespace.sty` additionally needs **Pygments** installed and the document compiled with `--shell-escape`, because it uses `minted`. Load it only in documents that typeset code.

## Licence

BSD 3-Clause; see [LICENSE](LICENSE).

The licence covers the two classes and the style package. It does not extend to any logo you supply, which remains subject to whatever terms its owner sets.
