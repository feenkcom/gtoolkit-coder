"
! Source coder
I am a coder for the source code. I know about the ==sourceCode== (${class:GtCoderSourceCode}$) and ==completionStrategy== (${class:GtCompletionStrategy}$).
!! Actions
All source coders know about basic actions such as code evaluation (==do it all, do it and go, do it selection and go==) or different browsing abilities. Those actions can only be executed in a presence of a text editor UI element that is passed as an argument. It is required to provide a text editor element in order to get information about cursor position or current selection, in addition to being able to have a UI context to notify user or provide her with a feedback of the executed action. All actions are always performed on the current source code text (expanded/collapsed state is not taken into account).
!! Add-ons
The source coder extends the addons (${class:GtCoderAddOns}$) with extra stylers (see ${class:GtSourceCoderAddOns}$) that allows users to add extra contextual information within the text editor via text attributes.
!! Implementation details
It is important to notice that I do not directly reference a text editor and I should not store any UI related information such as cursor position or selection.


"
Class {
	#name : #GtSourceCoder,
	#superclass : #GtCoderModel,
	#instVars : [
		'sourceCode',
		'completionStrategy',
		'astCache',
		'astMonitor',
		'astCommand'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #private }
GtSourceCoder class >> compile: aStream for: anObject in: evalContext withRequestor: requestor [
	| methodClass |
	methodClass := evalContext
		ifNil: [ anObject class ]
		ifNotNil: [ evalContext methodClass ].
	^self class compiler
		source: aStream;
		class: methodClass;
		context: evalContext;
		requestor: requestor;
		noPattern: true;
		failBlock: [ ^ nil ];
		compile
]

{ #category : #'private - actions' }
GtSourceCoder class >> debug: aCompiledMethod receiver: anObject in: evalContext [
	| guineaPig suspendedContext debugSession |

	guineaPig := [ aCompiledMethod
		valueWithReceiver: anObject
		arguments: (evalContext ifNil: [ #() ] ifNotNil: [ {evalContext} ]) ]
		newProcess.
	suspendedContext := guineaPig suspendedContext.
	
	debugSession := guineaPig newDebugSessionNamed: 'debug it' startedAt: suspendedContext.
	debugSession stepIntoUntil: [:currentContext | 
		currentContext method == aCompiledMethod ].
	
	Smalltalk tools debugger
		openOn: debugSession
		withFullView: true
]

{ #category : #constants }
GtSourceCoder class >> sourceEditorName [
	^ #editor
]

{ #category : #'api - addons' }
GtSourceCoder >> addCopyCutPasteContextMenuAddOnsTo: coderAddOns [
	<gtCoderContextMenuAddOns: 10>
	coderAddOns
		addContextMenuItem: 'Cut'
			action: [ :anEditorElement | anEditorElement editor cutSelected ];
		addContextMenuItem: 'Copy'
			action: [ :anEditorElement | anEditorElement editor copySelected ];
		addContextMenuItem: 'Paste'
			action: [ :anEditorElement | anEditorElement editor paste ]
]

{ #category : #'private - addons' }
GtSourceCoder >> addOnChanged: aSymbol [
	aSymbol = #stylers
		ifTrue: [ self notifyStylersUpdated ].
	super addOnChanged: aSymbol
]

{ #category : #'private - addons' }
GtSourceCoder >> addOnsClass [
	^ GtSourceCoderAddOns
]

{ #category : #'private - refactorings' }
GtSourceCoder >> addRefactoringChangesPreview: aRefactoring at: position [
	self
		addRefactoringChangesPreview: aRefactoring
		at: position
		whenComplete: nil
]

{ #category : #'api - text' }
GtSourceCoder >> appendString: aString [
	self critical: [
		self sourceCode appendString: aString.
		self sourceChanged ]
]

{ #category : #'private - ast' }
GtSourceCoder >> astCache [
	^ astMonitor critical: [ astCache ]
]

{ #category : #'private - ast' }
GtSourceCoder >> astCache: anAssociation [
	astMonitor critical: [ astCache := anAssociation ].
	self onAstChanged
]

{ #category : #private }
GtSourceCoder >> behavior [
	"Return a Behavior whose instance the object is"
	<return: #Behavior>
	
	^ self object class
]

{ #category : #'api - actions examples' }
GtSourceCoder >> canExecuteExample [
	<return: #Boolean>

	^ false
]

{ #category : #private }
GtSourceCoder >> classOrMetaClass [
	self
		deprecated: 'Use #behavior instead.'
		transformWith: '`@receiver classOrMetaClass' -> '`@receiver behavior'.
		
	^ self behavior
]

{ #category : #'api - text' }
GtSourceCoder >> collapsedText [
	<return: #BlText>

	^ self sourceCode collapsedText
]

{ #category : #'api - accessing' }
GtSourceCoder >> completionStrategy [
	<return: #GtCompletionStrategy>

	^ completionStrategy
		ifNil: [ completionStrategy := self newCompletionStrategy ]
]

{ #category : #'api - accessing' }
GtSourceCoder >> completionStrategy: aGtCompletionStrategy [
	completionStrategy := aGtCompletionStrategy
]

{ #category : #'api - text' }
GtSourceCoder >> correctFrom: aFromIndex to: aToIndex with: aString [
	self critical: [
		self sourceCode
			replaceFrom: aFromIndex
			to: aToIndex
			withString: aString.
		self sourceChanged.
		self notifyCorrectionFrom: aFromIndex to: aToIndex with: aString ]
]

{ #category : #'api - text' }
GtSourceCoder >> currentSourceString [
	"Return a String representation of the current source text"
	<return: #String>

	^ self critical: [ self sourceCode sourceString ]
]

{ #category : #'api - text' }
GtSourceCoder >> currentSourceString: aString [
	"Set a new source text"

	self critical: [
		self sourceCode currentSourceString: aString.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtSourceCoder >> currentSourceText: aText [
	"Set a new source text"

	self critical: [ 
		self sourceCode currentSourceText: aText.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtSourceCoder >> currentSourceTextSynchronously: aText [
	"Set a new source text"

	self critical: [
		self sourceCode currentSourceText: aText.
		self sourceChangedWith: GtCoderUpdateStragegy new makeSynchronous ]
]

{ #category : #private }
GtSourceCoder >> cursorPositionIn: aBrTextEditor do: aBlock [
	aBrTextEditor cursors do: [ :each | ^ aBlock value: each position ]
]

{ #category : #'api - actions' }
GtSourceCoder >> debug [
	self critical: [ self debug: self currentSourceString ]
]

{ #category : #'private - actions' }
GtSourceCoder >> debug: aString [
	| currentReceiver currentContext anEvaluationRequester |
	
	self critical: [
		currentReceiver := self object.
		currentContext := self context.
		anEvaluationRequester := self evaluationRequester ].

	(self class
		compile: aString 
		for: currentReceiver
		in: currentContext
		withRequestor: anEvaluationRequester) ifNotNil: [ :aMethodToDebug |
			self class debug: aMethodToDebug receiver: currentReceiver in: currentContext ]
]

{ #category : #private }
GtSourceCoder >> defaultTextAttributes [
	^ {(BlFontFamilyAttribute named: 'Source Code Pro') beNotOverwritableByStyler.
	(BlFontGenericFamilyAttribute monospace) beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}
]

{ #category : #'api - text' }
GtSourceCoder >> deleteSourceTextFrom: aFromIndex to: aToIndex [
	self critical: [
		self sourceCode delete: aFromIndex to: aToIndex.
		self sourceChanged ]
]

{ #category : #'private - ast' }
GtSourceCoder >> detectBehaviorAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a Behavior at the given source text position and evaluate a found block
	with the found Behavior as an argument if such Beahvior was found or none block otherwise. Return the result"
	<return: #Object>

	^ self
		variableNodeAt: aTextPosition
		ifFound: [ :aVariableNode |
			self
				variableNodeToBehavior: aVariableNode
				ifFound: aFoundBlock
				ifNone: aNoneBlock ]
		ifNone: aNoneBlock
]

{ #category : #'private - ast' }
GtSourceCoder >> detectBehaviorIn: aSourceString ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a Behavior within the given source string and evaluate a found block
	with the found Behavior as an argument if such Beahvior was found or none block otherwise. Return the result"
	<return: #Object>
	^ self
		variableNodeIn: aSourceString
		ifFound: [ :aVariableNode |
			self
				variableNodeToBehavior: aVariableNode
				ifFound: aFoundBlock
				ifNone: aNoneBlock ]
		ifNone: aNoneBlock
]

{ #category : #'private - ast' }
GtSourceCoder >> detectReferencesFilterAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a name (symbol) in the source code at a given text position of the entity that plays a role
	of the entity reference in the system and create a corresponding references filter.
	Evaluate a found block with the found reference as an argument or none block otherwise. Return the result"
	<return: #Object>
	^ self
		nodeAt: aTextPosition
		ifFound: [ :aNode |
			self
				nodeToReferencesFilter: aNode
				ifFound: aFoundBlock
				ifNone: aNoneBlock ]
		ifNone: aNoneBlock
]

{ #category : #'private - ast' }
GtSourceCoder >> detectReferencesFilterIn: aSourceString ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a name (symbol) in the given source string of the entity that plays a role
	of the entity reference in the system and create a corresponding references filter.
	Evaluate a found block with the found reference as an argument or none block otherwise. Return the result"
	<return: #Object>
	| aNode |

	aNode := GtPharoParser
		parseWithErrors: aSourceString
		startingAt: GtPharoParser startingStateForStatement.

	^ self
		nodeToReferencesFilter: aNode
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'private - ast' }
GtSourceCoder >> detectSelectorAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a message selector at the given source text position and evaluate a found block
	with the found selector as an argument if such selector was found or none block otherwise. Return the result"
	<return: #Object>

	^ self
		nodeAt: aTextPosition
		ifFound: [ :aNode |
			self
				nodeToSelector: aNode
				ifFound: aFoundBlock
				ifNone: aNoneBlock ]
		ifNone: aNoneBlock
]

{ #category : #'private - ast' }
GtSourceCoder >> detectSelectorIn: aSourceString ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a message selector in the given source string and evaluate a found block
	with the found selector as an argument if such selector was found or none block otherwise. Return the result"
	<return: #Object>
	| aNode |

	aNode := GtPharoParser 
		parseWithErrors: aSourceString
		startingAt: GtPharoParser startingStateForStatement.

	^ self
		nodeToSelector: aNode
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #private }
GtSourceCoder >> disabledTextAttributes [
	^ {(BlTextForegroundAttribute paint: BrGlamorousColors disabledButtonTextColor)}
]

{ #category : #'api - actions' }
GtSourceCoder >> discardChanges [
	"Discard not-accepted changes."

	self isModified
		ifFalse: [ ^ self ].

	self sourceCode resetCollapsedText.
	self sourceCode resetSourceText.

	self sourceChanged
]

{ #category : #'api - actions' }
GtSourceCoder >> doIt: aSourceIntervalOrBlock [
	"Evaluate a piece of source code within an interval and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>

	^ self evaluateInterval: aSourceIntervalOrBlock
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAll [
	^ self evaluate: [ :thisCoder | thisCoder currentSourceString ]
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGo: aSourceIntervalOrBlock [

	^ self
		evaluateInterval: aSourceIntervalOrBlock
		thenDo: [ :anEvaluationResult | self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGoAll [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		thenDo: [ :anEvaluationResult | self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		thenDo: [  ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock decorated: aSourceCodeDecorator thenDo: aThenBlock [
	"Evaluate a given source code"
	| aSourceString aBehavior anObject aContent aRequester aResult aDecoratedSourceString |
	
	"we can not wrap everything in a critical: because if there is an exception while evaluating
	the source code the current running process will be suspended, meaning that the very next evaluation
	will indefinitely wait when trying to enter a critical section."
	self critical: [
		aSourceString := aSourceStringOrBlock isClosure
			ifTrue: [ aSourceStringOrBlock cull: self ]
			ifFalse: [ aSourceStringOrBlock ].
		aBehavior := self behavior.
		anObject := self object.
		aContent := self context.
		aRequester := self evaluationRequester ].
		
	aDecoratedSourceString := aSourceCodeDecorator value: aSourceString.
	
	aResult := self evaluateBlock: [ 
		aBehavior compiler
			source: aDecoratedSourceString;
			receiver: anObject;
			context: aContent;
			requestor: aRequester;
			failBlock: [
				| aResultWithSyntaxError |
				aResultWithSyntaxError := GtSourceCoderEvaluationResultWithSyntaxError new
					sourceCoder: self;
					sourceString: aSourceString;
					sourceInterval: (1 to: aSourceString size).
				aThenBlock cull: aResultWithSyntaxError.
				^ aResultWithSyntaxError ];
			evaluate ]
		onErrorDo: [ :aResultWithError |
			aResultWithError
				sourceString: aSourceString;
				sourceInterval: (1 to: aSourceString size) ].

	aResult
		sourceString: aSourceString;
		sourceInterval: (1 to: aSourceString size).

	self notifyEvaluatedWithResult: aResult.
	aThenBlock cull: aResult.
	^ aResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock thenDo: aThenBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		decorated: [ :aSource | aSource ]
		thenDo: aThenBlock
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateBlock: aBlock onErrorDo: anErrorBlock [
	<return: #GtSourceCoderEvaluationResult>
	| aResult wasErrorAlreadySignaled |
	
	wasErrorAlreadySignaled := false.
	aResult := aBlock
		on: Error
		do: [ :anError |
			| aResultWithError |
			
			aResultWithError := GtSourceCoderEvaluationResultWithRuntimeError new 
				sourceCoder: self;
				isResignaled: wasErrorAlreadySignaled;
				error: anError.
			
			"let the caller to set source string and source interval"
			anErrorBlock value: aResultWithError.
			
			wasErrorAlreadySignaled 
				ifTrue: [ 
					"Continue the handling of this exception. This will open a debugger 
					if the error is not caught elsewhere."
					NonInteractiveTranscript stdout nextPutAll: 'before anError pass.'; cr.
					anError pass.
					NonInteractiveTranscript stdout nextPutAll: 'after anError pass.'; cr.
					^ nil ]
				ifFalse: [
					wasErrorAlreadySignaled := true.
					
					aResultWithError error: (GtCoderEvaluationUnhandledError new
							exception: anError;
							sourceCoder: self;
							sourceString: aResultWithError sourceString;
							sourceInterval: aResultWithError sourceInterval).
					
					NonInteractiveTranscript stdout nextPutAll: 'before anError resignalAs: aResultWithError error.'; cr.
					anError resignalAs: aResultWithError error.
					NonInteractiveTranscript stdout nextPutAll: 'after anError resignalAs: aResultWithError error.'; cr.
					^ nil ].
			
			"Normally, the process will be terminated during error handling, however if debugger fails to open
			it may not be terminated, so we should return a result with an explicit error "
			^ aResultWithError ].

	^ GtSourceCoderEvaluationResultWithValue new sourceCoder: self; value: aResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateInterval: aSourceIntervalOrBlock [
	^ self
		evaluateInterval: aSourceIntervalOrBlock
		thenDo: [ ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateInterval: aSourceIntervalOrBlock thenDo: aThenBlock [
	"Evaluate a part of the source code within the interval that is specified by aSourceIntervalOrBlock
	which can directly be an Interval or a block that when evaluated returns an interval"
	| aSourceText aSourceInterval aSourceString aBehavior anObject aContext aRequester anEvaluationResult |
	
	"we can not wrap everything in a critical: because if there is an exception while evaluating
	the source code the current running process will be suspended, meaning that the very next evaluation
	will indefinitely wait when trying to enter a critical section."
	self critical: [
		aSourceText := self sourceText.
		aSourceInterval := aSourceIntervalOrBlock isClosure
			ifTrue: [ aSourceIntervalOrBlock cull: aSourceText]
			ifFalse: [ aSourceIntervalOrBlock ].
		aSourceString := (aSourceText copyFrom: aSourceInterval first to: aSourceInterval last) asString.
		aBehavior := self behavior.
		anObject := self object.
		aContext := self context.
		aRequester := self evaluationRequesterWithInterval interval: aSourceInterval; source: aSourceString ].

	anEvaluationResult := aSourceString
			ifNotEmpty: [
				| aResult |
				aResult := self evaluateBlock: [ 
					aBehavior compiler
						source: aSourceString;
						receiver: anObject;
						context: aContext;
						requestor: aRequester;
						failBlock: [
							| aResultWithSyntaxError |
							aResultWithSyntaxError := GtSourceCoderEvaluationResultWithSyntaxError new
								sourceCoder: self;
								sourceString: aSourceString;
								sourceInterval: aSourceInterval.
							self notifyEvaluatedWithResult: aResultWithSyntaxError.
							aThenBlock cull: aResultWithSyntaxError.
							^ aResultWithSyntaxError ];
						evaluate ]
					onErrorDo: [ :aResultWithError |
						aResultWithError
							sourceString: aSourceString;
							sourceInterval: aSourceInterval ].
	
				aResult
					sourceString: aSourceString;
					sourceInterval: aSourceInterval.

				aResult ]
			ifEmpty: [
				GtSourceCoderEvaluationResultWithSyntaxError new
					sourceCoder: self;
					sourceString: '';
					sourceInterval: (1 to: 0) ].

	self notifyEvaluatedWithResult: anEvaluationResult.
	aThenBlock cull: anEvaluationResult.
	^ anEvaluationResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluationRequester [
	^ GtSourceCoderEvaluationRequester new coder: self
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluationRequesterWithInterval [
	^ GtSourceCoderIntervalEvaluationRequester new coder: self
]

{ #category : #'gt-extensions' }
GtSourceCoder >> gtViewStylersFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewStylersFor: aView ]
]

{ #category : #testing }
GtSourceCoder >> hasObjectAttribute [
	<return: #Boolean>
	self 
		attributeNamed: #object 
		ifAbsent: [ ^ false ].

	^ true
]

{ #category : #initialize }
GtSourceCoder >> initialize [
	super initialize.

	astMonitor := Monitor new.
	self reset
]

{ #category : #initialize }
GtSourceCoder >> initializeAddOns [
	super initializeAddOns.
	
	addOns addStyler: BrRBTextStyler new.
	
	addOns clearChanges
]

{ #category : #initialize }
GtSourceCoder >> initializeShortcuts [

	addOns
		addShortcut: GtSourceCoderBrowseImplementorsShortcut new;
		addShortcut: GtSourceCoderBrowseReferencesShortcut new;
		addShortcut: GtSourceCoderBrowseBehaviorShortcut new;
		addShortcut: GtSourceCoderDiscardChangesShortcut new
]

{ #category : #testing }
GtSourceCoder >> isForMethod [
	^ false
]

{ #category : #testing }
GtSourceCoder >> isModified [
	<return: #Boolean>

	^ self sourceCode isModified
]

{ #category : #private }
GtSourceCoder >> newCompletionStrategy [
	^ GtPharoCompletionStrategy new
		classOrMetaClass: self behavior;
		yourself
]

{ #category : #'private - ast' }
GtSourceCoder >> newRbAST: aString [
	| ast |
	ast := self parseExpression: aString requestor: nil.
	ast doSemanticAnalysis.
	^ ast
]

{ #category : #private }
GtSourceCoder >> newSourceStylerFrom: anEditorElement [
	<return: #GtSourceCoderTextStyler>
	| anAddOnsCopy |

	anAddOnsCopy := self addOns stylers copy.
	anAddOnsCopy do: [ :eachAddOn | 
		eachAddOn editorElement: anEditorElement ].

	^ (GtSourceCoderTextStyler forCoder: self)
		stylers: anAddOnsCopy;
		yourself
]

{ #category : #'private - ast' }
GtSourceCoder >> nodeAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [
	<return: #Object>
	[
		| theAST innerNode |
		theAST := self sourceAst.
		theAST
			withAllNodesDo: [ :node | 
				(aTextPosition between: node startPosition and: node stopPosition)
					ifTrue: [ innerNode := node ] ].
		^ innerNode ifNil: aNoneBlock ifNotNil: aFoundBlock ]
			on: Error
			do: [ :ex | ex return ].
		
	^ aNoneBlock value
]

{ #category : #'private - ast' }
GtSourceCoder >> nodeToReferencesFilter: aNode ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to create a references filter from a given AST node. If aNode is not suitable
	for creating a filter, also check all parents of that node. Evaluate aFoundBlock if a references filter
	was built and aNoneBlock otherwise, return the result of the block evaluation"
	<return: #Object>
	| aCurrentNode |

	aCurrentNode := aNode.

	[ aCurrentNode notNil ] whileTrue: [
		(aCurrentNode isKindOf: GtPharoVariableNode)
			ifTrue: [
				^ self
					variableNodeToReferencesFilter: aCurrentNode
					ifFound: aFoundBlock
					ifNone: aNoneBlock ].
		(aCurrentNode isKindOf: GtPharoSymbolLiteralNode)
			ifTrue: [ ^ aFoundBlock value: (self referencesFilterForLiteral: aCurrentNode asSymbol) ].
		(aCurrentNode isKindOf: GtPharoStringLiteralNode)
			ifTrue: [ ^ aFoundBlock value: (self referencesFilterForString: aCurrentNode value value) ].
		(aCurrentNode isKindOf: GtPharoCharacterLiteralNode)
			ifTrue: [ ^ aFoundBlock value: (self referencesFilterForCharacter: aCurrentNode value value) ].
		(aCurrentNode isKindOf: GtPharoBooleanLiteralNode)
			ifTrue: [ ^ aFoundBlock value: (self referencesFilterForBoolean: aCurrentNode value value) ].
		(aCurrentNode isKindOf: GtPharoNumberLiteralNode)
			ifTrue: [ ^ aFoundBlock value: (self referencesFilterForNumber: aCurrentNode value value) ].
		((aCurrentNode isKindOf: GtPharoMessageNode)
			or: [ aCurrentNode isKindOf: GtPharoMethodPatternNode ])
			ifTrue: [ ^ aFoundBlock value: (self referencesFilterForLiteral: aCurrentNode selector) ].
		(aCurrentNode isKindOf: GtPharoMessageSendNode)
			ifTrue: [ aCurrentNode := aCurrentNode message ]
			ifFalse: [ aCurrentNode := aCurrentNode parent ] ].

	^ aNoneBlock value
]

{ #category : #'private - ast' }
GtSourceCoder >> nodeToSelector: aNode ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to extract a message selector from a given AST node. If aNode is not suitable
	for extracting a selector, also check all parents of that node. Evaluate aFoundBlock if a selector
	is found and aNoneBlock otherwise, return the result of the block evaluation"
	<return: #Object>
	| aCurrentNode |

	aCurrentNode := aNode.
	[ aCurrentNode notNil ]
		whileTrue: [
			(aCurrentNode isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ aFoundBlock value: aCurrentNode name source asSymbol ].
			(aCurrentNode isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ aFoundBlock value: aNode asSymbol ].
			(aCurrentNode isKindOf: GtPharoMessageSendNode)
				ifTrue: [ aCurrentNode := aCurrentNode message ].
			((aCurrentNode isKindOf: GtPharoMessageNode)
				or: [ aCurrentNode isKindOf: GtPharoMethodPatternNode ])
				ifTrue: [ ^ aFoundBlock value: aCurrentNode selector ].
			aCurrentNode := aCurrentNode parent ].
	^ aNoneBlock value
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyCorrectionFrom: aFromIndex to: aToIndex with: aString [
	self announce: (GtCoderCorrectionRequest new
		coder: self;
		fromIndex: aFromIndex;
		toIndex: aToIndex;
		correctionString: aString)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyEvaluatedWithResult: anEvaluationResult [
	self announce: (GtCoderEvaluationAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawn: anObject [
	self
		notifyObjectSpawn: anObject
		withDestination: self spawnDestination
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawn: anObject withDestination: aSpawnDestination [
	self announce: (GtCoderObjectSpawnRequest new 
		object: anObject;
		spawnDestination: aSpawnDestination;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawnFromEvaluationResult: anEvaluationResult [
	
	anEvaluationResult isSuccess
		ifFalse: [ ^ self ].
	
	self
		notifyObjectSpawn: anEvaluationResult value
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyParseError: aString at: anInteger [
	self announce: (GtCoderParseError new
		coder: self;
		errorMessage: aString;
		location: anInteger)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyShowDebuggerRequest: aDebugSession dueTo: anException sourceString: aSourceString sourceInterval: aSourceInterval [
	self announce: (GtCoderShowDebuggerRequest new
		coder: self;
		debugSession: aDebugSession;
		exception: anException;
		sourceString: aSourceString;
		sourceInterval: aSourceInterval)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifySourceChangedWith: anUpdateStragegy [
	"Notify the text editor that it should update the text (for example due to refactoring changes)"
	
	self announce: (GtCoderSourceCodeChanged new 
		updateStragegy: anUpdateStragegy;
		coder: self;
		source: anUpdateStragegy announcementSource)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyStylersUpdated [
	"Is sent when AddOn stylers changed. It also means that the text editor should restyle the text"

	self announce: (GtCoderStylerChanged new
		coder: self;
		stylers: self addOns stylers copy)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyToolSpawn: aTool withDestination: aSpawnDestination [
	self announce: (GtCoderToolSpawnRequest new 
		tool: aTool;
		spawnDestination: aSpawnDestination;
		coder: self)
]

{ #category : #'api - accessing' }
GtSourceCoder >> object [
	"Return an object in the context of which the source code is modified (may influence self binding)
	or nil otherwise of not set"
	<return: #Object or: nil>

	^ self
		attributeNamed: #object
		ifAbsent: [ nil ]
]

{ #category : #'api - accessing' }
GtSourceCoder >> object: anObject [
	"Set an object in the context of which the source code should be modified (may influence self binding)"

	anObject 
		ifNil: [ self removeAttributeNamed: #object ]
		ifNotNil: [ self attributeNamed: #object put: anObject ]
]

{ #category : #'private - ast' }
GtSourceCoder >> onAstChanged [
]

{ #category : #accessing }
GtSourceCoder >> package [
	^ self attributeNamed: #package
]

{ #category : #accessing }
GtSourceCoder >> packageTag [
	^ self attributeNamed: #packageTag
]

{ #category : #private }
GtSourceCoder >> parse: aString asExpression: isExpression requestor: aRequestor [
	^ (self behavior ifNil: [ UndefinedObject ]) compiler
		source: aString;
		noPattern: isExpression;
		options: #(+ optionParseErrors + optionSkipSemanticWarnings);
		requestor: aRequestor;
		parse
]

{ #category : #private }
GtSourceCoder >> parseExpression: aString requestor: aRequestor [
	^ self parse: aString asExpression: true requestor: aRequestor
]

{ #category : #private }
GtSourceCoder >> parseMethod: aString [
	^ self parse: aString asExpression: false requestor: nil
]

{ #category : #private }
GtSourceCoder >> parserStartingState [
	^ GtPharoParser startingStateForMethodSequence
]

{ #category : #private }
GtSourceCoder >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSuperclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #'api - actions' }
GtSourceCoder >> printItAll [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		thenDo: [ :aResult | ]
]

{ #category : #'api - actions' }
GtSourceCoder >> printItWithin: aSourceIntervalBlock [
	"Evaluate a piece of source code within an interval returned by aSourceIntervalBlock and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>

	^ self
		evaluateInterval: aSourceIntervalBlock
		thenDo: [ :aResult | ]
]

{ #category : #accessing }
GtSourceCoder >> protocol [
	^ #accessing
]

{ #category : #'private - ast' }
GtSourceCoder >> rbAST [
	| source |

	"The AST should be built out of the `characters` of the source text.
	This is needed to support `crlf` and logical items
	see https://github.com/feenkcom/gtoolkit/issues/593"
	source := self currentSourceString.
	astCache key = source
		ifTrue: [ ^ astCache value ].
	^ [ 
		self astCache: source -> (self newRbAST: source).
		astCache value ]
	on: Error
	do: [ :ex | ex return: nil ]
]

{ #category : #'private - ast' }
GtSourceCoder >> rbASTAsyncDo: aBlock [

	astMonitor critical: [ 
		| aCommand astComputationCommand |
		astCommand ifNotNil: #terminate.

		astComputationCommand := [
			| source currentAstCache |
			"The AST should be built out of the `characters` of the source text.
			This is needed to support `crlf` and logical items
			see https://github.com/feenkcom/gtoolkit/issues/593"
			source := self sourceText copy characters asString.
			currentAstCache := self astCache.

			currentAstCache key = source
				ifTrue: [ currentAstCache ]
				ifFalse: [
					[ source -> (self newRbAST: source) ]
						on: Error
						do: [ :ex | ex return: nil ] ].

		] asBlTktTerminableCommand asBlTktLoggingCommand.
		astComputationCommand name: 'Coder ast computation'.
		
		astCommand := aCommand := BlTaskAtPostponedTerminableFuture new.
		aCommand
			command: astComputationCommand;
			onSuccessDo:  [ :aResult | 
				(aCommand == astCommand and: [ aResult notNil ])
					ifTrue: [
						self astCache: aResult.
						aBlock value: aResult ] ];
			onFailureDo: [ :anException | "handle error here" ];
			pool: BlTktWorkerProvider coderPool;
			scheduledTime: BlTime real now + 100 milliSeconds.
		BlTaskAtQueue default schedule: astCommand.
	
	 ].
]

{ #category : #private }
GtSourceCoder >> rbNodeAt: aTextIndex [
	| ast node |

	ast := self rbAST.
	ast ifNil: [ ^ nil ].

	node := nil.
	ast
		nodesDo: [ :each | 
			(aTextIndex between: each start and: each stop)
				ifTrue: [ (node isNil
						or: [ node sourceInterval size > each sourceInterval size ])
						ifTrue: [ node := each ] ] ].
	^ node
]

{ #category : #private }
GtSourceCoder >> rbNodeAtCursor: editorElement [
	| editor ast position node |
	editor := editorElement editor.
	editor cursors cursorsCount = 1
		ifFalse: [ ^ nil ].
	ast := self rbAST.
	ast isNil
		ifTrue: [ ^ nil ].
	position := editor cursors first position.
	ast
		nodesDo: [ :each | 
			(position between: each start and: each stop)
				ifTrue: [ (node isNil
						or: [ node sourceInterval size > each sourceInterval size ])
						ifTrue: [ node := each ] ] ].
	^ node
]

{ #category : #'private - ast' }
GtSourceCoder >> referencesFilterForBoolean: aBooleanAsString [
	"aBooleanAsString would be a string 'true', which should be evaluated to get a boolean"

	^ self referencesFilterForLiteral: (Object evaluate: aBooleanAsString)
]

{ #category : #'private - ast' }
GtSourceCoder >> referencesFilterForCharacter: aCharacterAsString [
	"aCharacterAsString would be a string '$a', which should be evaluated to get a character"

	^ self referencesFilterForLiteral: (Object evaluate: aCharacterAsString)
]

{ #category : #'private - ast' }
GtSourceCoder >> referencesFilterForLiteral: anObject [
	^ GtSearchReferencesFilter literal: anObject
]

{ #category : #'private - ast' }
GtSourceCoder >> referencesFilterForNumber: aNumberAsString [
	"aNumberAsString would be a string '42', which should be evaluated to get a boolean"

	^ self referencesFilterForLiteral: (Object evaluate: aNumberAsString)
]

{ #category : #'private - ast' }
GtSourceCoder >> referencesFilterForString: aString [
	"we have to dispatch through the compiler and to evaluate: the string, otherwise it will not be searched for
	because it is compared by identity and compiler does some string optimizations"

	^ self referencesFilterForLiteral: (Object evaluate: aString)
]

{ #category : #'private - ast' }
GtSourceCoder >> referencesFilterForSymbol: aSymbol [
	^ self referencesFilterForLiteral: aSymbol
]

{ #category : #'api - text' }
GtSourceCoder >> requestStyleSourceText [
	"Request the text editor to restyle the text (for example due to environmental changes)"

	self resetASTCache.
	self announce: (GtCoderStyleTextRequest new coder: self)
]

{ #category : #'api - text' }
GtSourceCoder >> requestStyleSourceTextAndAfterDo: aBlock [
	"Request the text editor to restyle the text (for example due to environmental changes)"

	self resetASTCache.
	self
		announce:
			(GtCoderStyleTextRequest new
				coder: self;
				afterAction: aBlock)
]

{ #category : #'api - text' }
GtSourceCoder >> requestUpdateCollapsedText [
	"Request to update the collapsed text, for example due to changes in the current source text.
	It is not guaranteed that the collapsed text actually changes as for example in the method coder
	opened on a compiled method"

	self sourceCode resetCollapsedText.
	self announce: (GtCoderCollapsedLabelChanged new coder: self)
]

{ #category : #initialize }
GtSourceCoder >> reset [
	self resetASTCache.

	"initialized lazily in #sourceCode"
	sourceCode := nil.
	completionStrategy := nil
]

{ #category : #'private - actions' }
GtSourceCoder >> resetASTCache [
	self astCache: (nil -> nil)
]

{ #category : #'api - accessing' }
GtSourceCoder >> source [
	<return: #String>

	self
		deprecated: 'Use #currentSourceString instead'
		transformWith: '`@receiver source' -> '`@receiver currentSourceString'.
		
	^ self currentSourceString
]

{ #category : #private }
GtSourceCoder >> sourceAst [
	^ GtPharoParser
		parseWithErrors: self currentSourceString
		startingAt: self parserStartingState
]

{ #category : #'event handling' }
GtSourceCoder >> sourceChanged [
	self sourceChangedWith: GtCoderUpdateStragegy new makeAsynchronous
]

{ #category : #'event handling' }
GtSourceCoder >> sourceChangedWith: anUpdateStrategy [
	self requestUpdateCollapsedText.
	self requestUpdateAddOns.
	
	self notifySourceChangedWith: anUpdateStrategy
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceCode [
	<return: #GtCoderSourceCode>

	sourceCode ifNil: [ self sourceCode: (GtCoderExplicitSourceCode new source: '') ].
	^ sourceCode
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceCode: aGtCoderSourceCode [
	"Set the source code of this coder to a given one and notify about the changes"
	
	self 
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStragegy new makeAsynchronous
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceCode: aGtCoderSourceCode withStrategy: anUpdateStragegy [
	"Set the source code of this coder to a given one and notify about the changes"
	
	sourceCode := aGtCoderSourceCode.
	self sourceChangedWith: anUpdateStragegy.
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceCodeSynchronously: aGtCoderSourceCode [
	self
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStragegy new makeSynchronous
]

{ #category : #'api - text' }
GtSourceCoder >> sourceText [
	"Return the source text for this coder. The computation of the source text may be expensive, use me with caution.
	If the operation you would like to perform on the source text is optional consider using #sourceTextDo:"
	<return: #BlText>

	^ self sourceCode sourceText
]

{ #category : #'api - text' }
GtSourceCoder >> sourceTextDo: aBlock [
	"Evaluate a given block with my source code text if present"

	^ self sourceCode sourceTextDo: aBlock
]

{ #category : #accessing }
GtSourceCoder >> spawnDestination [
	^ self 
		attributeNamed: #spawnDestination 
		ifAbsent: [ GtPhlowSpawnDesiredDestination defaultDestination ]
]

{ #category : #accessing }
GtSourceCoder >> spawnDestination: aSpawnDestination [
	self attributeNamed: #spawnDestination put: aSpawnDestination
]

{ #category : #'api - addons' }
GtSourceCoder >> stylers [
	^ self addOns stylers
]

{ #category : #'private - addons' }
GtSourceCoder >> terminateAddOnsCommand [
	addOnCommand
		ifNil: [ ^ self ].
	addOnCommand terminate.
	addOnCommand := nil
]

{ #category : #'api - addons' }
GtSourceCoder >> updateAddOns [
	"Start the update of the addons in a context of a given element"

	addOnMonitor
		critical: [			 
			BlUseAsyncFeatures 
				ifEnabledDo: [ 
					self terminateAddOnsCommand.
					addOnCommand := self updateAddOnsCommand.
					addOnCommand name: 'AddOns: ' , self identityHash printString.
					BlTktWorkerProvider coderPool schedule: addOnCommand ]
				otherwise: [ 
					self updateAddOnsCommand execute ] ]
]

{ #category : #'private - addons' }
GtSourceCoder >> updateAddOnsCommand [
	^ [
		| updatedAddOns pragmas ast |
		ast := self rbAST.
		pragmas := self
			pragmasNamed: #gtAstCoderAddOns:
			inHierarchy: self class.
		updatedAddOns := self addOns copy.
		pragmas
			reverseDo:
				[ :each | self perform: each methodSelector with: ast with: updatedAddOns ].
		addOns := updatedAddOns.
		addOns markAsUpdated.
		updatedAddOns changesDo: [ :each | self addOnChanged: each ].
		updatedAddOns clearChanges
	] asBlTktTerminableCommand
]

{ #category : #'api - addons' }
GtSourceCoder >> updateContextMenuAddOnsFrom: anEditorElement [
	| updatedAddOns pragmas |
	pragmas := self
		pragmasNamed: #gtCoderContextMenuAddOns:
		inHierarchy: self class.
	updatedAddOns := self addOns copy.
	updatedAddOns clearContextMenu.
	pragmas
		do: [ :each | self perform: each methodSelector withEnoughArguments: { updatedAddOns. anEditorElement } ].
	addOns := updatedAddOns.
	updatedAddOns clearChanges
]

{ #category : #private }
GtSourceCoder >> validateSyntax [
	<return: #Boolean>

	[ GtPharoParser
		parse: self currentSourceString
		startingAt: self parserStartingState ]
		on: SmaCCParserError
		do: [ :ex | 
			self notifyParseError: ex messageText at: ex tag position.
			^ false ].
	^ true
]

{ #category : #'private - ast' }
GtSourceCoder >> variableNodeAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a variable node ${class:GtPharoVariableNode}$ at a given text position and evaluate a found
	block if such node exists and none block otherwise. Return the result"
	<return: #Object>
	[
		| theAST |
		theAST := self sourceAst.
		theAST
			withAllNodesOfType: GtPharoVariableNode
			do: [ :node | 
				(aTextPosition between: node startPosition and: node stopPosition)
					ifTrue: [ ^ aFoundBlock value: node ] ] ]
		on: Error
		do: [ :ex | ex return ].

	^ aNoneBlock value
]

{ #category : #'private - ast' }
GtSourceCoder >> variableNodeIn: aSourceString ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to extract a variable node ${class:GtPharoVariableNode}$ in a given string and evaluate a found block
	if such node was found and a none block otherwise. Return the result."
	<return: #Object>
	| eachNode |

	eachNode := GtPharoParser 
		parseWithErrors: aSourceString
		startingAt: GtPharoParser startingStateForStatement.

	[ eachNode isNil ]
		whileFalse: [ 
			(eachNode isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ aFoundBlock value: eachNode ].
			eachNode := eachNode parent ].

	^ aNoneBlock value
]

{ #category : #'private - ast' }
GtSourceCoder >> variableNodeToBehavior: aVariableNode ifFound: aFoundBlock ifNone: aNoneBlock [
	"Convert a given variable node to a behavior registered in the system and evaluate
	a found block if such behavior exists, evaluate none block otherwise. Return the result"
	<return: #Object>
	| aVariableName aBehavior |

	aVariableName := aVariableNode name value asSymbol.

	aBehavior := self class environment
		at: aVariableName
		ifAbsent: [ ^ aNoneBlock value ].

	aBehavior isBehavior
		ifFalse: [ ^ aNoneBlock value ].

	^ aFoundBlock value: aBehavior
]

{ #category : #'private - ast' }
GtSourceCoder >> variableNodeToReferencesFilter: aVariableNode ifFound: aFoundBlock ifNone: aNoneBlock [
	"Convert a given variable node to the references filter and evaluate
	a found block if such filter can be created, evaluate none block otherwise. Return the result"
	<return: #Object>
	| aVariableName aVariableIndex aDefiningClass aBinding |
	
	aVariableName := aVariableNode name source.
	aVariableIndex := self behavior instVarIndexFor: aVariableName.
	aVariableIndex > 0
		ifTrue: [
			aDefiningClass := self behavior whichClassDefinesInstVar: aVariableName.
			^ aFoundBlock value: (GtSearchInstanceVariableReferenceFilter
				forClassAndSubclasses: aDefiningClass
				andVariable: aVariableName) ].

	aBinding := self behavior bindingOf: aVariableName.
	aBinding notNil
		ifTrue: [ ^ aFoundBlock value: (GtSearchReferencesFilter literal: aBinding) ].
		
	"At this point we know that it is not an instance/class varaible, nor it is a binding.
	We therefore fallback to the basic literal references filter"

	^ aFoundBlock value: (self referencesFilterForLiteral: aVariableName asSymbol)
]

{ #category : #elements }
GtSourceCoder >> withoutHeader [
	self coderLook: nil
]
