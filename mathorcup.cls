% !TeX program = xelatex
% !TeX encoding = UTF-8
\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{mathorcup}[2026/10/20 v2.0 MathorCup template class (self-contained fonts)]

% -----------------------------------------------------------------------
% 类选项（稳定性 + 编译速度）：
%   draft  : 草稿模式，图片只占框不嵌入，迭代编译更快；定稿时去掉该选项
%   noalgo : 不载入 algorithm2e（如正文无算法），减少宏包开销
%   其他选项原样透传给 ctexart（如 oneside / twoside 等）
% -----------------------------------------------------------------------
\newif\ifmathorcup@algo \mathorcup@algotrue
\DeclareOption{draft}{\PassOptionsToClass{draft}{ctexart}\PassOptionsToPackage{draft}{graphicx}}
\DeclareOption{noalgo}{\mathorcup@algofalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexart}}
\ProcessOptions\relax

% -----------------------------------------------------------------------
% 基础文档类：关闭 ctex 的系统字体集，所有 CJK 字体稍后从 ./fonts/ 指定
% （fontset=none 避免编译时搜索系统/TeX Live 字体，保证跨机器一致）
% -----------------------------------------------------------------------
\LoadClass[oneside,a4paper,UTF8,linespread=1.25,zihao=-4,fontset=none]{ctexart}

% -----------------------------------------------------------------------
% 通用宏包（注意：hyperref 必须最后载入，见文件后部）
% 顺序要求：amsmath -> unicode-math；float -> algorithm2e -> hyperref
% -----------------------------------------------------------------------
\RequirePackage[top=2cm,bottom=2cm,left=2.5cm,right=2.5cm]{geometry}
\RequirePackage{fancyhdr,lastpage}
\RequirePackage{amsmath}
% 数学字体：STIX Two Math（文件自带），替代老旧的 newtxmath
\RequirePackage{unicode-math}
\RequirePackage{booktabs,tabularx,array}
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage{float}
\RequirePackage[section]{placeins}
\RequirePackage{xcolor}
\RequirePackage[numbers,sort&compress]{natbib}
% 算法环境必须在 hyperref 之前载入，否则算法内超链接/交叉引用不稳定
\ifmathorcup@algo
  \RequirePackage[ruled,vlined,linesnumbered,noend]{algorithm2e}
\fi
% hyperref 严格最后载入，减少重定义冲突与警告
\RequirePackage{hyperref}

% -----------------------------------------------------------------------
% 字体自完备配置：仅使用项目 fonts/ 目录中的字体文件
% 文件名显式指定 + Path，避免走 fontconfig 按名搜索（更快、更稳定）
% -----------------------------------------------------------------------
\newcommand{\MATHORCUP@fontdir}{fonts/}

% 英文衬线体：STIX Two Text
\setmainfont{STIXTwoText-Regular.otf}[
  Path            = \MATHORCUP@fontdir,
  BoldFont        = STIXTwoText-Bold.otf,
  ItalicFont      = STIXTwoText-Italic.otf,
  BoldItalicFont  = STIXTwoText-BoldItalic.otf
]

% 英文无衬线体：项目内无专用 sans，回退到 STIX Two Text，保持自完备
\setsansfont{STIXTwoText-Regular.otf}[
  Path            = \MATHORCUP@fontdir,
  BoldFont        = STIXTwoText-Bold.otf,
  ItalicFont      = STIXTwoText-Italic.otf,
  BoldItalicFont  = STIXTwoText-BoldItalic.otf
]

% 等宽体：JetBrains Mono
\setmonofont{JetBrainsMono-Regular.ttf}[
  Path            = \MATHORCUP@fontdir,
  BoldFont        = JetBrainsMono-Bold.ttf,
  ItalicFont      = JetBrainsMono-Italic.ttf,
  BoldItalicFont  = JetBrainsMono-BoldItalic.ttf
]

% 数学字体：STIX Two Math
\setmathfont{STIXTwoMath-Regular.otf}[
  Path = \MATHORCUP@fontdir
]

% 中文字体：永中字库（yz*），全部来自 fonts/
\setCJKmainfont{yzsong.ttf}[
  Path      = \MATHORCUP@fontdir,
  BoldFont  = yzhei.ttf,
  ItalicFont= yzkai.ttf
]
\setCJKsansfont{yzhei.ttf}[
  Path      = \MATHORCUP@fontdir
]
\setCJKmonofont{yzfsong.ttf}[
  Path = \MATHORCUP@fontdir
]

\setCJKfamilyfont{zhsong}{yzsong.ttf}[
  Path      = \MATHORCUP@fontdir,
  BoldFont  = yzhei.ttf
]
\setCJKfamilyfont{zhhei}{yzhei.ttf}[
  Path = \MATHORCUP@fontdir
]
\setCJKfamilyfont{zhkai}{yzkai.ttf}[
  Path = \MATHORCUP@fontdir
]
\setCJKfamilyfont{zhfs}{yzfsong.ttf}[
  Path = \MATHORCUP@fontdir
]

\NewDocumentCommand{\songti}{ }{\CJKfamily{zhsong}}
\NewDocumentCommand{\heiti}{ }{\CJKfamily{zhhei}}
\NewDocumentCommand{\kaishu}{ }{\CJKfamily{zhkai}}
\NewDocumentCommand{\fangsong}{ }{\CJKfamily{zhfs}}

% -----------------------------------------------------------------------
% ctex 标题格式
% -----------------------------------------------------------------------
\ctexset{
    section = {
        format = {\zihao{4}\heiti\centering},
        name = {,、},
        aftername = {\hspace{0.5em}},
        number = \chinese{section},
        beforeskip = 1.2\baselineskip,
        afterskip = 0.6\baselineskip
    },
    subsection = {
        format = {\zihao{-4}\heiti\raggedright},
        name = {},
        aftername = {\hspace{0.5em}},
        number = {\arabic{section}.\arabic{subsection}},
        beforeskip = 0.9\baselineskip,
        afterskip = 0.4\baselineskip
    },
    subsubsection = {
        format = {\normalsize\heiti\raggedright},
        name = {},
        aftername = {\hspace{0.5em}},
        number = {\arabic{section}.\arabic{subsection}.\arabic{subsubsection}},
        beforeskip = 0.7\baselineskip,
        afterskip = 0.3\baselineskip
    },
    appendix = {
        name = {附录,：},
        number = \Alph{section}
    }
}

% -----------------------------------------------------------------------
% 其他排版设置
% -----------------------------------------------------------------------
\newcommand{\bstlabelmark}{99}
\newcolumntype{Y}{>{\centering\arraybackslash}X}
\graphicspath{{figures/}}

\captionsetup{format=hang}
\DeclareCaptionLabelSeparator*{sspace}{\ \ }
\captionsetup[figure]{labelsep=sspace}
\captionsetup[table]{labelsep=sspace}
\DeclareCaptionFont{heiti}{\heiti}
\DeclareCaptionFont{5hao}{\zihao{5}}
\captionsetup{labelfont={heiti,5hao},textfont={heiti,5hao}}

\pagestyle{fancy}
\fancyhf{}
\renewcommand\headrulewidth{0pt}
\fancyfoot[C]{第 \thepage{} 页 共 \pageref{LastPage} 页}

\hypersetup{
    breaklinks=true,
    colorlinks=true,
    linkcolor=black,
    citecolor=blue,
    urlcolor=blue,
    bookmarksnumbered=true,
    bookmarksopen=true,
    pdfstartview=Fit
}

% -----------------------------------------------------------------------
% 论文元信息命令
% -----------------------------------------------------------------------
\def\bianhao#1{\gdef\@bianhao{#1}}
\def\tihao#1{\gdef\@tihao{#1}}
\def\timu#1{\gdef\@timu{#1}}
\def\keyword#1{\gdef\@keyword{#1}}

\renewenvironment{abstract}{%
\thispagestyle{empty}
\vspace*{-0.45cm}
\begin{center}
    {\renewcommand{\arraystretch}{1.15}%
    \setlength{\tabcolsep}{0pt}%
    \begin{tabularx}{7.82cm}{|Y|Y|}
        \hline
        队伍编号 & \@bianhao \\
        \hline
        题号 & (\@tihao) \\
        \hline
    \end{tabularx}\par}
\end{center}
\vspace{0.65cm}
\noindent\rule{\textwidth}{1pt}\par
\vspace{0.75cm}
\begin{center}
    {\zihao{3}\heiti \@timu \par}
    \vspace{0.35cm}
    {\zihao{-3}\heiti 摘要 \par}
\end{center}
\vspace{0.35cm}
\setlength{\parindent}{2\ccwd}%
\noindent\hspace*{2\ccwd}\ignorespaces
}{%
\par
\vspace{\baselineskip}
\noindent\textbf{关键词：}\@keyword
\thispagestyle{empty}
\setcounter{page}{-1}
\newpage
\thispagestyle{empty}
}

\endinput
