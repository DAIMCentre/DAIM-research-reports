<img src="assets/DAIM_UoH_Logo.png" alt="University of Hull &middot; DAIM" width="440">

# DAIM Research Report Series — LaTeX template

A LaTeX document class for the University of Hull **Centre of Excellence for
Data Science, Artificial Intelligence and Modelling (DAIM)** research report
series. The typography follows the conventions of Google DeepMind technical
reports: A4, one column, indented justified body, a bold unlabelled abstract,
and `Figure 1 | …` captions.

```
daimreport.cls    the document class
main.tex          the template -- fill in the placeholders
references.bib    placeholder bibliography entries
assets/           logo artwork
main.pdf          the template as it builds out of the box
DAIM-Research-Report-Template.zip   drop this into Overleaf
```

## Getting started

**Overleaf.** Download `DAIM-Research-Report-Template.zip`, then in Overleaf
choose *New Project → Upload Project* and drop the zip in. It compiles as-is
with the default pdfLaTeX setting; no configuration needed. The project takes
its name from the zip.

**Locally.** Needs a full TeX Live or MiKTeX:

```
latexmk -pdf main.tex
```

`latexmk` runs BibTeX and the extra passes needed for the bibliography and
cross-references.

Either way, then:

1. Fill in the metadata block at the top of `main.tex`.
2. Replace the placeholder prose in each section.
3. Replace the entries in `references.bib` and update the `\citep` keys.

## Metadata

Only `\reporttitle` is strictly required; the rest degrade gracefully if left
out.

```latex
\reporttitle{Report Title in Sentence Case}
\reportsubtitle{An optional subtitle giving the scope or the claim}
\shorttitle{Short Title for the Running Head}

\reportauthor{First A. Author\daimmark{*}, Second B. Author,
              Third C. Author\daimmark{\dag}}
\reportaffiliation{Centre of Excellence for DAIM, University of Hull, UK}
\reportauthornote{\daimmark{*}Corresponding author.
                  \daimmark{\dag}Also at Department Name, Institution Name.}

\reportemail{first.author@hull.ac.uk}
\reportnumber{DAIM-RR-2026-000}
\reportlogo{assets/DAIM_UoH_Logo.png}

% Optional overrides -- leave them commented out to accept the defaults
% \reportdate{16 March 2026}
% \reportseries{DAIM Research Report Series}
% \reportrights{\textcopyright\ 2026 University of Hull. All rights reserved.}
% \reportlogowidth{50mm}
```

### The date

**The masthead date is the compile date, automatically.** There is nothing to
set: `\reportdate` is an override for pinning a fixed date, and it is commented
out in `main.tex`. Recompile tomorrow and the date moves.

Pin it once the report is issued, so that the date on record does not drift
every time someone rebuilds the file:

```latex
\reportdate{16 March 2026}
```

The report number behaves the same way — `\reportnumber` defaults to
`DAIM-RR-<current year>-001`, so set it explicitly for anything real.

`\daimmark{*}` sets a superscript marker and is stripped from the PDF metadata
automatically, so it is safe to use in author names.

## Class options

```latex
\documentclass[anonymous]{daimreport}   % hide authors and contact for review
\documentclass[nologo]{daimreport}      % drop the masthead logo
```

Point size and paper size are fixed by the design — do not pass `10pt` or
`12pt`.

## Document structure

```latex
\begin{document}
\makedaimtitle                       % masthead, title block, page-1 imprint

\begin{daimabstract} ... \end{daimabstract}
\daimkeywords{first; second; third}   % optional
% \daimcontents                       % off by default -- see below

\section{Introduction} ...

\daimsection{Acknowledgements}        % unnumbered, still in the contents
\daimbibliography{references}         % sets style, font and heading
\daimappendix                         % "Appendix A.", floats renumber to A1
\section{Notation} ...
\end{document}
```

The imprint block on page 1 — corresponding author, series and report number,
copyright — is placed automatically and space for it is reserved. You do not
position it yourself.

## The contents list

`\daimcontents` is set the way a **paper** sets it, not the way a thesis does:
no dotted leaders, tight leading, small type, page numbers flush right,
subsections in a lighter grey. Two levels deep (`tocdepth` 2).

**It is commented out in `main.tex` by default.** Uncomment it only for a long
report, from roughly fifteen pages up. The DeepMind
reports carry no printed contents list at all — `Aletheia.pdf`, at 39 pages, has
31 PDF bookmarks and no contents page. Bookmarks are generated here either way,
so a short report loses nothing by omitting it.

## Headings

Numbered to three levels, plus a run-in paragraph heading:

```latex
\section{...}          % 1.  Title
\subsection{...}       % 1.1 Title
\subsubsection{...}    % 1.1.1 Title
\paragraph{...}        % Bold run-in, full stop, text follows on the same line
\daimsection{...}      % Unnumbered, but appears in the contents and bookmarks
```

## Callout boxes

```latex
\begin{daimkeybox}{Headline finding}
Accent panel. Use once or twice per report for the claim a skimming reader
should take away -- it loses its force if it appears on every page.
\end{daimkeybox}

\begin{daimbox}[breakable=false]{Example transcript}
Neutral grey panel, for transcripts, prompts and worked examples.
\end{daimbox}
```

Both are `tcolorbox` environments and accept any tcolorbox key in the optional
argument. They break across pages by default; pass `breakable=false` to keep a
short panel whole.

## Tables

`booktabs` rules with `\daimheadrow` for the tinted header band. Column types
`L{}`, `C{}`, `R{}` are fixed-width variants; `Y` is a stretchable `tabularx`
column. No vertical rules, caption below.

```latex
\begin{table}[t]
\centering
\begin{tabularx}{\textwidth}{L{28mm} R{22mm} R{22mm} Y}
\toprule
\daimheadrow \daimth{Condition} & \daimth{Metric A} & \daimth{Metric B} & \daimth{Notes} \\
\midrule
Baseline & 0.00 & 0.00 & Reference condition. \\
\bottomrule
\end{tabularx}
\caption{Caption below the table.}
\label{tab:example}
\end{table}
```

**Do not bound a `\daimheadrow` table with `@{}`.** The tint is a per-cell
background whose default overhang is what closes the gaps between columns;
without `@{}` the tabular's natural width already matches the booktabs rules, so
band and rules line up exactly. Adding `@{}` leaves white slivers at every
column boundary.

For the same reason the class sets `\aboverulesep` and `\belowrulesep` to zero
and restores the padding with `\extrarowheight` instead. Otherwise booktabs
leaves 2–3 pt of white between the tint and the rules above and below it, and
the band looks as though it is floating inside the row rather than filling it.
This applies to every table, tinted or not, so rules sit a little closer to the
text than stock booktabs — that is deliberate; do not reset those lengths.

## Colour

The palette is a neutral grey scale, as the DeepMind reports are: **link blue is
the only colour on the page.** Table header bands, both callout boxes and the
figure placeholder are all grey, and the two boxes are told apart by the weight
of their title bar rather than by hue — charcoal for `daimkeybox`, mid grey for
`daimbox`.

If DAIM ever wants a brand colour in the furniture, change these two lines in
section 4 of `daimreport.cls` and nothing else — the key box, table headers and
figure placeholders all follow:

```latex
\definecolor{DAIMAccent}{HTML}{3C4043}     % charcoal
\definecolor{DAIMAccentTint}{HTML}{F1F3F4} % light grey
```

Keep the tint very light; it sits directly behind bold table headings.

## Notes

- `amsmath` and `amssymb` load before `newtx` inside the class to avoid the
  `\Bbbk` clash. Do not load them again in your document.
- Citations are `natbib` author–year with `plainnat`: `\citep{key}` for
  parenthetical, `\citet{key}` for running text, `\citep{a,b}` for several.
- `tikz`, `booktabs`, `tabularx`, `enumitem`, `listings`, `tcolorbox` and
  `graphicx` are loaded by the class and need no `\usepackage`.
- `\verb` cannot appear inside another command's argument (`\parbox`, `\fbox`,
  captions). Use `\texttt{...}` with `\textbackslash` there instead.
