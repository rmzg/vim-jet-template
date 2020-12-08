" Jet & Handlebars syntax
" Language:	Jet, Handlebars
" Maintainer:	Juvenn Woo <machese@gmail.com>
" Screenshot:   http://imgur.com/6F408
" Version:	6
" Last Change:  Jul 16 2019
" Remark:
"   It lexically hilights embedded jets (exclusively) in html file.
"   While it was written for Ruby-based Jet template system, it should
"   work for Google's C-based *ctemplate* as well as Erlang-based *et*. All
"   of them are, AFAIK, based on the idea of ctemplate.
" References:
"   [Jet](http://github.com/defunkt/jet)
"   [Handlebars](https://github.com/wycats/handlebars.js)
"   [ctemplate](http://code.google.com/p/google-ctemplate/)
"   [ctemplate doc](http://google-ctemplate.googlecode.com/svn/trunk/doc/howto.html)
"   [et](http://www.ivan.fomichev.name/2008/05/erlang-template-engine-prototype.html)
" TODO: Feedback is welcomed.


" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Standard HiLink will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syntax match jetError '}}}\?'
syntax match jetInsideError '{{[{$#<>=!\/]\?'

syntax region jetComponent start=/{{-\?/ end=/-\?}}/ keepend containedin=TOP,@htmlJetContainer

syntax cluster jetInside add=jetComponent

syntax match jetOperators '=\|\.\|:=\|=' contained containedin=@jetInside,jetParam
syntax match jetVariable /\w\+/ contained containedin=@jetInside
syntax match jetStatements 'if\|unless\|else\|block\|range\|yield\|try\|end' contained containedin=@jetInside
syntax match jetParam /[a-z@_-]\+=/he=e-1 contained containedin=@jetInside
syntax region jetComment      start=/{\*/rs=s+2   skip=/{{.\{-}}}/ end=/\*}/re=e-2   contains=Todo 
syntax region jetQString start=/'/ skip=/\\'/ end=/'/ contained containedin=@jetInside
syntax region jetDQString start=/"/ skip=/\\"/ end=/"/ contained containedin=@jetInside

" Clustering
syntax cluster htmlJetContainer add=htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,htmlLink,htmlBold,htmlUnderline,htmlItalic,htmlValue


" Hilighting
" jetInside hilighted as Number, which is rarely used in html
" you might like change it to Function or Identifier
HtmlHiLink jetVariable Number
HtmlHiLink jetVariableUnescape Number
HtmlHiLink jetPartial Number
HtmlHiLink jetMarkerSet Number
HtmlHiLink jetParam htmlArg

HtmlHiLink jetComment Comment
HtmlHiLink jetError Error
HtmlHiLink jetInsideError Error

HtmlHiLink jetHandlebars Special
HtmlHiLink jetUnescape Identifier
HtmlHiLink jetOperators Operator
HtmlHiLink jetStatements Conditional
HtmlHiLink jetHelpers Repeat
HtmlHiLink jetQString String
HtmlHiLink jetDQString String

let b:current_syntax = "jet"
delcommand HtmlHiLink
