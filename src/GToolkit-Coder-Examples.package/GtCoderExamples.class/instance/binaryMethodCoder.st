model
binaryMethodCoder
	<gtExample>
	| method methodCoder source |
	method := self class >> #?.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = '? anObject'.
	self assert: methodCoder bodySource = '	"Test binary method"'.
	^ methodCoder