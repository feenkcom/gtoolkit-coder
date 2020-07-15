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
GtPharoSnippetCoder >> evaluateSource: aString showPrintString: aBoolean in: anEditorElement [

	self xDocSaveSource: aString.
	^ super evaluateSource: aString showPrintString: aBoolean in: anEditorElement
]

{ #category : #actions }
GtPharoSnippetCoder >> evaluationRequesterForEditor: anEditorElement [
	^ (super evaluationRequesterForEditor: anEditorElement)
		bindingStrategy: bindingStrategy;
		yourself
]

{ #category : #initialization }
GtPharoSnippetCoder >> forSource: aString [
	sourceCode := GtCoderConcreteSourceCode new source: aString.

	self sourceChanged.
	self notifySourceChanged.
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
	self forSource: ''
]

{ #category : #initialization }
GtPharoSnippetCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addMainAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play
		action: [ :anEditorElement | self doItSelectionOrAllFrom: anEditorElement ].
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :anEditorElement | self doItAndGoSelectionOrAll: anEditorElement ].
	addOns
		addMainAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :anEditorElement | self debugSelectionFrom: anEditorElement ].
	addOns
		addMainAction: 'Profile' translated
		icon: BrGlamorousVectorIcons performance
		action: [ :anEditorElement | self profileWithMessageTallyFrom: anEditorElement ].
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
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryD;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSnippetCoder |
				aSnippetCoder doItSelectionOrAllFrom: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryG;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSnippetCoder |
				aSnippetCoder doItAndGoSelectionOrAll: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryP;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSnippetCoder |
				aSnippetCoder printItSelectionOrAll: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryR;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSnippetCoder |
				aSnippetCoder renameVariableIn: aShortcutEvent currentTarget ];
			options: self)
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
	ast := self
		parseExpression: aString
		requestor: self highlightBindingsStrategy.
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
GtPharoSnippetCoder >> profileWithMessageTallyFrom: anEditorElement [
	| aValue |

	self clearPreviousEvaluationsInText: anEditorElement editor text.

	self validateSyntax
		ifFalse: [ ^ self ].

	aValue := self
		evaluateSource: 'MessageTally on: [ ', self sourceText asString, ']'
		in: anEditorElement.
	
	anEditorElement phlow spawnObject: aValue
]

{ #category : #actions }
GtPharoSnippetCoder >> renameVariableIn: editorElement [
	GtRenameAction pharoRenameSnippetLocalsOn: editorElement
]

{ #category : #ui }
GtPharoSnippetCoder >> requesterForEditor: aTextEditor [
	^ (super requesterForEditor: aTextEditor)
		bindingStrategy: bindingStrategy;
		yourself
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
