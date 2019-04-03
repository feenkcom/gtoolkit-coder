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
	bindingStrategy bindings: Dictionary new.
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
		action: [ :aButton | self doItSelection ].
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousIcons playinspect
		action: [ :aButton | self doItAndGoSelection: aButton ].
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
			action: [ self doItSelection ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryG;
			action: [ :editorElement | self doItAndGoSelection: editorElement ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryP;
			action: [ self printItSelection ])
]

{ #category : #private }
GtPharoSnippetCoder >> newCompletionStrategy [
	| strategy |
	strategy := super newCompletionStrategy
		isMethod: false;
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
			forSyntaxHighlighting: true; 
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

{ #category : #ui }
GtPharoSnippetCoder >> requester [
	^ super requester
		bindingStrategy: bindingStrategy;
		yourself
]

{ #category : #private }
GtPharoSnippetCoder >> selectedSourceInterval [
	^ super selectedSourceInterval ifNil: [ 1 to: self source size ]
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
