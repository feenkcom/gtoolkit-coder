model
thisMethod
	<gtExample>
	| method methodCoder source |
	method := self class >> #thisMethod.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = (source first: (source indexOf: Character cr) - 1).
	self assert: methodCoder bodySource = (source allButFirst: (source indexOf: Character cr)).
	^ methodCoder