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

{ #category : #'initialize-release' }
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
	^ self blockSourceFromText: self sourceText
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

	self forSource: (aString copyFrom: startIndex to: endIndex)
]

{ #category : #private }
GtBlockCoder >> blockSourceFromText: aSourceTextOrString [
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
GtBlockCoder >> doItAllFrom: anEditorElement [
	^ self
		evaluateSource: self blockSource
		in: anEditorElement
]

{ #category : #'api - actions' }
GtBlockCoder >> doItAndGoAllFrom: anEditorElement [
	| aSource aValue |

	aSource := self blockSource.
	aValue := self evaluateSource: aSource in: anEditorElement.
	aValue == self
		ifTrue: [ ^ self ].
	
	anEditorElement phlow spawnObject: aValue
]

{ #category : #'api - actions' }
GtBlockCoder >> evaluationRequesterForEditor: aTextEditor [
	^ GtBlockCoderEvaluationRequester on: self editor: aTextEditor
]

{ #category : #'initialize-release' }
GtBlockCoder >> forSource: aString [
	self sourceCode: (GtCoderConcreteSourceCode new source: aString)
]

{ #category : #'api - actions' }
GtBlockCoder >> format [
	self replaceSourceTextWith: (self newRbAST: self currentSourceString asString) formattedCode
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
	
	addOns addStyler:
		(BrRBTextStyler new
			workspace: bindingStrategy;
			yourself).

	addOns clearChanges
]

{ #category : #'initialize-release' }
GtBlockCoder >> initializeShortcuts [
	super initializeShortcuts.
	
	addOns addShortcut:
		(BrTextEditorShortcut new
			combination: BlKeyCombination primaryShiftF;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder format ];
			options: self)
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
		parseExpression: (self blockSourceFromText: aString)
		requestor: self highlightBindingsStrategy.
	ast doSemanticAnalysis.
	ast gtMoveAllBy: 1 - ast body start.
	^ ast body
]
