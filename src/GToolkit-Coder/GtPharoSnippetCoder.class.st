Class {
	#name : #GtPharoSnippetCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'bindingStrategy',
		'context',
		'xdocFilename'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtPharoSnippetCoder >> context [
	^ context
]

{ #category : #accessing }
GtPharoSnippetCoder >> context: doItContext [
	context := doItContext
]

{ #category : #private }
GtPharoSnippetCoder >> evaluateSource: aString showPrintString: aBoolean [

	self xDocSaveSource: aString.
	^ super evaluateSource: aString showPrintString: aBoolean
]

{ #category : #actions }
GtPharoSnippetCoder >> evaluationRequester [
	^ super evaluationRequester
		bindingStrategy: bindingStrategy;
		yourself
]

{ #category : #private }
GtPharoSnippetCoder >> finishedStylingCollapsedText [
	self collapsedEditor text foreground: BrGlamorousColors disabledHeaderTextColor
]

{ #category : #private }
GtPharoSnippetCoder >> highlightBindingsStrategy [
	^ self context 
		ifNil:  [ GtHighlightingBindingStrategy new 
			bindings: bindingStrategy bindings]
		ifNotNil: [ GtContextHighlightingBindingStrategy new
			bindings: bindingStrategy bindings;
			context: self context ] 
]

{ #category : #initialization }
GtPharoSnippetCoder >> initialize [
	bindingStrategy := GtSnippetBindingStrategy new.
	bindingStrategy bindings: GtSnippetBindings new.
	super initialize.
	expanded := true.
	self source: ''
]

{ #category : #initialization }
GtPharoSnippetCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addMainAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aButton | self doItSelectionOrAll ].
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aButton | self doItAndGoSelectionOrAll: aButton ].
	addOns
		addMainAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aButton | self debugSelection ].
	addOns
		addMainAction: 'Profile' translated
		icon: BrGlamorousVectorIcons performance
		action: [ :aButton | self profileWithMessageTallyFrom: aButton ].
	addOns
		addStyler:
			(BrRBTextStyler new
				isForWorkspace: true;
				yourself).
	addOns clearChanges
]

{ #category : #initialization }
GtPharoSnippetCoder >> initializeShortcuts [
	super initializeShortcuts.

	addOns
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryD;
			action: [ self doItSelectionOrAll ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryG;
			action: [ :anEvent | self doItAndGoSelectionOrAll: anEvent currentTarget ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryP;
			action: [ self printItSelectionOrAll ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryR;
			action: [ :anEvent | self renameVariableIn: anEvent currentTarget ])
]

{ #category : #private }
GtPharoSnippetCoder >> newCompletionStrategy [
	| strategy |
	strategy := super newCompletionStrategy
		isMethod: false;
		hasImplicitVariables: true;
		yourself.
	strategy bindings: bindingStrategy bindings.
	^ strategy
]

{ #category : #updating }
GtPharoSnippetCoder >> newRbAST: aString [
	| ast |
	ast := RBParser parseFaultyExpression: aString.
	ast methodNode 
		compilationContext: (CompilationContext new
			class: (self classOrMetaClass ifNil: [UndefinedObject]);
         requestor: self highlightBindingsStrategy).
	ast doSemanticAnalysis.
	^ ast
]

{ #category : #accessing }
GtPharoSnippetCoder >> object [
	^ (bindingStrategy bindings respondsTo: #receiver)
		ifTrue: [ bindingStrategy bindings receiver ]
		ifFalse: [ nil ]
]

{ #category : #actions }
GtPharoSnippetCoder >> profileWithMessageTallyFrom: aButton [
	| aValue |
	self clearPreviousEvaluations.
	self validateSyntax
		ifFalse: [ ^ self ].
	aValue := self evaluateSource: 'MessageTally on: [ ', self sourceEditor text asString, ']'.
	aButton phlow spawnObject: aValue.
]

{ #category : #actions }
GtPharoSnippetCoder >> renameVariableIn: editorElement [
	GtRenameAction pharoRenameSnippetLocalsOn: editorElement
]

{ #category : #ui }
GtPharoSnippetCoder >> requester [
	^ super requester
		bindingStrategy: bindingStrategy;
		yourself
]

{ #category : #accessing }
GtPharoSnippetCoder >> source: aString [
	self sourceEditor text: aString asRopedText.
	self sourceEditor text attributes: self defaultTextAttributes.
	self sourceChanged
]

{ #category : #accessing }
GtPharoSnippetCoder >> variableBindings [
	^ bindingStrategy bindings
]

{ #category : #accessing }
GtPharoSnippetCoder >> variableBindings: aGtPlaygroundBindings [
	bindingStrategy bindings: aGtPlaygroundBindings.
	completionStrategy notNil
		ifTrue: [ completionStrategy bindings: aGtPlaygroundBindings ]
]

{ #category : #store }
GtPharoSnippetCoder >> xDocFilename [
	"Answer the filename containing the receiver's source.
	If no action has been performed, use the last saved code.
	If an action has been performed gtPlaygroundFilename will have been set."

	^xdocFilename ifNil: 
		[ self xDocStore latestFilename ].

]

{ #category : #store }
GtPharoSnippetCoder >> xDocLoadSavedContent [
	"The receiver's object has been changed under us, reload the default code (if not empty)"

	self source ifNotEmpty: [ ^self ].
	self source: self xDocSourceString.
]

{ #category : #store }
GtPharoSnippetCoder >> xDocSaveSource: aString [ 
	"Save the supplied source code"

	self object ifNil: [ ^self ].

	xdocFilename ifNil: 
		[ xdocFilename := self xDocStore newFile ].

	^ XdWriter new 
				streamingStrategy: (XdStreamingStrategy file: xdocFilename);
				authorName: 'PharoLink Playground';
				title: 'Playground Source Code';
				description: 'Playground Source Code';
				text;
				attachment: 'playground.source' text: aString;
				write
]

{ #category : #store }
GtPharoSnippetCoder >> xDocSourceString [
	"Answer the string to be initially displayed in the snippet"
	| sourceFile xDoc |

	self object ifNil: [ ^'' ].

	sourceFile := self xDocFilename.
	sourceFile ifNil: [ ^'' ].

	xDoc := XdReader new 
				streamingStrategy: (XdStreamingStrategy file: sourceFile);
				read.
	^ (xDoc memberNamed: 'playground.source') contents utf8Decoded.

]

{ #category : #store }
GtPharoSnippetCoder >> xDocStore [
	"Answer the XDoc store for the receiver."

	^ XdKeyDocumentStore forKey: self xDocStoreKey
]

{ #category : #store }
GtPharoSnippetCoder >> xDocStoreKey [
	"Answer the key to be used for storing documents"

	^ self object class name
]
