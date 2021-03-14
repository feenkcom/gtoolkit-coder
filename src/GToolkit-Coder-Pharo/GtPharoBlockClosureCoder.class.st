Class {
	#name : #GtPharoBlockClosureCoder,
	#superclass : #GtPharoSourceCoder,
	#instVars : [
		'class',
		'parameters',
		'bindingStrategy'
	],
	#category : #'GToolkit-Coder-Pharo-Coders'
}

{ #category : #'initialize-release' }
GtPharoBlockClosureCoder >> addParameter: aString ofType: aBehavior [
	parameters at: aString put: aBehavior.
	bindingStrategy bindings at: aString asSymbol put: nil
]

{ #category : #accessing }
GtPharoBlockClosureCoder >> block [
	self validateSyntax
		ifFalse: [ ^ nil ].

	^ (class ifNil: [ Object ]) compiler
		source: self blockSource;
		logged: false;
		failBlock: [ ^ nil ];
		evaluate
]

{ #category : #private }
GtPharoBlockClosureCoder >> blockSource [
	^ self blockSourceFromText: self sourceText
]

{ #category : #private }
GtPharoBlockClosureCoder >> blockSource: aString [
	| ast startIndex endIndex |
	ast := GtPharoParser parse: aString startingAt: GtPharoParser startingStateForStatement.
	(ast isKindOf: GtPharoBlockNode)
		ifFalse: [ self error: 'Code is not a block' ].
	parameters := OrderedDictionary new.
	ast variables do: [ :each | self addParameter: each source ofType: nil ].
	startIndex := (ast bar notNil
		ifTrue: [ ast bar ]
		ifFalse: [ ast leftBracket ]) stopPosition + 1.
	endIndex := ast rightBracket startPosition - 1.
	[ startIndex < endIndex and: [ (aString at: startIndex) isSeparator ] ] whileTrue: [ startIndex := startIndex + 1 ].
	[ endIndex > startIndex and: [ (aString at: endIndex) isSeparator ] ] whileTrue: [ endIndex := endIndex - 1 ].

	self forSource: (aString copyFrom: startIndex to: endIndex)
]

{ #category : #private }
GtPharoBlockClosureCoder >> blockSourceFromText: aSourceTextOrString [
	^ String
		streamContents: [ :stream | 
			stream nextPut: $[.
			parameters
				keysDo: [ :each | 
					stream
						nextPut: $:;
						nextPutAll: each;
						nextPut: $  ].
			parameters notEmpty
				ifTrue: [ stream nextPutAll: '| ' ].
			stream
				nextPutAll: aSourceTextOrString;
				nextPut: $] ]
]

{ #category : #'api - actions' }
GtPharoBlockClosureCoder >> doItAllThenDo: aBlock requestedBy: aRequesterObject [
	^ self
		evaluate: [ :thisCoder | thisCoder blockSource ]
		requestedBy: aRequesterObject
		thenDo: aBlock
]

{ #category : #'api - actions' }
GtPharoBlockClosureCoder >> doItAndGoAll [
	^ self
		evaluate: [ :thisCoder | thisCoder blockSource ]
		thenDo: [ :anEvaluationResult |
			self notifyEvaluatedWithResult: anEvaluationResult.
			self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #'api - actions' }
GtPharoBlockClosureCoder >> evaluationRequesterForEditor: aTextEditor [
	^ GtBlockCoderEvaluationRequester on: self editor: aTextEditor
]

{ #category : #'initialize-release' }
GtPharoBlockClosureCoder >> forSource: aString [
	self sourceCode: (GtCoderExplicitSourceCode new source: aString)
]

{ #category : #'api - actions' }
GtPharoBlockClosureCoder >> format [
	self currentSourceString: (self newRbAST: self currentSourceString asString) formattedCode
]

{ #category : #private }
GtPharoBlockClosureCoder >> highlightBindingsStrategy [
	^ self context 
		ifNil:  [ GtHighlightingBindingStrategy new 
			bindings: bindingStrategy bindings]
		ifNotNil: [ GtContextHighlightingBindingStrategy new
			bindings: bindingStrategy bindings;
			context: self context ] 
]

{ #category : #'initialize-release' }
GtPharoBlockClosureCoder >> initialize [
	parameters := OrderedDictionary new.
	bindingStrategy := GtHighlightingBindingStrategy new.
	bindingStrategy bindings: Dictionary new.

	super initialize
]

{ #category : #'initialize-release' }
GtPharoBlockClosureCoder >> initializeAddOns [
	super initializeAddOns.
	
	addOns addStyler:
		(BrRBTextStyler new
			workspace: bindingStrategy;
			yourself)
]

{ #category : #private }
GtPharoBlockClosureCoder >> newCompletionStrategy [
	^ super newCompletionStrategy
		blockVariables: parameters;
		yourself
]

{ #category : #updating }
GtPharoBlockClosureCoder >> newRbAST: aString [
	| ast |
	ast := self
		parseExpression: (self blockSourceFromText: aString)
		requestor: self highlightBindingsStrategy.
	ast doSemanticAnalysis.
	ast gtMoveAllBy: 1 - ast body start.
	^ ast body
]
