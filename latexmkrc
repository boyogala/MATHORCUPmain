# MathorCup 模板 latexmk 配置：只需执行 `latexmk` 即可完成“按需编译”
# - 使用 xelatex；-synctex=0 关闭同步文件，加快编译并减少磁盘写入
# - latexmk 自动判断是否需要重跑 xelatex / bibtex，避免无脑跑 3 遍
$pdflatex = 'xelatex -interaction=nonstopmode -file-line-error -synctex=0 %O %S';
$bibtex   = 'bibtex %O %B';
$pdf_mode  = 5;   # 5 = xelatex
@default_files = ('main.tex');
$clean_ext = 'aux log out toc bbl blg fls fdb_latexmk synctex.gz xdv run.xml';
