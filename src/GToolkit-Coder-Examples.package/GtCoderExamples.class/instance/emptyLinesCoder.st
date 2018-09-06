model
emptyLinesCoder
	<gtExample>
	| method methodCoder source |
	method := self class >> #emptyLines.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'emptyLines'.
	self assert: methodCoder bodySource = '"Some empty lines"'.
	^ methodCoder