Class {
	#name : #GtBlockCoder,
	#superclass : #Object,
	#instVars : [
		'class',
		'sourceEditor',
		'collapsedEditor',
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

{ #category : #elements }
GtBlockCoder >> asElement [
	| expander |
	expander := BrExpander new.
	expander
		vFitContent;
		hExact: 300.
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

{ #category : #'event handling' }
GtBlockCoder >> collapsedChanged [
	| index newSource |
	index := self sourceEditor text asString indexOf: Character cr.
	newSource := self collapsedEditor text asString.
	index > 0
		ifTrue: [ newSource := newSource , (self sourceEditor text asString allButFirst: index - 1) ].
	self sourceEditor text: newSource asRopedText
]

{ #category : #private }
GtBlockCoder >> collapsedEditor [
	| styler |
	collapsedEditor notNil
		ifTrue: [ ^ collapsedEditor ].
	collapsedEditor := BrTextEditor new.
	styler := BrRBTextStyler new.
	styler workspace: bindingStrategy.
	collapsedEditor styler: styler.
	collapsedEditor
		when: BrTextEditorInsertedEvent do: [ :event | self collapsedChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self collapsedChanged ].
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
	index := self sourceEditor text asString indexOf: Character cr.
	firstLine := index > 0
		ifTrue: [ self sourceEditor text copyFrom: 1 to: index - 1 ]
		ifFalse: [ self sourceEditor text copy ].
	self collapsedEditor text: firstLine
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
