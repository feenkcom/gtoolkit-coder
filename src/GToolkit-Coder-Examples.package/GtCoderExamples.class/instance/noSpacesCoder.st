model
noSpacesCoder
	<gtExample>
	| method methodCoder source |
	method := self class >> #noSpaces.
	methodCoder := GtMethodCoder forMethod: method.
	source := method sourceCode.
	self assert: methodCoder patternSource = 'noSpaces'.
	self assert: methodCoder bodySource = '|a|a:=3.^a*a'.
	^ methodCoder