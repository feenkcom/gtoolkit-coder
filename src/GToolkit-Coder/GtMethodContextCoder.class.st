Class {
	#name : #GtMethodContextCoder,
	#superclass : #GtMethodCoder,
	#instVars : [
		'context',
		'session',
		'announcer'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodContextCoder class >> forContext: aContext session: aDebugSession [
	^ (self forMethod: aContext method)
		context: aContext;
		session: aDebugSession;
		object: aContext receiver;
		yourself
]

{ #category : #private }
GtMethodContextCoder >> actionsForPragmas: aSymbolsCollection [
	^ self session class debuggingActionsForPragmas: aSymbolsCollection for: self
]

{ #category : #'debugger access' }
GtMethodContextCoder >> announce: anAnnouncement [
	announcer announce: anAnnouncement
]

{ #category : #accessing }
GtMethodContextCoder >> announcer [
	^ announcer
]

{ #category : #private }
GtMethodContextCoder >> buildSource [
	super buildSource.
	self updateSelection
]

{ #category : #'debugger access' }
GtMethodContextCoder >> close [
	self updateDebugger
]

{ #category : #accessing }
GtMethodContextCoder >> context [
	^ context
]

{ #category : #accessing }
GtMethodContextCoder >> context: aContext [
	context := aContext
]

{ #category : #elements }
GtMethodContextCoder >> contextButtons [
	^ (self actionsForPragmas: self stackDebuggingActionsPragmas)
		collect: [ :aDebuggingAction | 
			| actionButton |
			actionButton := BrButton new
				look: BrGlamorousButtonWithIconLook;
				label: aDebuggingAction label;
				action: [ aDebuggingAction execute.
					aDebuggingAction needsUpdate
						ifTrue: [ self updateDebugger ] ].
			aDebuggingAction icon ifNotNil: [ :anIcon | actionButton icon: aDebuggingAction icon asElement ].
			actionButton ]
]

{ #category : #'debugger access' }
GtMethodContextCoder >> currentContext [
	^ self context
]

{ #category : #'initialize-release' }
GtMethodContextCoder >> initialize [
	super initialize.
	announcer := Announcer new
]

{ #category : #'debugger access' }
GtMethodContextCoder >> interruptedContext [
	^ self session context
]

{ #category : #testing }
GtMethodContextCoder >> isDead [
	^ context isDead
]

{ #category : #elements }
GtMethodContextCoder >> patternButtonElement [
	| header patternElement label editorElement styledPattern |
	styledPattern := self styledPatternText.
	header := BrButton new.
	header
		layout: (BlGridLayout horizontal cellSpacing: 0);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	patternElement := BlElement new.
	patternElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c frame vertical alignCenter ].
	self patternEditor
		when: BrTextEditorInsertedEvent do: [ :event | self clearPatternSyntaxErrors ];
		when: BrTextEditorDeletedEvent do: [ :event | self clearPatternSyntaxErrors ].
	label := BlTextElement new.
	label text: styledPattern.
	label
		margin:
			(BlInsets
				top: 10
				left: 0
				bottom: 10
				right: 5).
	label
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	patternElement addChild: label.
	editorElement := BrEditorElement new.
	editorElement editor: self patternEditor.
	self patternEditor text: styledPattern.
	editorElement
		margin:
			(BlInsets
				top: 10
				left: 0
				bottom: 10
				right: 5).
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	editorElement when: BlClickEvent do: [ :event | event consumed: true ].
	editorElement visibility: BlVisibility hidden.
	patternElement addChild: editorElement.
	header addChild: patternElement.
	self contextButtons do: [ :each | header addChild: each ].
	^ header
]

{ #category : #'debugger access' }
GtMethodContextCoder >> session [
	^ session
]

{ #category : #accessing }
GtMethodContextCoder >> session: anObject [
	session := anObject
]

{ #category : #private }
GtMethodContextCoder >> stackDebuggingActionsPragmas [
	^ #(gt2StackDebuggingAction)
]

{ #category : #private }
GtMethodContextCoder >> updateDebugger [
	announcer announce: GtCoderRefreshStackAnnouncement new.
	self updateSelection
]

{ #category : #private }
GtMethodContextCoder >> updateSelection [
	| interval offset |
	(self session process isNil or: [ context isDead ])
		ifTrue: [ ^ self ].
	interval := self session pcRangeForContext: context.
	interval isEmpty
		ifTrue: [ ^ self ].
	offset := self patternSource size + 1.
	self sourceEditor selecter
		overwrite;
		from: interval first - offset - 1 to: interval last - offset;
		select
]
