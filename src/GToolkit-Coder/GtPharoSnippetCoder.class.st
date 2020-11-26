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

{ #category : #'private - actions' }
GtPharoSnippetCoder >> evaluateBlock: aBlock onErrorDo: anErrorBlock [
	self xDocSaveSource: self currentSourceString.
	^ super evaluateBlock: aBlock onErrorDo: anErrorBlock
]

{ #category : #'private - actions' }
GtPharoSnippetCoder >> evaluationRequester [
	^ super evaluationRequester bindingStrategy: bindingStrategy
]

{ #category : #'private - actions' }
GtPharoSnippetCoder >> evaluationRequesterWithInterval [
	^ super evaluationRequesterWithInterval bindingStrategy: bindingStrategy
]

{ #category : #initialization }
GtPharoSnippetCoder >> forSource: aString [
	self sourceCode: (GtCoderExplicitSourceCode new source: aString)
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
	
	self forSource: ''
]

{ #category : #initialization }
GtPharoSnippetCoder >> initializeShortcuts [
	super initializeShortcuts.

	addOns
		addShortcut: GtSourceCoderDoItShortcut new;
		addShortcut: GtSourceCoderDoItAndInspectShortcut new;
		addShortcut: GtSourceCoderPrintItShortcut new;
		addShortcut: GtSourceCoderInlineRenameShortcut new
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
GtPharoSnippetCoder >> profileWithMessageTally [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		decorated: [ :aSourceString | 'MessageTally on: [ ', aSourceString, ']' ]
		thenDo: [ :anEvaluationResult | self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #actions }
GtPharoSnippetCoder >> renameIn: editorElement [
	GtRenameAction pharoRenameSnippetLocalsOn: editorElement
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
		[ XdPlaygroundSettings directory isWritable 
			ifTrue: [ self xDocStore latestFilename ]
			ifFalse: [ nil ] ].

]

{ #category : #store }
GtPharoSnippetCoder >> xDocLoadSavedContent [
	"The receiver's object has been changed under us, reload the default code (if not empty)"

	self currentSourceString ifNotEmpty: [ ^ self ].
	self forSource: self xDocSourceString
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
