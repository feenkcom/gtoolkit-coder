Class {
	#name : #GtEvaluateSourceCodeCommand,
	#superclass : #BlTktCommand,
	#instVars : [
		'result',
		'sourceCode',
		'receiver',
		'requestorAndBindings'
	],
	#category : #'GToolkit-VariableBindings-Commands'
}

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> bindingStrategy [
	<return: #GtBindingStrategy>
	^ requestorAndBindings bindingStrategy
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> bindingStrategy: aGtBindingStrategy [
	requestorAndBindings bindingStrategy: aGtBindingStrategy
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> catchingErrors [
	"Return an error or collections of errors to catch during a command execution"
	^ Error, OCSemanticWarning
]

{ #category : #execution }
GtEvaluateSourceCodeCommand >> execute [
	| aCompiler |
	aCompiler := self class compiler
		source: self sourceCode "readStream" "Looks like it can be a String instead of readSream";
		context: nil "TODO: what is context? evaluation uses `context method methodClass`";
		receiver: self receiver "TODO: what is receiver? evaluation uses `receiver class` if context is nil";
		requestor: requestorAndBindings. "TODO: requestor should be an editor?
			evaluation uses `requestor selection` to evaluate only selected part"
	result := aCompiler evaluate.
		"evaluation does: 
			`receiver withArgs: context or #() executeMethod: 
				parse uses `noPattern`, 
					if context is not nil, `context tempNames` is used in `rewriteTempsForContext:`
				doSemanticAnalysis uses: 
					`compilationContext failBlock` on an exception
					`compilationContext scope newMethodScope to validate source code
						`lookupVariableForWrite:` uses `scope lookupVar: aVarNameString"
		"parseExpression uses `parserClass` and `optionParseErrors` to parse faulty expressions"
	^ result
]

{ #category : #initialization }
GtEvaluateSourceCodeCommand >> initialize [
	super initialize.
	sourceCode := 'nil'.
	result := nil.
	requestorAndBindings := GtBindingStrategyWithRequestor new.
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> receiver [
	^ receiver
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> requestor [
	^ requestorAndBindings requestor
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> requestor: anObject [
	requestorAndBindings requestor: anObject
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> result [
	"Return a source code evaluation result"
	^ result
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> sourceCode [
	<return: #String>
	^ sourceCode
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> sourceCode: aString [
	self
		assert: [ aString notNil ] 
		description: [ 'Source code must be non-nil' ].
	sourceCode := aString asString
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> variableBindings [
	<return: #GtBindingsTrait>
	^ requestorAndBindings bindingStrategy bindings
]

{ #category : #accessing }
GtEvaluateSourceCodeCommand >> variableBindings: aGtBindingsTrait [
	self 
		assert: [ aGtBindingsTrait notNil ] 
		description: [ 'Bindings must be non-nil' ].
	requestorAndBindings bindingStrategy bindings: aGtBindingsTrait
]
