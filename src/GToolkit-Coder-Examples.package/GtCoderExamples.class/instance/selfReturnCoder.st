model
selfReturnCoder
	<gtExample>
	| method methodCoder |
	method := self class >> #returnSelf.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder patternSource = 'returnSelf '.
	self assert: methodCoder bodySource = '^self'.
	^ methodCoder