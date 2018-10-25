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

{ #category : #actions }
GtMethodContextCoder >> contextActions [
	<return: #Collection of: #GtCoderAction>

	^ (self actionsForPragmas: self stackDebuggingActionsPragmas)
		collect: [ :aDebuggingAction |
			GtCoderAction new
				title: aDebuggingAction label;
				icon: (aDebuggingAction icon ifNil: [ BlElement new size: 0@0 ]);
				action: [
					aDebuggingAction execute.
					aDebuggingAction needsUpdate
						ifTrue: [ self updateDebugger ] ] ]
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
	self sourceEditor text clearAttributes: [ :each | each class = BlTextUnderlineAttribute ].
	(self sourceEditor text from: interval first - offset to: interval last - offset)
		attributes:
			{(BlTextUnderlineAttribute new
				paint: BrGlamorousColors errorBackgroundColor;
				beNotOverwritableByStyler)}
]
