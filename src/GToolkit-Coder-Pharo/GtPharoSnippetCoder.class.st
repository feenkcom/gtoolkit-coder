Class {
	#name : #GtPharoSnippetCoder,
	#superclass : #GtPharoSourceCoder,
	#instVars : [
		'bindingStrategy',
		'context',
		'xdocFilename'
	],
	#category : #'GToolkit-Coder-Pharo-Coders'
}

{ #category : #'instance creation' }
GtPharoSnippetCoder class >> forSource: aString [
	^ self new sourceCodeSynchronously: (GtCoderExplicitSourceCode new source: aString)
]

{ #category : #'api - ast' }
GtPharoSnippetCoder >> computeAst: theSourceString [
	^ GtPharoParser
		parseWithErrors: theSourceString
		startingAt: GtPharoParser startingStateForMethodSequence
]

{ #category : #accessing }
GtPharoSnippetCoder >> context [
	^ context
]

{ #category : #accessing }
GtPharoSnippetCoder >> context: doItContext [
	context := doItContext
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

{ #category : #'private - actions' }
GtPharoSnippetCoder >> primitiveEvaluate: aSourceString inContext: aGtPharoCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	self
		xDocSaveSource: self currentSourceString
		receiverObject: aGtPharoCoderEvaluationContext receiverObject.
	
	^ super primitiveEvaluate: aSourceString inContext: aGtPharoCoderEvaluationContext onFailDo: anEvaluationFailBlock
]

{ #category : #'api - actions' }
GtPharoSnippetCoder >> profileWithMessageTally [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		decorated: [ :aSourceString | 'MessageTally on: [ ', aSourceString, ']' ]
		inContext: (GtSourceCoderEvaluationContext new requesterObject: self)
		thenDo: [ :anEvaluationResult | self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #accessing }
GtPharoSnippetCoder >> variableBindings [
	self deprecated: 'Use GtPharoSourceViewModel>>#bindingStrategy instead'
]

{ #category : #accessing }
GtPharoSnippetCoder >> variableBindings: aGtPlaygroundBindings [
	self deprecated: 'Use GtPharoSourceViewModel>>#bindingStrategy: instead'
]

{ #category : #store }
GtPharoSnippetCoder >> xDocFilenameForReceiverObject: anObject [
	"Answer the filename containing the receiver's source.
	If no action has been performed, use the last saved code.
	If an action has been performed gtPlaygroundFilename will have been set."

	^xdocFilename ifNil: 
		[ XdPlaygroundSettings directory isWritable 
			ifTrue: [ (self xDocStoreForReceiverObject: anObject) latestFilename ]
			ifFalse: [ nil ] ]
]

{ #category : #store }
GtPharoSnippetCoder >> xDocLoadSavedContentForReceiverObject: anObject [
	"The receiver's object has been changed under us, reload the default code (if not empty)"

	self currentSourceString
		ifNotEmpty: [ ^ self ].
	self forSource: (self xDocSourceStringForReceiverObject: anObject)
]

{ #category : #store }
GtPharoSnippetCoder >> xDocSaveSource: aString receiverObject: anObject [
	"Save the supplied source code"

	anObject
		ifNil: [ ^ self ].

	xdocFilename ifNil: 
		[ xdocFilename := (self xDocStoreForReceiverObject: anObject) newFile ].

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
GtPharoSnippetCoder >> xDocSourceStringForReceiverObject: anObject [
	"Answer the string to be initially displayed in the snippet"
	| sourceFile xDoc |

	anObject
		ifNil: [ ^ '' ].

	sourceFile := self xDocFilenameForReceiverObject: anObject.
	sourceFile ifNil: [ ^ '' ].

	xDoc := XdReader new 
				streamingStrategy: (XdStreamingStrategy file: sourceFile);
				read.
	^ (xDoc memberNamed: 'playground.source') contents utf8Decoded
]

{ #category : #store }
GtPharoSnippetCoder >> xDocStoreForReceiverObject: anObject [
	"Answer the XDoc store for the receiver."

	^ XdKeyDocumentStore forKey: (self xDocStoreKeyForReceiverObject: anObject)
]

{ #category : #store }
GtPharoSnippetCoder >> xDocStoreKeyForReceiverObject: anObject [
	"Answer the key to be used for storing documents"

	^ anObject class name
]
