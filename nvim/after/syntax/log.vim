" Vim syntax file"
" Based on log-highlight.nvim by @fei6409
" https://github.com/fei6409/log-highlight.nvim

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Symbols / special characters
" ------------------------------
syn match logSymbol    display     '[!@#$%^&*;:?]'

" Separators
" ------------------------------
syn match logSeparatorLine  display     '-\{3,}\|=\{3,}\|#\{3,}\|\*\{3,}\|<\{3,}\|>\{3,}'

" Strings
" ------------------------------
syn region logString      start=/"/  end=/"/  end=/$/  skip=/\\./
syn region logString      start=/`/  end=/`/  end=/$/  skip=/\\./
" Quoted strings, but no match on quotes like `don't`, possessive `s'` and `'s`
syn region logString      start=/\(s\)\@<!'\(s \|t \)\@!/  end=/'/  end=/$/  skip=/\\./

" Numbers
" ------------------------------
syn match logNumber         display     '\<\d\+\>'
syn match logNumberFloat    display     '\<\d\+\.\d\+\([eE][+-]\?\d\+\)\?\>'
syn match logNumberBin      display     '\<0[bB][01]\+\>'
syn match logNumberOctal    display     '\<0[oO]\o\+\>'
syn match logNumberHex      display     '\<0[xX]\x\+\>'

" Numbers in Hardware Description Languages e.g. Verilog
" Note that this must come after logString to have a higher priority over it
syn match logNumber         display     '\'d\d\+\>'
syn match logNumberBin      display     '\'b[01]\+\>'
syn match logNumberOctal    display     '\'o\o\+\>'
syn match logNumberHex      display     '\'h\x\+\>'

" Constants
" ------------------------------
syn keyword logBool    TRUE True true FALSE False false
syn keyword logNull    NULL Null null

" Date & Time
" ------------------------------
" 2023-01-01 or 2023/01/01 or 01/01/2023 or 01-Jan-2023
syn match logDate       display     '\<\d\{4}[-\/]\(\d\d\|\a\{3}\)[-\/]\d\d\|\d\d[-\/]\(\d\d\|\a\{3}\)[-\/]\d\{4}'  contains=logDateMonth
" RFC3339 e.g. 2023-01-01T
syn match logDate       display     '\<\d\{4}-\d\d-\d\dT'
" YYYYMMDD starting with '20' e.g. 20230101
syn match logDate       display     '\<20\d{6}'
" Day 01-31
syn match logDateDay    display     '0[1-9]\|[1-2]\d\|3[0-1]\>'  contained

" 12:34:56 or 12:34:56.700000Z or 12:34:56.700000+08:00
syn match logTime       display     '\d\d:\d\d:\d\d\(\.\d\{2,6}\)\?'  skipwhite  nextgroup=logTimeZone,logTimeAMPM,logSysColumns
" AM / PM
syn match logTimeAMPM   display     '\cAM\|\cPM\>'  contained  skipwhite  nextgroup=logSysColumns
" Time zones, e.g. PST, CST etc.
syn match logTimeZone   display     'Z\|[+-]\d\d:\d\d\|\a\{3}\>'  contained  skipwhite  nextgroup=logSysColumns

syn keyword logDateMonth    Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec  nextgroup=logDateDay  skipwhite
syn keyword logDateWeekDay  Mon Tue Wed Thu Fri Sat Sun

" System info
" ------------------------------
" Match letters & digits, dots, underscores and hyphens in system columns.
" Usually the first column is the host name or log level keywords.
syn match logSysColumns     display     '\<[[:alnum:]\._-]\+ [[:alnum:]\._-]\+\(\[[[:digit:]:]\+\]\)\?:'  contained  contains=@logLvs,logSysProcess
syn match logSysProcess     display     '\<[[:alnum:]\._-]\+\(\[[[:digit:]:]\+\]\)\?:'  contained  contains=logNumber

" Objects
" ------------------------------
syn match logUrl        display     '\<https\?:\/\/\S\+'
syn match logIPv4       display     '\<\d\{1,3}\(\.\d\{1,3}\)\{3}\(\/\d\+\)\?\>'
syn match logIPv6       display     '\<\x\{1,4}\(:\x\{1,4}\)\{7}\(\/\d\+\)\?\>'
syn match logMacAddr    display     '\x\{2}\(:\x\{2}\)\{5}'
syn match logUUID       display     '\<\x\{8}-\x\{4}-\x\{4}-\x\{4}-\x\{12}\>'
syn match logMD5        display     '\<\x\{32}\>'
syn match logSHA        display     '\<\(\x\{40}\|\x\{56}\|\x\{64}\|\x\{96}\|\x\{128}\)\>'
" File path starting with '/' , './', '../' and '~/'.
" Must be start-of-line or prefixed with space
syn match logPath       display     '\(^\|\s\)\(\.\{0,2}\|\~\)\/[[:alnum:]\/\.:_-]\+'

" Log Levels
" ------------------------------
syn keyword logLvFatal      FATAL
syn keyword logLvEmergency  EMERGENCY EMERG
syn keyword logLvAlert      ALERT
syn keyword logLvCritical   CRITICAL CRIT
syn keyword logLvError      ERROR ERRORS ERR E error
syn keyword logLvFailure    FAILURE FAILED FAIL F
syn keyword logLvWarning    WARNING WARN W warning warn
syn keyword logLvNotice     NOTICE
syn keyword logLvInfo       INFO I info
syn keyword logLvDebug      DEBUG DBG D debug dbg
syn keyword logLvTrace      TRACE

" Composite log levels e.g. *_INFO
syn match logLvFatal        display '\<\u\+_FATAL\>'
syn match logLvEmergency    display '\<\u\+_EMERG\(ENCY\)\?\>'
syn match logLvAlert        display '\<\u\+_ALERT\>'
syn match logLvCritical     display '\<\u\+_CRIT\(ICAL\)\?\>'
syn match logLvError        display '\<\u\+_ERR\(\OR\)\?\>'
syn match logLvFailure      display '\<\u\+_FAIL\(URE\)\?\>'
syn match logLvWarning      display '\<\u\+_WARN\(ING\)\?\>'
syn match logLvNotice       display '\<\u\+_NOTICE\>'
syn match logLvInfo         display '\<\u\+_INFO\>'
syn match logLvDebug        display '\<\u\+_DEBUG\>'
syn match logLvTrace        display '\<\u\+_TRACE\>'

" spdlog pattern level: [trace] [info] ...
syn match logLvCritical     display '\[\zscritical\ze\]'
syn match logLvError        display '\[\zserror\ze\]'
syn match logLvWarning      display '\[\zswarning\ze\]'
syn match logLvInfo         display '\[\zsinfo\ze\]'
syn match logLvDebug        display '\[\zsdebug\ze\]'
syn match logLvTrace        display '\[\zstrace\ze\]'

syn cluster logLvs contains=logLvFatal,logLvEmergency,logLvAlert,logLvCritical,logLvError,logLvFailure,logLvWarning,logLvNotice,logLvInfo,logLvDebug,logLvTrace

" Highlight Links
" ------------------------------
hi def link logNumber           Number
hi def link logNumberFloat      Float
hi def link logNumberBin        Number
hi def link logNumberOctal      Number
hi def link logNumberHex        Number

hi def link logSymbol           Special
hi def link logSeparatorLine    Comment

hi def link logBool             Boolean
hi def link logNull             Constant
hi def link logString           String

hi def link logDate             Type
hi def link logDateDay          Type
hi def link logDateMonth        Type
hi def link logDateWeekDay      Type
hi def link logTime             Conditional
hi def link logTimeAMPM         Conditional
hi def link logTimeZone         Conditional

hi def link logSysColumns       Statement
hi def link logSysProcess       Function

hi def link logUrl              @markup.link.url
hi def link logIPv4             @markup.link.url
hi def link logIPv6             @markup.link.url
hi def link logMacAddr          Label
hi def link logUUID             Label
hi def link logMD5              Label
hi def link logSHA              Label
hi def link logPath             String

hi def link logLvFatal          ErrorMsg
hi def link logLvEmergency      ErrorMsg
hi def link logLvAlert          ErrorMsg
hi def link logLvCritical       ErrorMsg
hi def link logLvError          ErrorMsg
hi def link logLvFailure        ErrorMsg
hi def link logLvWarning        WarningMsg
hi def link logLvNotice         Exception
hi def link logLvInfo           MoreMsg
hi def link logLvDebug          Debug
hi def link logLvTrace          Comment


let b:current_syntax = "log"

let &cpo = s:cpo_save
unlet s:cpo_save
