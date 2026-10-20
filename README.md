# MathorCup 论文模板（mathorcup.cls）

本项目是一个**自完备（self-contained）**的 MathorCup 竞赛论文 LaTeX 模板。所有英文字体、中文字体与数学字体均来自项目内的 `fonts/` 目录，**不依赖操作系统字体，也不依赖 TeX Live 自带字体**。在任意安装了 XeLaTeX 的机器上，只要保留 `fonts/` 目录，即可直接编译生成 PDF。

---

## 1. 项目结构

```
MATHORCUPmain/
├── main.tex                 # 主文件（文档入口）
├── mathorcup.cls            # 类文件（所有排版与字体配置）
├── latexmkrc                # latexmk 一键编译配置（xelatex，按需重编）
├── .gitignore               # 忽略编译中间产物
├── references.bib           # 参考文献数据库
├── thesis-guet-base-ustc.bst# 参考文献样式
├── sections/                # 正文章节（按编号拆分，无 .aux 残留）
│   ├── 01-abstract.tex
│   ├── 02-problem-statement-and-analysis.tex
│   ├── ...
│   └── 08-conclusion.tex
├── figures/                 # 图片目录
├── fonts/                   # ★ 字体目录（自完备，必须保留，共 13 个，全部被引用）
│   ├── STIXTwoText-*.otf    # 英文衬线体（Regular/Bold/Italic/BoldItalic）
│   ├── STIXTwoMath-Regular.otf # 数学字体
│   ├── JetBrainsMono-*.ttf  # 等宽体（4 个，体积小，保留齐全防回退警告）
│   └── yzsong/yzhei/yzkai/yzfsong.ttf # 中文字体（宋体/黑体/楷体/仿宋）
└── README.md                # 本说明文档
```

> 说明：历史遗留的 `fdelted/`（未使用的 Medium/SemiBold 字重、旧 PowerShell 说明）与
> `sections/*.aux` 陈旧中间文件已删除；`fonts/` 内 13 个字体与类文件引用一一对应，
> 无冗余，不可再删（删任意一个都会导致编译失败或字体回退）。

---

## 2. 环境要求

- **编译器：必须使用 XeLaTeX**（`xelatex`）。本模板不支持 pdfLaTeX 或 LuaLaTeX。
- **TeX 发行版：** TeX Live 2020 及以上（或 MiKTeX 最新版），需包含 `ctex`、`fontspec`、`xeCJK`、`unicode-math`、`hyperref`、`natbib`、`caption`、`fancyhdr` 等宏包。
- **字体：** 无需安装任何字体到系统或 TeX Live，全部取自 `fonts/`。

检查 XeLaTeX 是否可用：

```bash
xelatex --version
```

---

## 3. 快速开始

### 3.1 编译命令（推荐）

在项目根目录（与 `main.tex` 同级）执行：

```bash
xelatex main.tex
bibtex main
xelatex main.tex
xelatex main.tex
```

或使用 `latexmk` 一键编译（推荐，自动判断重跑次数，增量编译无改动时瞬间跳过）：

```bash
latexmk
```

编译完成后得到 `main.pdf`。

### 3.1.1 编译加速技巧

- **日常写作**：`latexmk` 会跟踪文件变化，只重编必要的遍数；无改动时再次执行仅需约 0.04 秒（直接提示 up-to-date）。
- **草稿模式**：图片多时写作卡顿，可用 `\documentclass[draft]{mathorcup}`，图片只显示占位框而不嵌入，明显加快每一遍编译；定稿时去掉 `draft` 即可。
- **无算法正文**：若论文不使用 `algorithm` 环境，可用 `\documentclass[noalgo]{mathorcup}` 跳过 `algorithm2e` 的载入。
- **关闭同步文件**：`latexmkrc` 已默认 `-synctex=0`，减少磁盘写入；如需反向搜索可临时改回。
- **字体是主要耗时**：每遍编译约 0.8 秒，其中大部分时间在载入 `fonts/` 内 80MB+ 的中文字体，这是自完备的必要代价，无法再压；切勿为提速而删减字体或改用系统字体（会破坏跨机器一致性）。

### 3.2 重要注意事项

1. **编译工作目录必须是项目根目录**。字体路径在类文件中写为相对路径 `fonts/`，若在其它目录调用 `xelatex`，将无法找到字体。
2. **不要删除或移动 `fonts/` 目录**，它是模板自完备的核心。
3. 若修改了 `.bib` 文件，需重新执行 `bibtex main`。
4. 首次编译会出现“未定义引用/目录”警告，属于正常现象，按上述命令多编译几遍即可。

---

## 4. 字体自完备说明

本模板在 `mathorcup.cls` 中通过 `fontspec`/`xeCJK`/`unicode-math` 显式指定了所有字体文件，且均位于 `fonts/`：

| 用途 | 字体文件 | 说明 |
|------|----------|------|
| 英文衬线体（正文） | `STIXTwoText-Regular.otf` 等 | 替代 Times New Roman，TeX Live/系统无关 |
| 英文无衬线体 | `STIXTwoText-*.otf` | 项目内无专用 sans，回退到 STIX Two Text |
| 等宽体（代码） | `JetBrainsMono-*.ttf` | |
| 数学字体 | `STIXTwoMath-Regular.otf` | 替代老旧的 `newtxmath`，支持 Unicode 数学 |
| 中文宋体 | `yzsong.ttf`（永中宋体） | 对应 `\songti` |
| 中文黑体 | `yzhei.ttf`（永中黑体） | 对应 `\heiti` |
| 中文楷体 | `yzkai.ttf`（永中楷体） | 对应 `\kaishu` |
| 中文仿宋 | `yzfsong.ttf`（永中仿宋） | 对应 `\fangsong` |

**性能与更新优化点（v2.0 精简）：**

- 移除了老旧的 `newtxmath` 宏包（其底层 txfonts 数学字体集体积大、兼容性差），改为 `unicode-math` + STIX Two Math，数学符号更完整、渲染更快。
- 关闭了 `ctex` 默认字体集（`fontset=none`），避免其在编译时去搜索系统/TeX Live 字体，保证跨平台一致性。
- `hyperref` 严格最后载入；`algorithm2e` 由类在 `hyperref` 之前统一载入（之前在 `main.tex` 中后载入，会破坏算法内超链接，属于稳定性隐患，已修复）。
- 字体统一通过文件名 + `Path=fonts/` 直接加载，不走 fontconfig 按名搜索（更快、更稳定）。
- `main.tex` 由 `\include` 改为 `\input`：不再为每章生成独立 `.aux`，减少 I/O 与残留文件。
- 精简 `main.tex` 冗余命令：合并 `\newpage + \clearpage`，删除与类重复的 `\pagestyle{fancy}`。
- 新增 `latexmkrc` + `.gitignore`：一键按需编译，中间产物不污染目录。
- 删除 `fdelted/` 与 `sections/*.aux` 历史残留；`fonts/` 经核对 13 个文件全部被类引用，无可删项。

**实测数据**（本机，TeX Live 2023）：全量构建（3 遍 xelatex + 1 遍 bibtex）约 2.3–2.7 秒；
无改动增量构建约 0.04 秒。单遍编译耗时主要由中文字体载入决定，已触及下限。

---

## 5. 类文件提供的接口

### 5.1 论文元信息（在 `main.tex` 导言区设置）

```latex
\bianhao{MCxxxxxxx}      % 队伍编号
\tihao{A/B/C/D}          % 题号
\timu{论文标题}          % 标题
\keyword{关键词1;关键词2} % 关键词
```

### 5.2 标题层级

类文件已配置中文编号与格式：

- `\section{}` → 一、二、三…（四号黑体，居中）
- `\subsection{}` → 1.1、1.2…（小四号黑体，左对齐）
- `\subsubsection{}` → 1.1.1…（正常字号黑体，左对齐）

### 5.3 摘要环境

```latex
\begin{abstract}
\input{sections/01-abstract}
\end{abstract}
```

摘要页会自动输出队伍编号/题号表格、标题、摘要与关键词。

### 5.4 参考文献

```latex
\bibliographystyle{thesis-guet-base-ustc}
\bibliography{references}
```

引用命令：`\cite{key}`、`\citep{}`、`\citet{}`（natbib）。

### 5.5 图表与算法

- 图片目录：`figures/`，使用 `\includegraphics{...}`。
- 表格推荐 `booktabs`（`\toprule/\midrule/\bottomrule`）。
- 算法环境：`algorithm2e`（需在 `main.tex` 中 `\usepackage`，模板已演示）。
- 图表标题：黑体五号，悬挂格式。

---

## 6. 自定义与修改

### 6.1 修改字体

如需更换字体，只需将新字体文件放入 `fonts/`，并在 `mathorcup.cls` 中修改对应 `\set...font` 的文件名。**请确保所有字体均来自 `fonts/`，不要使用系统字体名。**

### 6.2 修改页边距/行距

- 页边距：类文件 `\RequirePackage[top=...,bottom=...,left=...,right=...]{geometry}`。
- 行距：`\LoadClass[...,linespread=1.25,...]{ctexart}`。

### 6.3 修改章节格式

所有章节标题格式集中在 `mathorcup.cls` 的 `\ctexset{...}` 中，修改此处即可全局生效。

---

## 7. 常见问题

**Q1：编译报 “Font not found” / “Cannot find font”？**  
A：检查是否在项目根目录编译；确认 `fonts/` 目录完整；不要删除字体文件。

**Q2：能否用 pdfLaTeX 编译？**  
A：不能。本模板依赖 XeTeX 的字体加载机制，必须使用 XeLaTeX。

**Q3：在其它电脑上编译结果字体不同？**  
A：不会。所有字体已内嵌在 `fonts/` 并被打包进 PDF，跨平台一致。

**Q4：参考文献未显示？**  
A：需执行 `bibtex main`，然后重新编译两次。

**Q5：目录/交叉引用未更新？**  
A：多编译几遍 XeLaTeX（至少两次）。

---

## 8. 许可与说明

本模板仅供 MathorCup 参赛与学习使用。字体文件版权归其原作者所有（STIX Two、JetBrains Mono、永中字库），使用时请遵守相应许可协议。
