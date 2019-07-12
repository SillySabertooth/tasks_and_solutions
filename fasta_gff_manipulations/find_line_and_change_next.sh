
### working fine!!!
## этот сед позволяет находить строки с КДС и в следующей строке менят слово gene на продукт. вторая команда позволяет это делать через две строки

sed -i '
  :1
  /[0-9]*	[0-9]*	CDS/ {
     n
     s/		gene	*/		product	/
     b1
  }' all_features_modif.txt


sed -i '
  :1
  /[0-9]*	[0-9]*	CDS/ {
     n
     /[0-9]*	[0-9]*/ {
     n
     s/		gene	*/		product	/
     b1
}
     b1
  }' all_features_modif.txt


#https://stackoverflow.com/questions/9291290/search-for-a-string-in-file-and-change-the-next-line-using-awk
#
#https://stackoverflow.com/questions/18620153/find-matching-text-and-replace-next-line/18622953#18622953
#
#https://stackoverflow.com/questions/20464726/replace-line-after-match?rq=1
#
#https://unix.stackexchange.com/questions/285160/how-to-edit-next-line-after-pattern-using-sed
