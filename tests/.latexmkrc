$pdf_mode      = 1 ;
$out_dir       = "latex.out" ;
$pdf_previewer = "xdg-open" ;

# convert UTF-8 chars into LaTeX macros to prevent unknown char
# errors when using PDFLaTeX as this doesn't understand all of UTF-8
$biber         = "biber --output-safechars %O %S" ;
