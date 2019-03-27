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

{ #category : #formatting }
GtBlockCoder >> format [
	self source: (self newRbAST: self newSource) formattedCode
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
	| ast offset |
	ast := super newRbAST: aString.
	offset := ast body start - 1.
	ast
		nodesDo: [ :e | 
			(e respondsTo: #start:)
				ifTrue: [ e start: e start - offset ].
			(e respondsTo: #stop:)
				ifTrue: [ e stop: e stop - offset ].
			(e respondsTo: #parentheses)
				ifTrue: [ e parentheses
						do: [ :f | f setFrom: f first - offset to: f last - offset by: 1 ] ].
			(e respondsTo: #keywordsPositions)
				ifTrue: [ e
						keywordsPositions: (e keywordsPositions collect: [ :f | f - offset ]) ] ].
	^ ast body
]

{ #category : #updating }
GtBlockCoder >> newSource [
	^ self blockSource
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
	(GtCompletionController on: element strategy: self completionStrategy)
		install.
	self addShortcutsTo: element.
	^ element
]
