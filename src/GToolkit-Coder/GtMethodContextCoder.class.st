Class {
	#name : #GtMethodContextCoder,
	#superclass : #GtMethodCoder,
	#instVars : [
		'context',
		'session'
	],
	#category : #'GToolkit-Coder-Coders'
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

{ #category : #elements }
GtMethodContextCoder >> elementClass [
	^ GtCoderContextElement
]

{ #category : #accessing }
GtMethodContextCoder >> instanceVariableNamesAndValuesDo: aBlock [
	| receiver |
	receiver := self receiver.
	receiver class allInstVarNames doWithIndex: [ :each :i | aBlock value: each value: (receiver instVarAt: i) ]
]

{ #category : #'debugger access' }
GtMethodContextCoder >> interruptedContext [
	^ self session context
]

{ #category : #testing }
GtMethodContextCoder >> isDead [
	^ context isDead
]

{ #category : #accessing }
GtMethodContextCoder >> receiver [
	^ self context receiver
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

{ #category : #accessing }
GtMethodContextCoder >> stackVariableNamesAndValuesDo: aBlock [
	| stackPosition |
	self context stackPtr isNil
		ifTrue: [ ^ self ].
	stackPosition := 0.
	self context stackPtr to: self context numTemps + 1 by: -1 do: [ :i | 
		aBlock
			value:
				'stack top'
					,
						(stackPosition > 0
							ifTrue: [ ' - ' , stackPosition printString ]
							ifFalse: [ '' ])
			value: (self context at: i).
		stackPosition := stackPosition + 1 ]
]

{ #category : #accessing }
GtMethodContextCoder >> tempNamesAndValuesDo: aBlock [
	self context tempNames doWithIndex: [ :each :i | aBlock value: each value: (self context namedTempAt: i) ]
]

{ #category : #private }
GtMethodContextCoder >> updateDebugger [
	announcer announce: GtCoderRefreshStackAnnouncement new.
	self updateSelection
]

{ #category : #private }
GtMethodContextCoder >> updateSelection [
	| interval |
	(self session process isNil or: [ context isDead ])
		ifTrue: [ ^ self ].
	interval := self session pcRangeForContext: context.
	interval isEmpty
		ifTrue: [ ^ self ].
	self sourceEditor text clearAttributes: [ :each | each class = BlTextUnderlineAttribute ].
	(self sourceEditor text from: interval first to: interval last)
		attributes:
			{(BlTextUnderlineAttribute new
				paint: BrGlamorousColors errorBackgroundColor;
				beNotOverwritableByStyler)}
]
