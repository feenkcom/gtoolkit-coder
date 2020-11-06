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

{ #category : #'debugger access' }
GtMethodContextCoder >> close [
	self notifyDebugger.
	
	self flag: 'check why this is needed'.
	self updateSelection
]

{ #category : #actions }
GtMethodContextCoder >> compile [
	^ self
		handleCompilerErrorsDuring: [
			self session
				gtRecompileMethodTo: self newMethodSource
				inContext: self context
				notifying: self compilationRequester ]
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

	^ ((self actionsForPragmas: self stackDebuggingActionsPragmas)
		select: [ :aDebuggingAction | 
			"Quite hacky solutions for only showing StepInto for the top context."
			aDebuggingAction class ~= StepIntoDebugAction or: [ 
				self context = self session interruptedContext ] ])
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

{ #category : #'accessing variables' }
GtMethodContextCoder >> debuggerVariableNodes [
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
GtMethodContextCoder >> initializeAddOns [
	super initializeAddOns.

"	addOns addStyler: (GtCoderContextVariableButtonStyler new methodCoder: self)."
"	addOns addStyler: (GtCoderContextVariableValueStyler new methodCoder: self)"
]

{ #category : #initialize }
GtMethodContextCoder >> initializeShortcuts [ 
	super initializeShortcuts.
	addOns 
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryP;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSourceCoder |
				aSourceCoder printItSelectionFrom: aShortcutEvent currentTarget ];
			options: self)
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> instanceVariableNamesAndValuesDo: aBlock [
	| receiver |
	receiver := self receiver.
	receiver class allInstVarNames doWithIndex: [ :each :i | 
		aBlock value: each value: (receiver instVarAt: i) ]
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> instanceVariableNodesDo: aBloc [
	self receiver class allSlots collect: [ :aSlot | 
		aBloc value: (GTInspectorSlotNode 
			hostObject: self receiver 
			slot: aSlot) ]
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

{ #category : #printing }
GtMethodContextCoder >> printOn: aStream [
	super printOn: aStream.
	self context ifNotNil: [ 
		aStream nextPut: $(.
		self context printOn: aStream. 
		aStream nextPut: $) ]
]

{ #category : #accessing }
GtMethodContextCoder >> receiver [
	^ self context receiver
]

{ #category : #actions }
GtMethodContextCoder >> save [
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
GtMethodContextCoder >> stackVariableNodesDo: aBlock [
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
GtMethodContextCoder >> subscribeToSystem [
	"do nothing"
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> tempNamesAndValuesDo: aBlock [
	self context tempNames doWithIndex: [ :each :i | 
		| value |
		value := nil.
		[ value := self context namedTempAt: i ] on: Error do: [
			value := 'error obtaining field value' asRopedText foreground: Color red ].
		aBlock value: each value: value ]
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> temporaryVariableNodesDo: aBloc [
	self context tempNames withIndexCollect: [ :tempName :tempIndex |
		aBloc value: (GTInspectorContextNamedTempNode 
			hostObject: self context 
			tempName: tempName 
			tempIndex: tempIndex) ]
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
	"https://github.com/feenkcom/gtoolkit/issues/1323
	Ideally, we should convert this to the add-on styler"
	self flag: #TODO.
	(self session process isNil or: [ context isDead ])
		ifTrue: [ ^ self ].
	interval := self session pcRangeForContext: context.
	interval isEmpty
		ifTrue: [ ^ self ].
	self sourceText
		clearAttributes: [ :each | each class = BlTextDecorationAttribute ].
	(self sourceText from: interval first to: interval last)
		underlineDo: [ :anAttribute | 
			anAttribute
				color: BrGlamorousColors errorBackgroundColor;
				thickness: 1.5;
				beNotOverwritableByStyler ]
]

{ #category : #updating }
GtMethodContextCoder >> updateSourceFromContext [
	self forMethod: self context method
]

{ #category : #'accessing variables' }
GtMethodContextCoder >> workspaceDoItNodesDo: aBloc [
	self context gtDebuggerDoItBindings do: [:aBinding |
		aBloc value: ((GTInspectorDynamicNode 
			hostObject: self context 
			label: aBinding key 
			value: aBinding value)
				variableTag: 'temp';
				yourself) ]
]
