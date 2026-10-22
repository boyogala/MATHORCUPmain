# MathorCup 论文模板使用说明

版本：`mathorcup.cls` v3.1  
编译器：只支持 XeLaTeX  
字体：只使用本仓库 `fonts/`，不使用操作系统字体，也不使用 TeX Live 自带字体。全部为可免费商用的开源字体（SIL Open Font License 1.1）。

把本仓库拷到另一台电脑后，只要安装了 TeX Live 2020 或更新版本（含 `ctex`、`fontspec`、`xeCJK`、`unicode-math`），在项目根目录执行 `latexmk` 或 `xelatex`，得到的 PDF 字形与本机一致。

示例论文标题是「基于多目标优化的城市配送路径规划研究」。编译成功后的 `main.pdf` 为 A4、7 页：摘要页不计页码，目录后的正文从「第 1 页」开始。

---

## 微信公众号：博優旮旯-BOYOGALA

本项目的作者有同名公众号，欢迎扫码关注作者的微信公众号：

<p align="center"><img src="figures/boyogala.png" width="64%"></p>

一起走进优化求解器与数值计算的科普分享.


---

## 1. 先看这个：三步编译

在项目根目录操作。根目录指同时能看到 `main.tex`、`mathorcup.cls` 和 `fonts/` 的那一层。

```bash
cd /path/to/MATHORCUPmain
latexmk
```

没有 `latexmk` 时，按这个顺序手动跑：

```bash
xelatex -interaction=nonstopmode main.tex
bibtex main
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex
```

成功标志有三条：

1. 终端最后一行类似 `Output written on main.pdf (7 pages).`
2. 日志里有一行 `mathorcup: bundled fonts only from fonts/`。
3. 用下面的命令检查，输出里只能出现 `SourceHanSerif`、`SourceHanSans`、`LXGWWenKai`、`ZhuqueFangsong`、`STIXTwo`、`JetBrainsMono`，不能出现 `Fandol`、`CMR`、`LatinModern`、`TeXGyre`。

```bash
pdffonts main.pdf
```

无改动时再执行 `latexmk`，大约 0.05 秒结束，并提示 `All targets (main.pdf) are up-to-date`。全量编译大约 3 秒，时间主要花在打开 `fonts/` 里约 110MB 的中文字体上。

---

## 2. 目录里每个文件干什么

```
MATHORCUPmain/
├── main.tex                         入口。只改元信息和章节 \input
├── mathorcup.cls                    字体、页边距、标题、页脚、摘要页、定理环境
├── latexmkrc                        已写好的 xelatex 编译配置
├── references.bib                   文献数据库
├── thesis-guet-base-ustc.bst        参考文献样式，一般不要改
├── sections/
│   ├── 01-abstract.tex              摘要正文，不要写 \section
│   ├── 02-problem-statement-and-analysis.tex
│   ├── 03-assumptions-and-notation.tex
│   ├── 04-model-formulation.tex
│   ├── 05-solution-method.tex       含 algorithm 示例
│   ├── 06-results-analysis.tex      含 figure 示例
│   ├── 07-model-validation-and-extension.tex
│   └── 08-conclusion.tex
├── figures/                         图片只放这里
├── fonts/                           15 个字体 + OFL.txt，缺一不可
├── .gitignore                       忽略 aux/log/toc 等中间文件
├── .gitattributes                   字体按二进制保存，tex 用 LF
├── LICENSE                          模板代码的 MIT 许可（字体另见 fonts/OFL.txt）
└── README.md                        本说明
```

章节用 `\input`，不是 `\include`。所以 `sections/` 里不应出现 `.aux`。新增一章时，新建 `sections/09-xxx.tex`，再在 `main.tex` 的 `\bibliography` 之前加一行 `\input{sections/09-xxx}`。

---

## 3. 环境要求

### 3.1 必须满足

| 项目 | 要求 |
|------|------|
| 引擎 | `xelatex`。`pdflatex`、`lualatex` 会在类文件开头报错并停止 |
| 发行版 | TeX Live 2020 及以上，或较新的 MiKTeX |
| 编码 | UTF-8。不要把 `main.tex` 存成 GBK |
| 工作目录 | 项目根目录。不要在 `sections/` 里编译 |
| 字体 | 不要安装到系统，也不要放进 `texmf-local` |

类文件依赖这些宏包，它们随 TeX Live 提供，不是字体：`ctex`、`fontspec`、`xeCJK`、`unicode-math`、`amsmath`、`amsthm`、`geometry`、`fancyhdr`、`lastpage`、`booktabs`、`tabularx`、`graphicx`、`caption`、`float`、`placeins`、`xcolor`、`natbib`、`algorithm2e`、`hyperref`、`bookmark`。

检查命令：

```bash
xelatex --version
kpsewhich ctexart.cls unicode-math.sty algorithm2e.sty
```

两条都能给出路径即可。

### 3.2 Linux

```bash
cd /path/to/MATHORCUPmain
latexmk
```

若提示找不到 `latexmk`，安装 TeX Live 的 `latexmk` 包，或改用上一节的四条 `xelatex`/`bibtex` 命令。

### 3.3 Windows

用 TeX Live 或 MiKTeX 自带的命令行，不要用 pdfLaTeX 按钮。

```powershell
cd D:\path\to\MATHORCUPmain
latexmk
```

TeXworks / VS Code 的 LaTeX Workshop 请把 recipe 设为 `xelatex` 或 `latexmk`。默认的 `pdflatex` 会失败，这是预期行为。

### 3.4 从别的目录调用

可以：

```bash
latexmk /path/to/MATHORCUPmain/main.tex
```

`latexmkrc` 里有 `$do_cd = 1`，会先切到 `main.tex` 所在目录再找 `fonts/`。

不要这样：

```bash
cd /tmp
xelatex /path/to/MATHORCUPmain/main.tex
```

裸 `xelatex` 不会自动切换目录，会报 `Missing bundled font fonts/STIXTwoText-Regular.otf`。

---

## 4. 字体：文件、命令、禁止事项

类在排版前检查下表全部文件。缺一个就停止，不会改用 Fandol 或宋体的系统版本。

英文与数学字体：

| 文件名 | 谁在用 |
|--------|--------|
| `fonts/STIXTwoText-Regular.otf` | 英文正文、数学 `\mathrm` |
| `fonts/STIXTwoText-Bold.otf` | `\textbf`、数学 `\mathbf` |
| `fonts/STIXTwoText-Italic.otf` | 英文 `\textit`、数学 `\mathit` |
| `fonts/STIXTwoText-BoldItalic.otf` | 英文粗斜体 |
| `fonts/STIXTwoMath-Regular.otf` | 公式符号、希腊字母、求和积分 |
| `fonts/JetBrainsMono-Regular.ttf` | `\texttt`、数学 `\mathtt` |
| `fonts/JetBrainsMono-Bold.ttf` | 等宽粗体 |
| `fonts/JetBrainsMono-Italic.ttf` | 等宽斜体 |
| `fonts/JetBrainsMono-BoldItalic.ttf` | 等宽粗斜体 |

中文字体（全部为开源免费商用字体）：

| 文件名 | 字样 | 谁在用 |
|--------|------|--------|
| `fonts/SourceHanSerifSC-Regular.otf` | 思源宋体 | 中文正文，命令 `\songti` |
| `fonts/SourceHanSerifSC-Bold.otf` | 思源宋体 Bold | 中文 `\textbf` |
| `fonts/SourceHanSansSC-Regular.otf` | 思源黑体 | 标题和中文无衬线，命令 `\heiti` |
| `fonts/SourceHanSansSC-Bold.otf` | 思源黑体 Bold | 黑体加粗、仿宋与楷体的粗体回退 |
| `fonts/LXGWWenKai-Regular.ttf` | 霞鹜文楷 | 命令 `\kaishu`；中文 `\textit` 也用它 |
| `fonts/ZhuqueFangsong-Regular.ttf` | 朱雀仿宋 | 命令 `\fangsong`；中文等宽 |

四种中文字样的对应关系：

| 命令 | 印出来的字样 | 用的字体 |
|------|--------------|----------|
| `\songti` | 宋体 | 思源宋体 |
| `\heiti` | 黑体 | 思源黑体 |
| `\kaishu` | 楷体 | 霞鹜文楷 |
| `\fangsong` | 仿宋 | 朱雀仿宋 |

仓库里没有 Helvetica、Arial，也没有 STIX 的 Medium / SemiBold。英文无衬线 `\textsf` 使用 STIX Two Text，这是故意的，避免去系统里搜字。

中文没有单独的斜体文件。`\textit{中文}` 会变成楷体（霞鹜文楷），不是缺字。`\textbf{中文}` 会变成宋体加粗（思源宋体 Bold）。

霞鹜文楷和朱雀仿宋只提供 Regular 一个字重，所以 `\kaishu`、`\fangsong` 里的粗体回退到思源黑体 Bold。

下面这些写法会破坏自完备，不要加进 `main.tex` 或章节：

```latex
\documentclass[fontset=windows]{mathorcup}   % 类会报错并停止
\documentclass[fontset=fandol]{mathorcup}    % 同上
\usepackage{newtxmath}                        % 会去用 TeX Live 的 tx 字体
\usepackage{fontspec}                         % 类已经加载，再加载会冲突
\setmainfont{Times New Roman}                 % 系统字体
\setCJKmainfont{SimSun}                       % 系统字体
```

换字体的唯一做法：把新的 `.otf` 或 `.ttf` 放进 `fonts/`，同时改 `mathorcup.cls` 里两处——`\clist_map_inline:nn` 的检查列表，以及对应的 `\setmainfont` / `\setCJKmainfont` / `\setmathfont`。只改一处不够。

字体不在相对路径 `fonts/` 时，只能在 `\documentclass` 之前覆盖目录，且路径必须以 `/` 结尾：

```latex
\def\mathorcupfontdir{/absolute/path/fonts/}
\documentclass{mathorcup}
```

一般不需要这行。

---

## 5. 改论文内容

### 5.1 封面信息

打开 `main.tex`，只改这四行。当前是占位符：

```latex
\bianhao{MCxxxxxxx}
\tihao{A/B/C/D}
\timu{基于多目标优化的城市配送路径规划研究}
\keyword{多目标优化;路径规划;时窗约束;配送调度}
```

也可以写成一条：

```latex
\mathorcupsetup{
  bianhao = MC2026001,
  tihao   = A,
  timu    = 论文标题,
  keyword = 关键词1;关键词2;关键词3
}
```

`\timu` 传纯文本，不要再套 `\parbox`。类会居中排版，并把这段文字写入 PDF 标题。关键词用中文分号或英文分号均可，模板示例用的是英文分号。

摘要页会印出：

```
队伍编号    MCxxxxxxx
题号        (A/B/C/D)
————————————
        论文标题
          摘要
（sections/01-abstract.tex 的正文）
关键词：……
```

`01-abstract.tex` 里不要写 `\section`、`\begin{abstract}` 或「摘要」二字。直接写段落。摘要页无页码，不计入「第 1 页」。

### 5.2 正文章节

现有结构可以保留，只替换文字：

| 文件 | 现在的 `\section` |
|------|-------------------|
| `02-problem-statement-and-analysis.tex` | 问题重述、问题分析 |
| `03-assumptions-and-notation.tex` | 模型假设与符号说明 |
| `04-model-formulation.tex` | 模型建立 |
| `05-solution-method.tex` | 模型求解 |
| `06-results-analysis.tex` | 结果分析 |
| `07-model-validation-and-extension.tex` | 模型检验与推广 |
| `08-conclusion.tex` | 结论 |

标题格式由类固定，正文里不要再写字号：

| 命令 | 印出来的样子 | 字体 |
|------|----------------|------|
| `\section{问题重述}` | 一、问题重述 | 四号黑体，居中 |
| `\subsection{任务结构拆解}` | 1.1 任务结构拆解 | 小四黑体，左齐 |
| `\subsubsection{目标层次}` | 1.1.1 目标层次 | 小四黑体，左齐 |

目录只收到 `\subsection`。`\subsubsection` 仍编号，但不进目录。这是 `tocdepth=2` 的设定。

### 5.3 公式

`04-model-formulation.tex` 里已有可抄的写法：

```latex
\begin{equation}
    \min Z = \sum_{k \in K} \sum_{i \in V} \sum_{j \in V} c_{ij} x_{ijk}
             + \lambda \sum_{i \in V} s_i ,
    \label{eq:objective}
\end{equation}
```

正文引用写 `式~\eqref{eq:objective}`。不要 `\usepackage{amsmath}`，类已经加载。

公式中的汉字会用宋体。英文函数名用 `\mathrm`，代码式符号用 `\mathtt`，它们都指向 `fonts/`。

### 5.4 表格

`03-assumptions-and-notation.tex` 的符号表可以直接扩行。三线表用 `booktabs`，不要用竖线。

```latex
\begin{table}[htbp]
    \centering
    \caption{主要符号说明}
    \label{tab:symbols}
    \begin{tabular}{cc}
        \toprule
        符号 & 含义 \\
        \midrule
        $V$ & 客户节点集合 \\
        \bottomrule
    \end{tabular}
\end{table}
```

引用写 `表~\ref{tab:symbols}`。题注是黑体五号，标签和标题之间是一个空格，不是冒号。

列需要自动换行时用 `tabularx`。类定义了居中列类型 `Y`：

```latex
\begin{tabularx}{\textwidth}{YY}
  ...
\end{tabularx}
```

### 5.5 图片

把 `result.png` 放进 `figures/`，不要写 `figures/result.png`。类已经设置了 `\graphicspath{{figures/}}`。

```latex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.82\textwidth]{result.png}
    \caption{算法流程或结果示意图}
    \label{fig:result}
\end{figure}
```

引用写 `图~\ref{fig:result}`。优先用 `[htbp]`。示例里的 `[H]` 可以强制就地放置，图很多时容易把后文顶到下一页，编译也更慢。

写作阶段如果图片很大，把 `main.tex` 第一行改成：

```latex
\documentclass[draft]{mathorcup}
```

此时图片只显示占位框，不嵌入文件。交稿前改回 `\documentclass{mathorcup}`。

支持的常见格式：`pdf`、`png`、`jpg`。不要用 `eps`。

### 5.6 算法

`algorithm2e` 已由类加载，选项是 `ruled,vlined,linesnumbered,noend`。不要在 `main.tex` 再写 `\usepackage{algorithm2e}`。

照抄 `sections/05-solution-method.tex`：

```latex
\begin{algorithm}[H]
\caption{示意性求解流程}
\KwIn{客户节点集合、车辆集合、距离矩阵与约束参数}
\KwOut{满足约束的配送方案}
初始化可行解与参数配置\;
根据目标函数计算当前方案适应度\;
循环执行邻域搜索或启发式更新，直到满足停止条件\;
输出当前最优方案并记录关键指标\;
\end{algorithm}
```

每行末尾的 `\;` 是 `algorithm2e` 的换行，不能省。若全文没有算法，可改成 `\documentclass[noalgo]{mathorcup}`，少加载一个宏包。此时再写 `algorithm` 环境会报 `Environment algorithm undefined`。

### 5.7 定理、定义、假设

这些环境已经定义，按当前 `\section` 编号，例如第一节里的第一条定理是「定理 1.1」。正文用正体，避免中文被排成楷体。

```latex
\begin{theorem}[容量可行]
任一车辆的载重不超过 $Q_k$。
\end{theorem}

\begin{definition}
$x_{ijk}=1$ 表示车辆 $k$ 从节点 $i$ 驶向节点 $j$。
\end{definition}

\begin{assumption}
规划周期内车辆不发生故障。
\end{assumption}

\begin{remark}
权重 $\lambda$ 由灵敏度分析确定。
\end{remark}
```

可用名字：`theorem` 定理、`lemma` 引理、`proposition` 命题、`corollary` 推论、`definition` 定义、`assumption` 假设、`remark` 注。它们共用一个计数器。

### 5.8 参考文献

文献写在 `references.bib`，不要写在正文末尾。现有两条：

```bibtex
@article{dantzig_ramser_1959,
  title   = {The Truck Dispatching Problem},
  author  = {Dantzig, George B. and Ramser, John H.},
  journal = {Management Science},
  year    = {1959}
}
```

正文引用：

```latex
\cite{dantzig_ramser_1959}
\cite{dantzig_ramser_1959,solomon_1987_vrptw}
```

第二条会排成压缩编号。作者-年份命令 `\citet`、`\citep` 也能用，但样式文件是数字制，正式论文请用 `\cite`。

`main.tex` 末尾已经有：

```latex
\phantomsection
\addcontentsline{toc}{section}{参考文献}
\bibliography{references}
```

改了 `.bib` 之后必须重新跑 `bibtex main`，或再执行一次 `latexmk`。只跑一遍 `xelatex` 时，引用会显示成问号，这是正常的，不是样式坏了。

### 5.9 附录

`main.tex` 里用的是：

```latex
\mathorcupappendix
```

它会另起一页，打印「附　录」，并把后面的 `\section` 改成附录编号。补充材料直接写在这条命令后面，或 `\input{sections/09-appendix}`。

---

## 6. 页面上固定的版式

这些数在 `mathorcup.cls` 里，改一处即可，不用逐章改。

| 项目 | 当前值 |
|------|--------|
| 纸张 | A4，单面 |
| 页边距 | 上 2cm，下 2cm，左 2.5cm，右 2.5cm |
| 正文 | 小四（`zihao=-4`），行距 1.25 倍 |
| 页眉线 | 无 |
| 页脚 | 第 X 页 共 Y 页，居中 |
| 链接 | 正文链接黑色，引用和 URL 蓝色 |
| PDF 作者 | 空。不会写入操作系统用户名 |
| PDF 标题 | 等于 `\timu` |

摘要页的队伍编号表宽 7.82cm。这是旧模板留下的尺寸，改宽度只改类文件里 `tabularx{7.82cm}` 那一处。

---

## 7. 类选项

只支持两个选项，可以同时用。

```latex
\documentclass{mathorcup}
\documentclass[draft]{mathorcup}
\documentclass[noalgo]{mathorcup}
\documentclass[draft,noalgo]{mathorcup}
```

| 选项 | 效果 |
|------|------|
| `draft` | 图片不嵌入，超宽盒子会显示黑条。交稿前必须去掉 |
| `noalgo` | 不加载 `algorithm2e` |

`fontset=...`、`GBK` 不要传。未知且不含 `fontset` 的选项会交给 `ctexart`，例如一般不需要的 `twoside`。

---

## 8. 编译加速和清理

日常只执行：

```bash
latexmk
```

清理中间文件，保留 PDF：

```bash
latexmk -c
```

连 PDF 一起删：

```bash
latexmk -C
```

被 `.gitignore` 忽略、不要提交的文件：`*.aux`、`*.log`、`*.out`、`*.toc`、`*.bbl`、`*.blg`、`*.fls`、`*.fdb_latexmk`、`*.xdv`、`*.synctex.gz`。`main.pdf` 作为样例保留在仓库里。

`latexmkrc` 已关闭 SyncTeX（`-synctex=0`），少写一个同步文件。若编辑器需要反向搜索，把 `latexmkrc` 里的 `-synctex=0` 改成 `-synctex=1`。

不要为了提速安装系统字体，也不要删除 `SourceHanSerifSC-Regular.otf` 等大文件。那 110MB 是每次编译的主要成本，也是换电脑后字形不变的原因。

---

## 9. 出错时对照

**`XeLaTeX is required`**  
当前按钮或命令是 pdfLaTeX / LuaLaTeX。改成 `xelatex main.tex` 或 `latexmk`。

**`Missing bundled font fonts/xxx`**  
不在项目根目录，或 `fonts/` 少了文件。执行 `ls fonts | wc -l`，结果必须是 16（15 个字体 + 1 份 `OFL.txt`）。然后 `cd` 到根目录重编。

**`Option fontset=windows is disabled`**  
删掉 `fontset` 选项。类固定 `fontset=none`。

**`Environment algorithm undefined`**  
使用了 `noalgo`，但又写了 `algorithm` 环境。去掉该选项。

**`Citation ... undefined` 或正文里是 `[?]`**  
还没跑 `bibtex`。执行 `latexmk`，或手动 `bibtex main` 后再跑两遍 `xelatex`。

**`Reference LastPage undefined`、目录为空**  
第一遍编译的正常警告。再编译一遍即可。`latexmk` 会自己重跑。

**`Font shape ... undefined` 且 PDF 里出现 `Fandol` 或 `CMR`**  
类被改过，或某处调用了不带 `Path=fonts/` 的 `\setmainfont`。用 `pdffonts main.pdf` 核对。未改类文件时，不应出现这两种字体。

**中文变成方框，但日志没有 Missing font**  
文件不是 UTF-8，或编辑器按 GBK 保存。把 `main.tex` 和 `sections/*.tex` 转为 UTF-8 无 BOM。

**另一台电脑字形不同**  
确认编译日志有 `bundled fonts only from fonts/`，并用 `pdffonts` 核对。若出现系统字体名，说明没有使用本仓库的 `mathorcup.cls`，或 `fonts/` 不完整。

---

## 10. 交稿前检查

1. `\bianhao` 改成正式队伍编号，`\tihao` 改成实际题号。
2. 去掉 `draft`。
3. 在项目根目录执行 `latexmk -C && latexmk`。
4. PDF 能打开，页脚「共 Y 页」与实际页数一致，引用不是问号。
5. `pdffonts main.pdf` 只有 `fonts/` 里的字体。
6. 不要把 `.aux`、`.log`、token、密码写进仓库。

---

## 11. 许可

模板代码采用 MIT 许可，见仓库根目录的 `LICENSE`。仓库里所有字体的版权归原作者，使用时遵守各自许可。本说明不授予这些字体的额外权利。

随附字体的完整许可文本见 `fonts/OFL.txt`，再分发 `fonts/` 时请一并保留该文件。

| 字体 | 许可 | 来源 |
|------|------|------|
| 思源宋体 Source Han Serif SC | SIL Open Font License 1.1 | Adobe，https://github.com/adobe-fonts/source-han-serif |
| 思源黑体 Source Han Sans SC | SIL Open Font License 1.1 | Adobe，https://github.com/adobe-fonts/source-han-sans |
| 霞鹜文楷 LXGW WenKai | SIL Open Font License 1.1 | LXGW，https://github.com/lxgw/LxgwWenKai |
| 朱雀仿宋 Zhuque Fangsong | SIL Open Font License 1.1 | 璇玑造字，https://github.com/TrionesType/zhuque |
| STIX Two Text / STIX Two Math | SIL Open Font License 1.1 | https://github.com/stipub/stixfonts |
| JetBrains Mono | SIL Open Font License 1.1 | https://github.com/JetBrains/JetBrainsMono |

OFL 1.1 允许免费商用、复制、再分发和修改，但不得单独出售字体文件；修改后的版本必须同样以 OFL 公开，并且不能使用原字体保留名称（思源的保留名称是 `Source`，霞鹜文楷是 `霞鹜` / `LXGW` 等）。这些字体均来自官方公开发布的发行包，未作修改。
