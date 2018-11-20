Class {
	#name : #GtPharoSnippetCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'collapsedEditor',
		'bindingStrategy'
	],
	#category : #'GToolkit-Coder-Coders'
}

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
	^ element
]

{ #category : #initialization }
GtPharoSnippetCoder >> evaluateSource: aString [
	| value |
	value := self class compiler
		requestor: self requester;
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
GtPharoSnippetCoder >> initialize [
	super initialize.
	expanded := true.
	bindingStrategy := GtHighlightingBindingStrategy new.
	bindingStrategy bindings: Dictionary new
]

{ #category : #initialization }
GtPharoSnippetCoder >> initializeAddOns [
	super initializeAddOns.
	addOns addPatternStyler: BrRBTextStyler new.
	addOns addMainAction: 'Run' translated icon: BrGlamorousIcons play action: [ :aButton | self runFrom: aButton ].
	addOns clearChanges
]

{ #category : #ui }
GtPharoSnippetCoder >> newBodyStyler [
	| styler |
	styler := BrRBTextStyler new.
	styler workspace: bindingStrategy.
	^ styler
]

{ #category : #private }
GtPharoSnippetCoder >> newCompletionStrategy [
	| completionStrategy |
	completionStrategy := GtPharoCompletionStrategy new.
	self flag: 'bindings'.
	^ completionStrategy
]

{ #category : #actions }
GtPharoSnippetCoder >> runFrom: aButton [
	| aValue |
	self clearPreviousEvaluations.
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
	| firstLine |
	super sourceChanged.
	firstLine := (self sourceEditor text asString lines detect: [ :each | each notEmpty ] ifNone: [ '' ]) asRopedText.
	firstLine attributes: {(BlTextForegroundAttribute paint: Color gray)}.
	self collapsedEditor text: firstLine readonly
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
