" .vim/syntax/log.vim

if exists("b:current_syntax")
  finish
endif

"syn match	syslogText	/.*$/
"syn match	syslogFacility	/.\{-1,}:/	nextgroup=syslogText skipwhite
"syn match	syslogHost	/\S\+/	nextgroup=syslogFacility,syslogText skipwhite
"syn match	syslogDate	/^.\{-}\d\d:\d\d:\d\d/	nextgroup=syslogHost skipwhite
syn match   log_error 	'\c.*\<\(FATAL\|ERROR\|ERRORS\|FAIL\|FAILED\|FAILURE\).*'
syn match   log_warning 	'\c.*\<\(WARNING\|DELETE\|DELETING\|DELETED\|RETRY\|RETRYING\).*'
syn match   log_trace 	'\vT\@.*$'
"syn match   log_number 	'0x[0-9a-fA-F]*\|\[<[0-9a-f]\+>\]\|\<\d[0-9a-fA-F]*'
"syn match   log_time '\d\d:\d\d:\d\d\s*'
"syn match   log_time '\c\d\d:\d\d:\d\d\(\.\d\+\)\=\([+-]\d\d:\d\d\|Z\)'
"syn match   log_date '\(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\) [ 0-9]\d *'
"syn match   log_date '\d\{4}-\d\d-\d\d'
"syn region  log_string 	start=/'/ end=/'/ end=/$/ skip=/\\./
"syn region  log_string 	start=/"/ end=/"/ skip=/\\./
syn match   ipaddr /\(\(25\_[0-5]\|2\_[0-4]\_[0-9]\|\_[01]\?\_[0-9]\_[0-9]\?\)\.\)\{3\}\(25\_[0-5]\|2\_[0-4]\_[0-9]\|\_[01]\?\_[0-9]\_[0-9]\?\)/
"syn case ignore 
syn keyword syntaxElementKeyword  ret return accept https dns expires read write sock close closed free host null nil
syn keyword syntaxElementKeyword1 RET RETURN CONNECT ACCEPT TCP HTTP HTTPS FTP DNS EXPIRES READ WRITE SOCK GET CLOSE CLOSED FREE HOST NULL NIL
syn keyword syntaxElementKeyword2 fd policy wad\_helper\_del \_\_wad\_tcp\_port\_sched_write

if !exists("did_syslog_syntax_inits")
  let did_syslog_syntax_inits = 1
  "hi link syslogDate 	Comment
  "hi link syslogHost	Type
  "hi link syslogFacility	Statement
  "hi link syslogText 	String
  "hi link log_string 		String
  "hi link log_error 		ErrorMsg
  hi link log_error 		WarningMsg
  hi link log_warning 	WarningMsg
  hi link log_trace 	Comment
  "hi link log_number 		Number
  "hi link log_time 		Type
  "hi link log_date 		Constant
  hi link syntaxElementKeyword	Keyword
  hi link syntaxElementKeyword1	Keyword
  hi link syntaxElementKeyword2	Keyword
  hi link ipaddr Identifier
endif

let b:current_syntax = "log"
