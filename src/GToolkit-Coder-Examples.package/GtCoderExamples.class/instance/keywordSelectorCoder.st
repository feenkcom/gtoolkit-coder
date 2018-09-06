model
keywordSelectorCoder
	<gtExample>
	| method methodCoder source |
	method := self class >> #keyword:selector:.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'keyword: a selector: b'.
	self assert: methodCoder bodySource = '	^ a + b'.
	^ methodCoder