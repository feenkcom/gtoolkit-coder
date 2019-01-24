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
	self notifyDebugger.
	
	self flag: 'check why this is needed'.
	self updateSelection
]

{ #category : #elements }
GtMethodContextCoder >> coderLook [
	^ super coderLook
	"^ GtContextCoderDropDownVariableLook new methodCoder: self"
	"^ GtContextCoderVariableLook new methodCoder: self"
]

{ #category : #actions }
GtMethodContextCoder >> compile [
	"The current compiler wants to notify a text morph object in case of errors. 
	The compilation is delagated to the renderer, as the renderer has access
	to the text morph object."
	^ (self session 
		recompileMethodTo: self newMethodSource 
		inContext: self context 
		notifying: nil "textMorph") 
			ifTrue: [ 
				self compiledMethod ifNotNil: [ :method | 
					methodSource := method sourceCode.
				true ] ] 
			ifFalse: [ ^ false ]
	
]

{ #category : #accessing }
GtMethodContextCoder >> compiledMethod [
	"The context coder should allways return the compiled method from the context 
	as the method from the class can be changed. In that case the context will 
	use its own method."
	^ self context method
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
						ifTrue: [ 
							self notifyDebugger.
							
							"If after a debugging action this context becomes the second on the stack 
							the selected PC range could change. The debugger also updates the selection
							of the top context. This will be called twice if the context remains on the
							top, but its the easiest solution to avoid warking the stack to find what changed."
							self updateSelection ] ] ]
]

{ #category : #'debugger access' }
GtMethodContextCoder >> currentContext [
	^ self context
]

{ #category : #'initialize-release' }
GtMethodContextCoder >> initializeAddOns [
	super initializeAddOns.
"	addOns addStyler: (GtCoderContextVariableButtonStyler new methodCoder: self)."
"	addOns addStyler: (GtCoderContextVariableValueStyler new methodCoder: self)"
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> instanceVariableNames [
	| receiver |
	receiver := self receiver.
	^ receiver class allInstVarNames
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> instanceVariableNamesAndValuesDo: aBlock [
	| receiver |
	receiver := self receiver.
	receiver class allInstVarNames doWithIndex: [ :each :i | 
		aBlock value: each value: (receiver instVarAt: i) ]
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> instanceVariableValueFor: anInstanceVariableName [
	^ self receiver instVarNamed: anInstanceVariableName
]

{ #category : #'debugger access' }
GtMethodContextCoder >> interruptedContext [
	^ self session context
]

{ #category : #testing }
GtMethodContextCoder >> isDead [
	^ context isDead
]

{ #category : #private }
GtMethodContextCoder >> notifyDebugger [
	announcer announce: GtCoderRefreshStackAnnouncement new.
]

{ #category : #accessing }
GtMethodContextCoder >> receiver [
	^ self context receiver
]

{ #category : #actions }
GtMethodContextCoder >> save [ 	
	^ self validateSyntax and: [ 
		self compile and: [ 
			self buildSource. 
			self notifyDebugger.
			true ] ]
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
	^ #(gt2ContextDebuggingAction)
]

{ #category : #'accessing variables' }
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

{ #category : #'accessing variables' }
GtMethodContextCoder >> tempNameValueFor: aTempName [
	^ self context tempNamed: aTempName
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> tempNames [
	^ self context tempNames
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> tempNamesAndValuesDo: aBlock [
	self context tempNames doWithIndex: [ :each :i | aBlock value: each value: (self context namedTempAt: i) ]
]

{ #category : #updating }
GtMethodContextCoder >> updateContent [ 
	"Update the source code and the selection. The save action in the debugger 
	can change the compiled method stored  in the context. "
	self
		updateSourceFromContext;
		updateSelection
]

{ #category : #updating }
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

{ #category : #updating }
GtMethodContextCoder >> updateSourceFromContext [
	| contextSourceCode |
	contextSourceCode := self context method sourceCode.
	contextSourceCode = methodSource ifTrue: [ 
		^ self ].
	
	methodSource := contextSourceCode.
	self buildSource.
]
