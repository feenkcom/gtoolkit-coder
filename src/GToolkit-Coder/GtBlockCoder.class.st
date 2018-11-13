Class {
	#name : #GtBlockCoder,
	#superclass : #Object,
	#instVars : [
		'class',
		'sourceEditor',
		'collapsedEditor',
		'parameters',
		'bindingStrategy',
		'expanded'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #arguments }
GtBlockCoder >> addParameter: aString ofType: aBehavior [
	parameters at: aString put: aBehavior.
	bindingStrategy bindings at: aString asSymbol put: nil
]

{ #category : #elements }
GtBlockCoder >> asElement [
	| expander |
	expander := BrExpander new.
	expander
		vFitContent;
		hMatchParent.
	expanded
		ifTrue: [ expander expand ].
	expander look: BrGlamorousExpanderLook new.
	expander header: [ self collapsedElement ].
	expander content: [ self sourceElement ].
	expander margin: (BlInsets all: 10).
	^ expander
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

{ #category : #private }
GtBlockCoder >> clearSyntaxErrors [
	self sourceEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ].
	self collapsedEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtBlockCoder >> collapsedEditor [
	collapsedEditor notNil
		ifTrue: [ ^ collapsedEditor ].
	collapsedEditor := BrTextEditor new.
	^ collapsedEditor
]

{ #category : #elements }
GtBlockCoder >> collapsedElement [
	| element |
	element := BrEditorElement new.
	element editor: self collapsedEditor.
	(GtCompletionController on: element strategy: self newCompletionStrategy) install.
	^ element
]

{ #category : #accessing }
GtBlockCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtBlockCoder >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #ui }
GtBlockCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #'initialize-release' }
GtBlockCoder >> initialize [
	super initialize.
	expanded := true.
	parameters := OrderedDictionary new.
	bindingStrategy := GtHighlightingBindingStrategy new.
	bindingStrategy bindings: Dictionary new
]

{ #category : #private }
GtBlockCoder >> newCompletionStrategy [
	| completionStrategy |
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: class.
	completionStrategy blockVariables: parameters.
	^ completionStrategy
]

{ #category : #private }
GtBlockCoder >> reportParseError: aString at: anInteger on: textEditor [
	| text position |
	text := textEditor text.
	position := anInteger - 1 max: 1.
	text size < position
		ifTrue: [ ^ self ].
	(text from: position to: position) attributes: {(GtMethodCoderErrorAttribute for: aString , ' ->')}.
	textEditor
		invalidate: position to: position;
		update: position to: position.
	textEditor moveCursorTo: position
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

{ #category : #'event handling' }
GtBlockCoder >> sourceChanged [
	| index firstLine |
	self clearSyntaxErrors.
	index := self sourceEditor text asString indexOf: Character cr ifAbsent: [ self sourceEditor text size + 1 ].
	firstLine := self sourceEditor text copyFrom: 1 to: index - 1.
	self collapsedEditor text: firstLine readonly
]

{ #category : #private }
GtBlockCoder >> sourceEditor [
	| styler |
	sourceEditor notNil
		ifTrue: [ ^ sourceEditor ].
	sourceEditor := BrTextEditor new.
	styler := BrRBTextStyler new.
	styler workspace: bindingStrategy.
	sourceEditor styler: styler.
	sourceEditor
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ].
	^ sourceEditor
]

{ #category : #elements }
GtBlockCoder >> sourceElement [
	| element |
	element := BrEditorElement new.
	element editor: self sourceEditor.
	(GtCompletionController on: element strategy: self newCompletionStrategy) install.
	^ element
]

{ #category : #private }
GtBlockCoder >> validateSyntax [
	[ GtPharoParser parse: self sourceEditor text asString startingAt: GtPharoParser startingStateForMethodSequence ]
		on: SmaCCParserError
		do: [ :ex | 
			self reportParseError: ex messageText at: ex tag position on: self sourceEditor.
			self reportParseError: ex messageText at: ex tag position on: self collapsedEditor.
			^ false ].
	^ true
]
