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
				nextPutAll: self sourceEditor text asString;
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

{ #category : #'initialize-release' }
GtBlockCoder >> initialize [
	parameters := OrderedDictionary new.
	bindingStrategy := GtHighlightingBindingStrategy new.
	bindingStrategy bindings: Dictionary new.
	super initialize.
	expanded := true
]

{ #category : #private }
GtBlockCoder >> newCompletionStrategy [
	^ super newCompletionStrategy
		blockVariables: parameters;
		yourself
]

{ #category : #updating }
GtBlockCoder >> newRbAST: aString [
	self flag: 'probably generates wrong text indexes for nodes'.
	^ (super newRbAST: aString) body
]

{ #category : #updating }
GtBlockCoder >> newSource [
	^ self blockSource
]

{ #category : #private }
GtBlockCoder >> newSourceStyler [
	| styler |
	styler := BrRBTextStyler new.
	styler workspace: bindingStrategy.
	^ styler
]

{ #category : #accessing }
GtBlockCoder >> source [
	^ self sourceEditor text asString
]

{ #category : #accessing }
GtBlockCoder >> source: aString [
	self sourceEditor text: aString asRopedText.
	self sourceChanged
]

{ #category : #elements }
GtBlockCoder >> sourceElement [
	| element |
	element := BrEditorElement new.
	element editor: self sourceEditor.
	(GtCompletionController on: element strategy: self completionStrategy) install.
	^ element
]
