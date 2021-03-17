Class {
	#name : #GtPharoMethodContextCoder,
	#superclass : #GtPharoMethodCoder,
	#instVars : [
		'context',
		'session'
	],
	#category : #'GToolkit-Coder-Pharo-Coders'
}

{ #category : #'instance creation' }
GtPharoMethodContextCoder class >> forContext: aContext session: aDebugSession [
	^ (self forMethod: aContext method)
		context: aContext;
		session: aDebugSession;
		object: aContext receiver;
		yourself
]

{ #category : #private }
GtPharoMethodContextCoder >> actionsForPragmas: aSymbolsCollection [
	^ self session class debuggingActionsForPragmas: aSymbolsCollection for: self
]

{ #category : #'debugger access' }
GtPharoMethodContextCoder >> close [
	self notifyDebugger.
	
	"self flag: 'check why this is needed'.
	self updateSelection"
]

{ #category : #actions }
GtPharoMethodContextCoder >> compile [
	^ self
		handleCompilerErrorsDuring: [ self session
				gtRecompileMethodTo: self currentSourceString
				inContext: self context
				notifying: self compilationRequester ]
]

{ #category : #accessing }
GtPharoMethodContextCoder >> compiledMethod [
	"The context coder should allways return the compiled method from the context 
	as the method from the class can be changed. In that case the context will 
	use its own method."

	^ self context method
]

{ #category : #accessing }
GtPharoMethodContextCoder >> context [
	^ context
]

{ #category : #accessing }
GtPharoMethodContextCoder >> context: aContext [
	context := aContext
]

{ #category : #actions }
GtPharoMethodContextCoder >> contextActions [
	<return: #Collection of: #GtCoderAction>

	^ ((self actionsForPragmas: self stackDebuggingActionsPragmas)
		select: [ :aDebuggingAction | 
			"Quite hacky solutions for only showing StepInto for the top context."
			aDebuggingAction class ~= StepIntoDebugAction or: [ 
				self context = self session interruptedContext ] ])
		collect: [ :aDebuggingAction |
			GtCoderAction new
				title: aDebuggingAction label;
				icon: (aDebuggingAction icon ifNil: [ BlElement new size: 0@0 ]);
				action: [ aDebuggingAction execute ] ]
]

{ #category : #'debugger access' }
GtPharoMethodContextCoder >> currentContext [
	^ self context
]

{ #category : #'accessing variables' }
GtPharoMethodContextCoder >> debuggerVariableNodes [
	| variablesList |

	variablesList := OrderedCollection new.
	self instanceVariableNodesDo: [ :aNode | variablesList add: aNode ].
	self temporaryVariableNodesDo: [ :aNode | variablesList add: aNode ].
	self workspaceDoItNodesDo: [ :aNode | variablesList add: aNode ].
	
	variablesList sort: [:node1 :node2 | node1 key < node2 key].
	variablesList 
		addFirst: (GTInspectorSelfNode hostObject: self receiver);
		addLast: (GTInspectorDynamicNode hostObject: self context label: 'thisContext' value: self context).
	self stackVariableNodesDo: [ :aNode | variablesList add: aNode ].
	^ variablesList
	
	
]

{ #category : #initialize }
GtPharoMethodContextCoder >> initializeAddOns: addOns [
	super initializeAddOns: addOns.

"	addOns addStyler: (GtCoderContextVariableButtonStyler new methodCoder: self)."
"	addOns addStyler: (GtCoderContextVariableValueStyler new methodCoder: self)"
]

{ #category : #'accessing variables' }
GtPharoMethodContextCoder >> instanceVariableNamesAndValuesDo: aBlock [
	| receiver |
	receiver := self receiver.
	receiver class allInstVarNames doWithIndex: [ :each :i | 
		aBlock value: each value: (receiver instVarAt: i) ]
]

{ #category : #'accessing variables' }
GtPharoMethodContextCoder >> instanceVariableNodesDo: aBloc [
	self receiver class allSlots collect: [ :aSlot | 
		aBloc value: (GTInspectorSlotNode 
			hostObject: self receiver 
			slot: aSlot) ]
]

{ #category : #'debugger access' }
GtPharoMethodContextCoder >> interruptedContext [
	^ self session context
]

{ #category : #testing }
GtPharoMethodContextCoder >> isDead [
	^ context isDead
]

{ #category : #testing }
GtPharoMethodContextCoder >> needsUpdate [
	^ self isModified or: [ 
		(self compiledMethod == self context method) not or: [ 
			(self selector == self compiledMethod selector) not ]]
]

{ #category : #private }
GtPharoMethodContextCoder >> notifyDebugger [
	announcer announce: GtCoderRefreshStackAnnouncement new.
]

{ #category : #printing }
GtPharoMethodContextCoder >> printOn: aStream [
	super printOn: aStream.
	self context ifNotNil: [ 
		aStream nextPut: $(.
		self context printOn: aStream. 
		aStream nextPut: $) ]
]

{ #category : #accessing }
GtPharoMethodContextCoder >> programCounterRange [
	(self session process isNil or: [ context isDead ])
		ifTrue: [ ^ nil ].
	^ self session pcRangeForContext: context.
]

{ #category : #accessing }
GtPharoMethodContextCoder >> receiver [
	^ self context receiver
]

{ #category : #actions }
GtPharoMethodContextCoder >> save [
	super save
		ifFalse: [ ^ false ].

	"If compilation succedded notify the debugger. The current context is now in an 
	invalid state, as it contains the code of the old compiled method object; the context 
	has a new compiled method objects. The debugger should properly update this context if
	the context still need to be displayed on the stack."
	self notifyDebugger.

	^ true
]

{ #category : #'debugger access' }
GtPharoMethodContextCoder >> session [
	^ session
]

{ #category : #accessing }
GtPharoMethodContextCoder >> session: anObject [
	session := anObject
]

{ #category : #private }
GtPharoMethodContextCoder >> stackDebuggingActionsPragmas [
	^ #(gt2ContextDebuggingAction)
]

{ #category : #'accessing variables' }
GtPharoMethodContextCoder >> stackVariableNamesAndValuesDo: aBlock [
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
GtPharoMethodContextCoder >> stackVariableNodesDo: aBlock [
	| stackPosition |
	self context stackPtr isNil
		ifTrue: [ ^ self ].
	stackPosition := 0.
	self context stackPtr to: self context numTemps + 1 by: -1 do: [ :i | 
		aBlock value: (GTInspectorDynamicNode 
			hostObject: self context
			label: ('stack top' ,
				(stackPosition > 0
					ifTrue: [ ' - ' , stackPosition printString ]
					ifFalse: [ '' ])) 
			value: (self context at: i)).
		stackPosition := stackPosition + 1 ]
]

{ #category : #subscriptions }
GtPharoMethodContextCoder >> subscribeToSystem [
	"do nothing"
]

{ #category : #'accessing variables' }
GtPharoMethodContextCoder >> tempNamesAndValuesDo: aBlock [
	self context tempNames doWithIndex: [ :each :i | 
		| value |
		value := nil.
		[ value := self context namedTempAt: i ] on: Error do: [
			value := 'error obtaining field value' asRopedText foreground: Color red ].
		aBlock value: each value: value ]
]

{ #category : #'accessing variables' }
GtPharoMethodContextCoder >> temporaryVariableNodesDo: aBloc [
	self context tempNames withIndexCollect: [ :tempName :tempIndex |
		aBloc value: (GTInspectorContextNamedTempNode 
			hostObject: self context 
			tempName: tempName 
			tempIndex: tempIndex) ]
]

{ #category : #updating }
GtPharoMethodContextCoder >> updateSelection [
	"Still here as it is called from the SmaCC debugger.
	Remove after updating the SmaCC debugger."
]

{ #category : #updating }
GtPharoMethodContextCoder >> updateSourceFromContext [
	self needsUpdate
		ifFalse: [ ^ self ].
	self forMethod: self context method
]

{ #category : #'accessing variables' }
GtPharoMethodContextCoder >> workspaceDoItNodesDo: aBloc [
	self context gtDebuggerDoItBindings do: [:aBinding |
		aBloc value: ((GTInspectorDynamicNode 
			hostObject: self context 
			label: aBinding key 
			value: aBinding value)
				variableTag: 'temp';
				yourself) ]
]
