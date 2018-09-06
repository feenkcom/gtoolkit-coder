model
emptyBodyCoder
	<gtExample>
	| method methodCoder source |
	method := self class >> #emptyBody.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'emptyBody'.
	self assert: methodCoder bodySource = ''.
	^ methodCoder