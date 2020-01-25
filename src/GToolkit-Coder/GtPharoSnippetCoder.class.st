Class {
	#name : #GtPharoSnippetCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'bindingStrategy',
		'context'
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
		icon: BrGlamorousIcons play
		action: [ :aButton | self doItSelectionOrAll ].
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousIcons playinspect
		action: [ :aButton | self doItAndGoSelectionOrAll: aButton ].
	addOns
		addMainAction: 'Debug' translated
		icon: BrGlamorousIcons debug
		action: [ :aButton | self debugSelection ].
	addOns
		addMainAction: 'Profile' translated
		icon: BrGlamorousIcons performance
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
			action: [ :editorElement | self doItAndGoSelectionOrAll: editorElement ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryP;
			action: [ self printItSelectionOrAll ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryR;
			action: [ :editorElement | self renameVariableIn: editorElement ])
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
