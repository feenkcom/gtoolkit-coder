Class {
	#name : #GtPharoSnippetCoder,
	#superclass : #Object,
	#instVars : [
		'sourceEditor',
		'collapsedEditor',
		'bindingStrategy',
		'expanded',
		'announcer',
		'addOns'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtPharoSnippetCoder >> announcer [
	^ announcer
]

{ #category : #accessing }
GtPharoSnippetCoder >> announcer: anObject [
	announcer := anObject
]

{ #category : #ui }
GtPharoSnippetCoder >> asElement [
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

{ #category : #ui }
GtPharoSnippetCoder >> collapsedEditor [
	collapsedEditor notNil
		ifTrue: [ ^ collapsedEditor ].
	collapsedEditor := BrTextEditor new.
	^ collapsedEditor
]

{ #category : #ui }
GtPharoSnippetCoder >> collapsedElement [
	| element |
	element := BrEditorElement new.
	element editor: self collapsedEditor.
	(GtCompletionController on: element strategy: self newCompletionStrategy) install.
	^ element
]

{ #category : #initialization }
GtPharoSnippetCoder >> contextActions [
	^ addOns contextActions
]

{ #category : #initialization }
GtPharoSnippetCoder >> evaluateSource: aString [
	| value |
"	self clearPreviousEvaluations."
	value := self class compiler
		requestor: self evaluationRequester;
		source: aString;
		receiver: nil;
		context: nil;
		failBlock: [ ^ self flag: 'insert error adornment' ];
		evaluate.
	self sourceEditor text
		attributes:
			{(GtPlaygroundEvaluatedCodeButtonAttribute new
				beNotOverwritableByStyler;
				result: value;
				paint: (Color fromHexString: #'90CAF9'))}.
	self sourceEditor
		invalidateAll;
		updateAll.
	^ value
]

{ #category : #initialization }
GtPharoSnippetCoder >> evaluationRequester [
	^ GtMethodCoderEvaluationRequester on: self
]

{ #category : #accessing }
GtPharoSnippetCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtPharoSnippetCoder >> expanded: anObject [
	expanded := anObject
]

{ #category : #ui }
GtPharoSnippetCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #initialization }
GtPharoSnippetCoder >> initialize [
	super initialize.
	expanded := true.
	bindingStrategy := GtHighlightingBindingStrategy new.
	bindingStrategy bindings: Dictionary new.
	announcer := Announcer new.
	self initializeAddOns
]

{ #category : #initialization }
GtPharoSnippetCoder >> initializeAddOns [
	addOns := GtMethodCoderAddOns new.
	addOns addPatternStyler: BrRBTextStyler new.
	addOns addMainAction: 'Run' translated icon: BrGlamorousIcons play action: [ :aButton | self runFrom: aButton ].
	addOns clearChanges
]

{ #category : #initialization }
GtPharoSnippetCoder >> mainActions [
	^ addOns mainActions
]

{ #category : #private }
GtPharoSnippetCoder >> newCompletionStrategy [
	| completionStrategy |
	completionStrategy := GtPharoCompletionStrategy new.
	self flag: 'bindings'.
	^ completionStrategy
]

{ #category : #private }
GtPharoSnippetCoder >> reportParseError: aString at: anInteger on: textEditor [
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

{ #category : #initialization }
GtPharoSnippetCoder >> runFrom: aButton [
	| aValue |
	self validateSyntax ifFalse: [ ^ self ].
	aValue := self evaluateSource: self sourceEditor text asString.
	aButton fireEvent: (GtPhlowObjectToSpawn new object: aValue; sourceElement: aButton)
]

{ #category : #accessing }
GtPharoSnippetCoder >> source: aString [
	self sourceEditor text: aString asRopedText.
	self sourceChanged
]

{ #category : #'event handling' }
GtPharoSnippetCoder >> sourceChanged [
	| index firstLine |
"	self clearSyntaxErrors."
	index := self sourceEditor text asString indexOf: Character cr ifAbsent: [ self sourceEditor text size + 1 ].
	firstLine := self sourceEditor text copyFrom: 1 to: index - 1.
	self collapsedEditor text: firstLine readonly
]

{ #category : #ui }
GtPharoSnippetCoder >> sourceEditor [
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

{ #category : #ui }
GtPharoSnippetCoder >> sourceElement [
	| container element toolbar |
	container := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [:c | 
			c vertical matchParent.
			c horizontal matchParent ].
	element := BrEditorElement new.
	element constraintsDo: [:c | 
			c vertical matchParent.
			c horizontal matchParent ].
	element editor: self sourceEditor.
	(GtCompletionController on: element strategy: self newCompletionStrategy) install.
	toolbar := GtCoderMethodActionsElement new methodCoder: self.	
	container addChild: element.
	container addChild: toolbar.
	^ container
]

{ #category : #private }
GtPharoSnippetCoder >> validateSyntax [
	[ GtPharoParser parse: self sourceEditor text asString startingAt: GtPharoParser startingStateForMethodSequence ]
		on: SmaCCParserError
		do: [ :ex | 
			self reportParseError: ex messageText at: ex tag position on: self sourceEditor.
			self reportParseError: ex messageText at: ex tag position on: self collapsedEditor.
			^ false ].
	^ true
]
