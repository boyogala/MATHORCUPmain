% !TeX program = xelatex
% !TeX encoding = UTF-8
%
% mathorcup.cls  v3.0
% MathorCup 论文模板。字体自完备：英文、中文、数学、等宽全部只读 ./fonts/。
% 禁止回退到操作系统字体或 TeX Live 自带字体（Fandol / Latin Modern / TeX Gyre / newtx）。
% 编译器只能是 XeLaTeX，工作目录必须是本文件所在的项目根目录。
%
\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{mathorcup}[2026/10/20 v3.0 MathorCup class, bundled fonts only]

% ----- 引擎锁：pdfLaTeX / LuaLaTeX 无法按文件名安全嵌入这套字体 -----
\expandafter\ifx\csname XeTeXrevision\endcsname\relax
  \ClassError{mathorcup}{XeLaTeX is required}{%
    Run: xelatex main.tex\par
    pdfLaTeX and LuaLaTeX are refused so the build cannot silently pick TeX Live fonts.}%
\expandafter\endinput
\fi

% ----- 选项：只保留会改变编译成本或版式的开关；fontset=* 一律拒绝 -----
\newif\ifmathorcup@algo \mathorcup@algotrue
\DeclareOption{draft}{%
  \PassOptionsToClass{draft}{ctexart}%
  \PassOptionsToPackage{draft}{graphicx}%
}
\DeclareOption{noalgo}{\mathorcup@algofalse}
\ExplSyntaxOn
\DeclareOption*
  {
    \tl_set:Nx \l_tmpa_tl { \CurrentOption }
    \tl_if_in:NnTF \l_tmpa_tl { fontset }
      {
        \ClassError {mathorcup} { Option~`\l_tmpa_tl'~is~disabled }
          { fontset~is~forced~to~none.~All~fonts~must~come~from~fonts/. }
      }
      { \PassOptionsToClass { \CurrentOption } { ctexart } }
  }
\ExplSyntaxOff
\ProcessOptions\relax

% fontspec 在 ctex 载入前锁定：
%   no-math  不让 fontspec 改数学字体（交给 unicode-math + fonts/STIXTwoMath）
%   quiet    永中字库没有 CJK script 标记，避免无意义警告；缺文件仍会报错
\PassOptionsToPackage{no-math,quiet}{fontspec}
\LoadClass[oneside,a4paper,UTF8,linespread=1.25,zihao=-4,fontset=none]{ctexart}

% ----- 宏包：轻量、顺序固定。hyperref / bookmark 必须最后 -----
\RequirePackage[top=2cm,bottom=2cm,left=2.5cm,right=2.5cm,headheight=12pt]{geometry}
\RequirePackage{fancyhdr,lastpage}
\RequirePackage{amsmath,amsthm}
\RequirePackage{unicode-math}
\RequirePackage{booktabs,tabularx,array}
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage{float}
\RequirePackage[section]{placeins}
\RequirePackage{xcolor}
\RequirePackage[numbers,sort&compress]{natbib}
\ifmathorcup@algo
  \RequirePackage[ruled,vlined,linesnumbered,noend]{algorithm2e}
\fi
\RequirePackage{hyperref}
\RequirePackage{bookmark}

% 可在 \documentclass 之前用 \def\mathorcupfontdir{.../fonts/} 覆盖（须以 / 结尾）
\providecommand{\mathorcupfontdir}{fonts/}
\newcommand{\MATHORCUP@fontdir}{\mathorcupfontdir}

% 缺任一文件就停止。绝不让 fontspec / xeCJK 去系统或 TeX Live 里找替代字体。
\newcommand{\MATHORCUP@needfont}[1]{%
  \IfFileExists{\MATHORCUP@fontdir#1}{}{%
    \ClassError{mathorcup}{Missing bundled font `\MATHORCUP@fontdir#1'}{%
      cd to the directory that contains mathorcup.cls and fonts/, then run xelatex.
      Do not install replacement fonts into the OS or TeX Live.}%
  }%
}
\ExplSyntaxOn
\clist_map_inline:nn
  {
    STIXTwoText-Regular.otf, STIXTwoText-Bold.otf,
    STIXTwoText-Italic.otf, STIXTwoText-BoldItalic.otf,
    STIXTwoMath-Regular.otf,
    JetBrainsMono-Regular.ttf, JetBrainsMono-Bold.ttf,
    JetBrainsMono-Italic.ttf, JetBrainsMono-BoldItalic.ttf,
    yzsong.ttf, yzhei.ttf, yzkai.ttf, yzfsong.ttf
  }
  { \MATHORCUP@needfont {#1} }
\ExplSyntaxOff

% 四种字样都写在命令体内再交给 fontspec，避免未展开的宏被当成键名。
% 斜体/小型大写也指向包内文件，禁止 NFSS 去系统或 TeX Live 找替代。
\newcommand{\MATHORCUP@setlatin}[1]{%
  #1{STIXTwoText-Regular.otf}[
    Path              = \MATHORCUP@fontdir,
    Ligatures         = TeX,
    BoldFont          = STIXTwoText-Bold.otf,
    ItalicFont        = STIXTwoText-Italic.otf,
    BoldItalicFont    = STIXTwoText-BoldItalic.otf,
    SlantedFont       = STIXTwoText-Italic.otf,
    BoldSlantedFont   = STIXTwoText-BoldItalic.otf,
    SmallCapsFont     = STIXTwoText-Regular.otf,
    SmallCapsFeatures = {Letters=SmallCaps}%
  ]%
}
\MATHORCUP@setlatin{\setmainfont}
% 项目没有独立无衬线字体；用同一套 STIX，禁止 fontspec 去搜 Helvetica / TeX Gyre Heros
\MATHORCUP@setlatin{\setsansfont}
\setmonofont{JetBrainsMono-Regular.ttf}[
  Path            = \MATHORCUP@fontdir,
  Ligatures       = TeX,
  BoldFont        = JetBrainsMono-Bold.ttf,
  ItalicFont      = JetBrainsMono-Italic.ttf,
  BoldItalicFont  = JetBrainsMono-BoldItalic.ttf,
  SlantedFont     = JetBrainsMono-Italic.ttf,
  BoldSlantedFont = JetBrainsMono-BoldItalic.ttf
]

% 数学字母的粗体/直体/等宽全部绑到包内文件，不用 Latin Modern Math。
\unimathsetup{
  math-style = TeX,
  bold-style = TeX,
  mathrm = text,
  mathbf = text,
  mathit = text,
  mathsf = text,
  mathtt = text
}
\setmathfont{STIXTwoMath-Regular.otf}[
  Path     = \MATHORCUP@fontdir,
  BoldFont = STIXTwoMath-Regular.otf
]
% 不用 \setmathfontface 重定义 \mathrm（会与 unicode-math 冲突）。
% fontspec 这几条把数学字母绑到包内文件，盖掉默认的 OT1/cmr。
\setmathrm[
  Path           = \MATHORCUP@fontdir,
  BoldFont       = STIXTwoText-Bold.otf,
  ItalicFont     = STIXTwoText-Italic.otf,
  BoldItalicFont = STIXTwoText-BoldItalic.otf
]{STIXTwoText-Regular.otf}
\setboldmathrm[Path=\MATHORCUP@fontdir]{STIXTwoText-Bold.otf}
\setmathsf[
  Path           = \MATHORCUP@fontdir,
  BoldFont       = STIXTwoText-Bold.otf,
  ItalicFont     = STIXTwoText-Italic.otf,
  BoldItalicFont = STIXTwoText-BoldItalic.otf
]{STIXTwoText-Regular.otf}
\setmathtt[
  Path           = \MATHORCUP@fontdir,
  BoldFont       = JetBrainsMono-Bold.ttf,
  ItalicFont     = JetBrainsMono-Italic.ttf,
  BoldItalicFont = JetBrainsMono-BoldItalic.ttf
]{JetBrainsMono-Regular.ttf}

% 中文只加载一次：宋=正文，黑=无衬线/粗体，仿=等宽，楷=斜体。
% 不再为 \songti 等单独 \setCJKfamilyfont 重复打开 20MB 字库。
\setCJKmainfont{yzsong.ttf}[
  Path           = \MATHORCUP@fontdir,
  BoldFont       = yzhei.ttf,
  ItalicFont     = yzkai.ttf,
  BoldItalicFont = yzhei.ttf
]
\setCJKsansfont{yzhei.ttf}[
  Path           = \MATHORCUP@fontdir,
  BoldFont       = yzhei.ttf,
  ItalicFont     = yzkai.ttf,
  BoldItalicFont = yzhei.ttf
]
\setCJKmonofont{yzfsong.ttf}[
  Path           = \MATHORCUP@fontdir,
  BoldFont       = yzhei.ttf,
  ItalicFont     = yzkai.ttf,
  BoldItalicFont = yzhei.ttf
]
\setCJKfamilyfont{zhkai}{yzkai.ttf}[
  Path           = \MATHORCUP@fontdir,
  BoldFont       = yzhei.ttf,
  ItalicFont     = yzkai.ttf,
  BoldItalicFont = yzhei.ttf
]
\xeCJKsetup{
  CJKmath        = true,
  AutoFakeBold   = false,
  AutoFakeSlant  = false
}
\NewDocumentCommand{\songti}{}{\CJKfamily{\CJKrmdefault}}
\NewDocumentCommand{\heiti}{}{\CJKfamily{\CJKsfdefault}}
\NewDocumentCommand{\fangsong}{}{\CJKfamily{\CJKttdefault}}
\NewDocumentCommand{\kaishu}{}{\CJKfamily{zhkai}}

% ----- 标题：与竞赛常见版式一致，不额外载入标题宏包 -----
\ctexset{
  section = {
    format     = {\zihao{4}\heiti\centering},
    name       = {,、},
    aftername  = {\hspace{0.5em}},
    number     = \chinese{section},
    beforeskip = 1.2\baselineskip,
    afterskip  = 0.6\baselineskip
  },
  subsection = {
    format     = {\zihao{-4}\heiti\raggedright},
    name       = {},
    aftername  = {\hspace{0.5em}},
    number     = {\arabic{section}.\arabic{subsection}},
    beforeskip = 0.9\baselineskip,
    afterskip  = 0.4\baselineskip
  },
  subsubsection = {
    format     = {\normalsize\heiti\raggedright},
    name       = {},
    aftername  = {\hspace{0.5em}},
    number     = {\arabic{section}.\arabic{subsection}.\arabic{subsubsection}},
    beforeskip = 0.7\baselineskip,
    afterskip  = 0.3\baselineskip
  },
  appendix = {
    name   = {附录,：},
    number = \Alph{section}
  }
}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

% 建模论文常用环境。定义体用正体，避免中文进入楷体斜体。
\theoremstyle{definition}
\newtheorem{theorem}{定理}[section]
\newtheorem{lemma}[theorem]{引理}
\newtheorem{proposition}[theorem]{命题}
\newtheorem{corollary}[theorem]{推论}
\newtheorem{definition}[theorem]{定义}
\newtheorem{assumption}[theorem]{假设}
\theoremstyle{remark}
\newtheorem{remark}[theorem]{注}

% ----- 图表、页脚、链接 -----
\newcommand{\bstlabelmark}{99}
\newcolumntype{Y}{>{\centering\arraybackslash}X}
\graphicspath{{figures/}}
\DeclareCaptionFont{heiti}{\heiti}
\DeclareCaptionFont{5hao}{\zihao{5}}
\DeclareCaptionLabelSeparator*{sspace}{\ \ }
\captionsetup{format=hang,labelfont={heiti,5hao},textfont={heiti,5hao}}
\captionsetup[figure]{labelsep=sspace}
\captionsetup[table]{labelsep=sspace}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[C]{第 \thepage{} 页 共 \pageref{LastPage} 页}

\hypersetup{
  breaklinks         = true,
  colorlinks         = true,
  linkcolor          = black,
  citecolor          = blue,
  urlcolor           = blue,
  bookmarksnumbered  = true,
  bookmarksopen      = true,
  pdfstartview       = Fit,
  pdfauthor          = {},
  pdfcreator         = {XeLaTeX}
}
\g@addto@macro{\UrlBreaks}{\do\-\do\_\do\.\do\/}

% ----- 元信息。旧命令保留；也可用 \mathorcupsetup{bianhao=...,timu=...} -----
\def\@bianhao{}
\def\@tihao{}
\def\@timu{}
\def\@keyword{}
\def\bianhao#1{\gdef\@bianhao{#1}}
\def\tihao#1{\gdef\@tihao{#1}}
\def\timu#1{\gdef\@timu{#1}}
\def\keyword#1{\gdef\@keyword{#1}}
\ExplSyntaxOn
\keys_define:nn { mathorcup }
  {
    bianhao .code:n = { \bianhao {#1} },
    tihao   .code:n = { \tihao {#1} },
    timu    .code:n = { \timu {#1} },
    keyword .code:n = { \keyword {#1} }
  }
\NewDocumentCommand \mathorcupsetup { m }
  { \keys_set:nn { mathorcup } { #1 } }
\ExplSyntaxOff

\AtBeginDocument{%
  \hypersetup{pdftitle={\@timu},pdfkeywords={\@keyword}}%
  \typeout{mathorcup: bundled fonts only from \MATHORCUP@fontdir}%
}

\renewenvironment{abstract}{%
  \thispagestyle{empty}%
  \vspace*{-0.45cm}%
  \begin{center}
    \renewcommand{\arraystretch}{1.15}%
    \setlength{\tabcolsep}{0pt}%
    \begin{tabularx}{7.82cm}{|Y|Y|}
      \hline
      队伍编号 & \@bianhao \\
      \hline
      题号 & (\@tihao) \\
      \hline
    \end{tabularx}\par
  \end{center}
  \vspace{0.65cm}%
  \noindent\rule{\textwidth}{1pt}\par
  \vspace{0.75cm}%
  \begin{center}
    {\zihao{3}\heiti \@timu \par}
    \vspace{0.35cm}
    {\zihao{-3}\heiti 摘要 \par}
  \end{center}
  \vspace{0.35cm}%
  \setlength{\parindent}{2\ccwd}%
  \noindent\hspace*{2\ccwd}\ignorespaces
}{%
  \par
  \vspace{\baselineskip}%
  \noindent\textbf{关键词：}\@keyword
  \thispagestyle{empty}%
  \setcounter{page}{-1}%
  \newpage
  \thispagestyle{empty}%
}

% 附录扉页。正文用 \mathorcupappendix 即可，不必再手写字号。
\NewDocumentCommand{\mathorcupappendix}{}{%
  \clearpage
  \appendix
  \ctexset{section={format={\zihao{-4}\heiti\raggedright}}}%
  \begin{center}
    \heiti\zihao{4} 附\hspace{1pc}录
  \end{center}
}

\endinput
