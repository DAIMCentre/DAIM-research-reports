%% daimreport.cls -- DAIM Research Report Series (University of Hull)
%%
%% A LaTeX class for institutional research reports, following the typographic
%% conventions of Google DeepMind technical reports: A4, one column, indented
%% justified body, a bold unlabelled abstract, and "Figure 1 | ..." captions.
%%
%%   \documentclass{daimreport}
%%
%% Options
%%   nologo      suppress the masthead logo
%%   anonymous   hide author names and contact details, for blind review
%%
%% Point size and paper size are fixed by the design; do not pass 10pt or 12pt.
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{daimreport}[2026/08/17 v10 DAIM Research Report Series]

% ---------------------------------------------------------------------------
% 1. Class options
% ---------------------------------------------------------------------------
\RequirePackage{etoolbox}

\newif\ifdaim@logo  \daim@logotrue
\newif\ifdaim@anon  \daim@anonfalse

\DeclareOption{nologo}{\daim@logofalse}
\DeclareOption{anonymous}{\daim@anontrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[11pt,a4paper]{article}

% ---------------------------------------------------------------------------
% 2. Fonts and micro-typography
% ---------------------------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\let\Bbbk\relax                       % newtxmath redefines it; avoid the clash
\RequirePackage{newtxtext,newtxmath}
\RequirePackage[scaled=0.86]{beramono}
\RequirePackage{microtype}
\RequirePackage{graphicx}
\RequirePackage{xcolor}

% ---------------------------------------------------------------------------
% 3. Page geometry
%    The side margin is exposed as a length because the first-page imprint
%    block is positioned absolutely and must agree with it.
% ---------------------------------------------------------------------------
% Measured off the DeepMind reports: A4 with a 166 mm measure, the running-head
% rule 23 mm below the trim and the folio rule 23.5 mm above it.
\newlength{\daimsidemargin}    \setlength{\daimsidemargin}{22mm}
\newlength{\daimtopmargin}     \setlength{\daimtopmargin}{29mm}
\newlength{\daimbotmargin}     \setlength{\daimbotmargin}{28mm}

% Page 1 only. The masthead is lifted out of the top margin so the logo sits
% near the trim as it does on their title page, rather than following the body
% text block down. The lift is tuned so the rule under the logo lands about
% 31 mm from the trim: our logo is a two-mark lockup, far taller than the
% DeepMind wordmark, so it cannot sit as high as their 23 mm rule without
% crowding the page edge. \daimimprintraise puts the page-1 imprint rule level
% with the folio rule on the body pages.
\newlength{\daimmastheadlift}  \setlength{\daimmastheadlift}{16mm}
\newlength{\daimimprintraise}  \setlength{\daimimprintraise}{12.6mm}
\newlength{\daimimprintreserve}\setlength{\daimimprintreserve}{4mm}

\RequirePackage{geometry}
\geometry{%
  a4paper,
  left=\daimsidemargin, right=\daimsidemargin,
  top=\daimtopmargin, bottom=\daimbotmargin,
  headheight=13pt, headsep=6mm, footskip=8.5mm}

\RequirePackage{eso-pic}

% ---------------------------------------------------------------------------
% 4. Colour palette
%    Deliberately a neutral grey scale, as the DeepMind reports are: link blue
%    is the only colour on the page. The two callout boxes are told apart by
%    the weight of their title bar, not by hue.
%
%    To introduce a brand colour, change DAIMAccent and DAIMAccentTint only --
%    the key box, table header bands and figure placeholders all follow.
% ---------------------------------------------------------------------------
\definecolor{DAIMInk}{HTML}{111111}      % body text
\definecolor{DAIMRule}{HTML}{8A8F94}     % hairlines
\definecolor{DAIMMuted}{HTML}{5F6368}    % imprint, folio, running head
\definecolor{DAIMLink}{HTML}{1A5FB4}     % citations and URLs -- the only colour
\definecolor{DAIMAccent}{HTML}{3C4043}   % charcoal: key-box title bar, listings
\definecolor{DAIMAccentTint}{HTML}{F1F3F4} % light grey: table header band, key-box body
\definecolor{DAIMBoxHead}{HTML}{6E6E6E}  % mid grey: neutral box title bar
\definecolor{DAIMBoxBody}{HTML}{F4F4F4}  % light grey: neutral box body

\color{DAIMInk}

% ---------------------------------------------------------------------------
% 5. Body text: indented, justified paragraphs with no inter-paragraph skip
% ---------------------------------------------------------------------------
\setlength{\parindent}{1.4em}
\setlength{\parskip}{0pt plus 0.6pt}
\linespread{1.02}
\raggedbottom
\setlength{\emergencystretch}{1.2em}

% ---------------------------------------------------------------------------
% 6. Hyperlinks and citations
% ---------------------------------------------------------------------------
\RequirePackage{natbib}
\RequirePackage{hyperref}
\hypersetup{%
  colorlinks=true, linkcolor=DAIMLink, citecolor=DAIMLink,
  urlcolor=DAIMLink, filecolor=DAIMLink, pdfborder={0 0 0},
  breaklinks=true, bookmarksnumbered=true, bookmarksopen=true,
  bookmarksopenlevel=1}
\setcitestyle{authoryear,round,semicolon,aysep={,}}
\setlength{\bibsep}{2.2pt plus 0.4pt}

\RequirePackage{url}
\urlstyle{same}

% ---------------------------------------------------------------------------
% 7. Report metadata
% ---------------------------------------------------------------------------
\newcommand{\daim@monthname}{%
  \ifcase\month\or January\or February\or March\or April\or May\or June%
  \or July\or August\or September\or October\or November\or December\fi}
\newcommand{\DAIMAutoDate}{\number\day\space\daim@monthname\space\number\year}

\newcommand{\DAIMTitle}{Untitled Report}
\newcommand{\DAIMSubtitle}{}
\newcommand{\DAIMShortTitle}{\DAIMTitle}
\newcommand{\DAIMAuthor}{}
\newcommand{\DAIMAuthorNote}{}
\newcommand{\DAIMAffiliation}{}
\newcommand{\DAIMDate}{\DAIMAutoDate}
\newcommand{\DAIMEmail}{}
\newcommand{\DAIMSeries}{DAIM Research Report Series}
\newcommand{\DAIMReportNumber}{DAIM-RR-\number\year-001}
\newcommand{\DAIMLogo}{assets/DAIM_UoH_Logo.png}
\newcommand{\DAIMRights}{\textcopyright\ \number\year\ University of Hull. All rights reserved.}
\newlength{\daimlogowidth}\setlength{\daimlogowidth}{50mm}

\newcommand{\reporttitle}[1]{\renewcommand{\DAIMTitle}{#1}}
\newcommand{\reportsubtitle}[1]{\renewcommand{\DAIMSubtitle}{#1}}
\newcommand{\shorttitle}[1]{\renewcommand{\DAIMShortTitle}{#1}}
\newcommand{\reportauthor}[1]{\renewcommand{\DAIMAuthor}{#1}}
\let\reportauthors\reportauthor
\newcommand{\reportauthornote}[1]{\renewcommand{\DAIMAuthorNote}{#1}}
\newcommand{\reportaffiliation}[1]{\renewcommand{\DAIMAffiliation}{#1}}
\newcommand{\reportdate}[1]{\renewcommand{\DAIMDate}{#1}}
\newcommand{\reportemail}[1]{\renewcommand{\DAIMEmail}{#1}}
\newcommand{\reportseries}[1]{\renewcommand{\DAIMSeries}{#1}}
\newcommand{\reportnumber}[1]{\renewcommand{\DAIMReportNumber}{#1}}
\newcommand{\reportlogo}[1]{\renewcommand{\DAIMLogo}{#1}}
\newcommand{\reportlogowidth}[1]{\setlength{\daimlogowidth}{#1}}
\newcommand{\reportrights}[1]{\renewcommand{\DAIMRights}{#1}}

% Superscript marker for author and affiliation cross-references. Stripped from
% PDF metadata strings, where superscripts are not representable.
\newcommand{\daimmark}[1]{\textsuperscript{\normalfont#1}}
\pdfstringdefDisableCommands{\let\daimmark\@gobble}

% ---------------------------------------------------------------------------
% 8. Sectioning
% ---------------------------------------------------------------------------
\RequirePackage{titlesec}
\RequirePackage{titletoc}

\titleformat{\section}
  {\normalfont\bfseries\fontsize{13.5}{16}\selectfont}{\thesection.}{0.6em}{}
\titlespacing*{\section}{0pt}{17pt plus 4pt minus 3pt}{6pt}
\titleformat{\subsection}
  {\normalfont\bfseries\fontsize{11.5}{13.5}\selectfont}{\thesubsection}{0.6em}{}
\titlespacing*{\subsection}{0pt}{13pt plus 3pt minus 2pt}{4pt}
\titleformat{\subsubsection}
  {\normalfont\bfseries\fontsize{10.8}{12.6}\selectfont}{\thesubsubsection}{0.6em}{}
\titlespacing*{\subsubsection}{0pt}{11pt plus 2pt minus 2pt}{3pt}
\titleformat{\paragraph}[runin]
  {\normalfont\bfseries\normalsize}{}{0pt}{}[.]
\titlespacing*{\paragraph}{0pt}{8pt plus 2pt minus 1pt}{0.6em}

\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

% Unnumbered section that still reaches the contents list and PDF bookmarks.
\newcommand{\daimsection}[1]{%
  \phantomsection\section*{#1}\addcontentsline{toc}{section}{#1}}

% Appendix: sections read "Appendix A. Title" and floats renumber to A1, A2 ...
\newcommand{\daimappendix}{%
  \clearpage
  \appendix
  \setcounter{section}{0}%
  \titleformat{\section}
    {\normalfont\bfseries\fontsize{13.5}{16}\selectfont}{Appendix \thesection.}{0.6em}{}%
  \renewcommand{\thefigure}{\thesection\arabic{figure}}%
  \renewcommand{\thetable}{\thesection\arabic{table}}%
  \setcounter{figure}{0}\setcounter{table}{0}}

% ---------------------------------------------------------------------------
% 9. Contents list
%    Set the way a paper sets it, not the way a thesis does: no dotted
%    leaders, tight leading, small type, page numbers flush right. Reserve it
%    for long reports -- a short one navigates by PDF bookmarks alone, which
%    is what the DeepMind reports themselves do.
% ---------------------------------------------------------------------------
\newcommand{\daimcontents}{%
  \begingroup
  \pdfbookmark[1]{Contents}{daim@toc}%
  \setlength{\parskip}{0pt}%
  {\noindent\normalfont\bfseries\fontsize{13.5}{16}\selectfont Contents\par}
  \vspace{5pt}
  \titlecontents{section}[1.7em]
    {\vspace{3.5pt}\normalfont\fontsize{10}{12}\selectfont}
    {\contentslabel{1.7em}}{\hspace*{-1.7em}}
    {\hfill\normalfont\contentspage}
  \titlecontents{subsection}[3.9em]
    {\vspace{1.5pt}\normalfont\color{DAIMMuted}\fontsize{9.4}{11.4}\selectfont}
    {\contentslabel{2.2em}}{\hspace*{-2.2em}}
    {\hfill\normalfont\contentspage}
  \@starttoc{toc}%
  \vspace{4pt}
  \endgroup}

% ---------------------------------------------------------------------------
% 10. Running head and folio (page 2 onwards)
% ---------------------------------------------------------------------------
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\footrulewidth}{0.5pt}
\renewcommand{\headrule}{{\color{DAIMRule}\hrule height \headrulewidth}}
\renewcommand{\footrule}{{\color{DAIMRule}\hrule height \footrulewidth}}
\fancyhead[C]{\color{DAIMMuted}\fontsize{8.5}{10}\selectfont\DAIMShortTitle}
\fancyfoot[L]{\color{DAIMMuted}\fontsize{8}{9.5}\selectfont\DAIMReportNumber}
\fancyfoot[R]{\color{DAIMMuted}\fontsize{9}{10.5}\selectfont\thepage}

% ---------------------------------------------------------------------------
% 11. Title page
% ---------------------------------------------------------------------------
\newcommand{\daim@imprint}{%
  \begingroup
  \color{DAIMMuted}\fontsize{8}{10.2}\selectfont
  {\color{DAIMRule}\hrule height 0.5pt}%
  \vspace{1.6mm}
  \ifdaim@anon\else
    \ifdefempty{\DAIMEmail}{}{%
      \textit{Corresponding author:} \href{mailto:\DAIMEmail}{\nolinkurl{\DAIMEmail}}.\par}%
  \fi
  \textit{\DAIMSeries}, Report No.\ \DAIMReportNumber.\par
  \DAIMRights\par
  \endgroup}

\newcommand{\makedaimtitle}{%
  \thispagestyle{empty}%
  \hypersetup{pdftitle={\DAIMTitle},pdfauthor={\DAIMAuthor},
              pdfsubject={\DAIMSeries\space--\space\DAIMReportNumber}}%
  % --- masthead: logo left, report number and date right ------------------
  % Lift it out of the top margin; see \daimmastheadtop above.
  \vspace*{-\daimmastheadlift}%
  \noindent
  \begin{minipage}[b]{0.60\textwidth}
    \ifdaim@logo
      \IfFileExists{\DAIMLogo}{\includegraphics[width=\daimlogowidth]{\DAIMLogo}}%
        {\ClassWarning{daimreport}{Logo file not found: \DAIMLogo}}%
    \fi
  \end{minipage}%
  \hfill
  \begin{minipage}[b]{0.38\textwidth}
    \raggedleft\color{DAIMMuted}
    {\fontsize{8.2}{10}\selectfont\DAIMReportNumber\par}
    \vspace{0.6mm}
    {\fontsize{9}{10.8}\selectfont\itshape\DAIMDate\par}
  \end{minipage}
  \vspace{1.8mm}
  \noindent{\color{DAIMRule}\hrule height 0.5pt}%
  % --- title --------------------------------------------------------------
  \vspace{8mm}
  {\raggedright\bfseries\fontsize{20.5}{24}\selectfont\DAIMTitle\par}
  \ifdefempty{\DAIMSubtitle}{}{%
    \vspace{2.6mm}
    {\raggedright\fontsize{13}{15.5}\selectfont\itshape\color{DAIMMuted}\DAIMSubtitle\par}}
  % --- authors ------------------------------------------------------------
  \vspace{6.5mm}
  \ifdaim@anon
    {\bfseries\fontsize{10.5}{13}\selectfont Author names withheld for review\par}
  \else
    {\raggedright\bfseries\fontsize{10.5}{13.4}\selectfont\DAIMAuthor\par}
    \ifdefempty{\DAIMAffiliation}{}{%
      \vspace{1.4mm}
      {\raggedright\fontsize{9.4}{11.4}\selectfont\DAIMAffiliation\par}}
    \ifdefempty{\DAIMAuthorNote}{}{%
      \vspace{1.4mm}
      {\raggedright\color{DAIMMuted}\fontsize{8}{10}\selectfont\DAIMAuthorNote\par}}
  \fi
  \vspace{8mm}
  % --- imprint block, pinned to the foot of page 1 ------------------------
  \enlargethispage{-\daimimprintreserve}%
  \AddToShipoutPictureFG*{%
    \put(\LenToUnit{\daimsidemargin},\LenToUnit{\daimimprintraise}){%
      \parbox[b]{\textwidth}{\daim@imprint}}}%
  \@afterindentfalse\@afterheading}

% ---------------------------------------------------------------------------
% 12. Abstract -- bold, full measure, no heading (DeepMind convention)
% ---------------------------------------------------------------------------
\newenvironment{daimabstract}
  {\par\noindent\begingroup\bfseries\fontsize{10.4}{13.4}\selectfont
   \setlength{\parindent}{0pt}\ignorespaces}
  {\par\endgroup\vspace{6.5mm}\@afterindentfalse\@afterheading}

% Optional keyword line, set immediately after the abstract.
\newcommand{\daimkeywords}[1]{%
  \par\noindent{\fontsize{9}{11.5}\selectfont\textbf{Keywords:} #1\par}
  \vspace{5mm}}

% ---------------------------------------------------------------------------
% 13. Floats and captions -- "Figure 1 | Caption text", centred
% ---------------------------------------------------------------------------
\RequirePackage{caption}
\DeclareCaptionLabelSeparator{daimbar}{\ \textbar\ }
\captionsetup{%
  labelsep=daimbar, justification=centering, singlelinecheck=false,
  font={small}, labelfont={}, textfont={}, skip=8pt}
\captionsetup[table]{position=below}

\setlength{\abovecaptionskip}{8pt}
\setlength{\belowcaptionskip}{0pt}
\setlength{\textfloatsep}{16pt plus 3pt minus 3pt}
\setlength{\intextsep}{14pt plus 3pt minus 3pt}

% ---------------------------------------------------------------------------
% 14. Tables
% ---------------------------------------------------------------------------
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{array}
\RequirePackage{colortbl}
\RequirePackage{multirow}

\renewcommand{\arraystretch}{1.15}
\setlength{\tabcolsep}{7pt}

% A tinted header row has to meet the booktabs rules above and below it.
% The default rule separation would leave a white sliver between the tint and
% each rule; zero it, then give the row its breathing room back from the inside
% with \extrarowheight, so the text still clears the rules.
\setlength{\aboverulesep}{0pt}
\setlength{\belowrulesep}{0pt}
\setlength{\extrarowheight}{3pt}
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}p{#1}}
\newcolumntype{Y}{>{\raggedright\arraybackslash}X}

% Tinted header row. The default \tabcolsep overhangs are what make the band
% continuous across inter-column gaps, so tables using \daimheadrow must NOT be
% bounded by @{}: without it the tabular's natural width already matches the
% booktabs rules and the tint lines up with them exactly.
\newcommand{\daimheadrow}{\rowcolor{DAIMAccentTint}}
\newcommand{\daimth}[1]{\textbf{#1}}

% ---------------------------------------------------------------------------
% 15. Lists
% ---------------------------------------------------------------------------
\RequirePackage{enumitem}
\setlist{topsep=5pt, itemsep=2.5pt, parsep=0pt, partopsep=0pt, leftmargin=1.9em}
\setlist[itemize]{label=\textbullet}

% ---------------------------------------------------------------------------
% 16. Callout boxes
% ---------------------------------------------------------------------------
\RequirePackage[most]{tcolorbox}

\tcbset{daim@panel/.style={%
  enhanced, breakable, arc=2.5pt, boxrule=0pt,
  fonttitle=\bfseries\fontsize{9.6}{11.6}\selectfont,
  coltitle=white,
  toptitle=2.6pt, bottomtitle=2.6pt, lefttitle=8pt,
  top=7pt, bottom=7pt, left=8pt, right=8pt,
  fontupper={\fontsize{9.8}{12.4}\selectfont
             \setlength{\parindent}{0pt}\setlength{\parskip}{4pt}},
  parbox=false,
  before skip=12pt, after skip=12pt}}

% \begin{daimbox}{Title}    -- neutral grey panel, for transcripts and examples
\newtcolorbox{daimbox}[2][]{%
  daim@panel, title={#2},
  colback=DAIMBoxBody, colframe=DAIMBoxBody, colbacktitle=DAIMBoxHead, #1}

% \begin{daimkeybox}{Title} -- accent panel, for key findings and takeaways
\newtcolorbox{daimkeybox}[2][]{%
  daim@panel, title={#2},
  colback=DAIMAccentTint, colframe=DAIMAccentTint, colbacktitle=DAIMAccent, #1}

% ---------------------------------------------------------------------------
% 17. Code and transcripts
% ---------------------------------------------------------------------------
\RequirePackage{listings}
\lstdefinestyle{daim}{%
  basicstyle=\ttfamily\fontsize{8.6}{10.4}\selectfont,
  keywordstyle=\color{DAIMAccent}\bfseries,
  commentstyle=\color{DAIMMuted}\itshape,
  stringstyle=\color{DAIMAccent},
  breaklines=true, breakatwhitespace=true, columns=fullflexible,
  showstringspaces=false, frame=none, xleftmargin=0pt, aboveskip=8pt, belowskip=8pt}
\lstset{style=daim}

% Indented block quotation, as used for prompts in DeepMind reports.
\renewenvironment{quote}
  {\list{}{\leftmargin=2.2em\rightmargin=1.2em\topsep=8pt\parsep=4pt}%
   \item\relax}
  {\endlist}

% ---------------------------------------------------------------------------
% 18. Footnotes
% ---------------------------------------------------------------------------
\renewcommand{\footnotesize}{\fontsize{8.6}{10.4}\selectfont}
\setlength{\skip\footins}{14pt plus 3pt}
\renewcommand{\footnoterule}{\kern-3pt{\color{DAIMRule}\hrule width 0.35\columnwidth height 0.4pt}\kern2.6pt}

% ---------------------------------------------------------------------------
% 19. Bibliography
% ---------------------------------------------------------------------------
\newcommand{\daimbibliography}[1]{%
  \phantomsection
  \addcontentsline{toc}{section}{\refname}%
  \bibliographystyle{plainnat}%
  \begingroup\fontsize{9.6}{11.6}\selectfont
  \bibliography{#1}%
  \endgroup}

% Heading typography matches \section but is stated explicitly so that it is
% unaffected by the smaller font group the bibliography is set in.
\renewcommand{\bibsection}{%
  \par\vspace{17pt plus 4pt minus 3pt}%
  {\noindent\normalfont\bfseries\fontsize{13.5}{16}\selectfont\refname\par}%
  \vspace{6pt}}

\endinput
