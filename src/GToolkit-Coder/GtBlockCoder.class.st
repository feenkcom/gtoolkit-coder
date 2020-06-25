Class {
	#name : #GtBlockCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'class',
		'parameters',
		'bindingStrategy'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #arguments }
GtBlockCoder >> addParameter: aString ofType: aBehavior [
	parameters at: aString put: aBehavior.
	bindingStrategy bindings at: aString asSymbol put: nil
]

{ #category : #accessing }
GtBlockCoder >> block [
	self validateSyntax
		ifFalse: [ ^ nil ].
	^ (class ifNil: [ Object ]) compiler
		source: self blockSource;
		logged: false;
		failBlock: [ ^ nil ];
		evaluate
]

{ #category : #private }
GtBlockCoder >> blockSource [
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
				nextPutAll: self source;
				nextPut: $] ]
]

{ #category : #private }
GtBlockCoder >> blockSource: aString [
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
	self source: (aString copyFrom: startIndex to: endIndex)
]

{ #category : #actions }
GtBlockCoder >> doItAll [
	| source |
	source := self blockSource.
	source isNil
		ifTrue: [ ^ self ].
	^ self evaluateSource: source
]

{ #category : #actions }
GtBlockCoder >> doItAndGoAll: anElement [
	| aSource aValue |
	aSource := self blockSource.
	aSource isNil ifTrue: [ ^ self ].
	aValue := self evaluateSource: aSource.
	aValue == self ifTrue: [ ^ self ].
	anElement phlow spawnObject: aValue
]

{ #category : #actions }
GtBlockCoder >> evaluationRequester [
	^ GtBlockCoderEvaluationRequester on: self
]

{ #category : #formatting }
GtBlockCoder >> format [
	self source: (self newRbAST: self newSourceText asString) formattedCode
]

{ #category : #private }
GtBlockCoder >> highlightBindingsStrategy [
	^ self context 
		ifNil:  [ GtHighlightingBindingStrategy new 
			bindings: bindingStrategy bindings]
		ifNotNil: [ GtContextHighlightingBindingStrategy new
			bindings: bindingStrategy bindings;
			context: self context ] 
]

{ #category : #'initialize-release' }
GtBlockCoder >> initialize [
	parameters := OrderedDictionary new.
	bindingStrategy := GtHighlightingBindingStrategy new.
	bindingStrategy bindings: Dictionary new.
	super initialize.
	expanded := true
]

{ #category : #'initialize-release' }
GtBlockCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addStyler:
			(BrRBTextStyler new
				workspace: bindingStrategy;
				yourself).
	addOns clearChanges
]

{ #category : #'initialize-release' }
GtBlockCoder >> initializeShortcuts [
	super initializeShortcuts.
	addOns
		addShortcut:
			(BlShortcut new
				combination: BlKeyCombination primaryShiftF;
				action: [ self format ])
]

{ #category : #private }
GtBlockCoder >> newCompletionStrategy [
	^ super newCompletionStrategy
		blockVariables: parameters;
		yourself
]

{ #category : #updating }
GtBlockCoder >> newRbAST: aString [
	| ast |
	ast := self
		parseExpression: aString
		requestor: self highlightBindingsStrategy.
	ast doSemanticAnalysis.
	ast gtMoveAllBy: 1 - ast body start.
	^ ast body
]

{ #category : #updating }
GtBlockCoder >> newSource [
	^ self blockSource
]

{ #category : #updating }
GtBlockCoder >> newSourceText [
	<retrun: #BlText>

	^ self blockSource asRopedText
]

{ #category : #accessing }
GtBlockCoder >> source: aString [
	self sourceEditor text: aString asRopedText.
	self sourceEditor text attributes: self defaultTextAttributes.
	self sourceChanged
]
