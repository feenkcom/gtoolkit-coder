Class {
	#name : #GtPharoSnippetCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'bindingStrategy',
		'completionStrategy'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #private }
GtPharoSnippetCoder >> completionStrategy [
	^ completionStrategy
		ifNil: [ completionStrategy := GtPharoCompletionStrategy new isMethod: false.
			completionStrategy bindings: bindingStrategy bindings.
			completionStrategy ]
]

{ #category : #actions }
GtPharoSnippetCoder >> evaluateAndHighlightAllSource [
	self clearPreviousEvaluations.
	self validateSyntax
		ifFalse: [ ^ self ].
	^ self evaluateSource: self sourceEditor text asString
]

{ #category : #actions }
GtPharoSnippetCoder >> evaluationRequester [
	^ super evaluationRequester
		bindingStrategy: (GtPlaygroundBindingStrategy new bindings: bindingStrategy bindings);
		yourself
]

{ #category : #initialization }
GtPharoSnippetCoder >> initialize [
	super initialize.
	expanded := true.
	bindingStrategy := GtHighlightingBindingStrategy new.
	bindingStrategy bindings: Dictionary new.
	self source: ''
]

{ #category : #initialization }
GtPharoSnippetCoder >> initializeAddOns [
	super initializeAddOns.
	addOns addMainAction: 'Evaluate' translated icon: BrGlamorousIcons play action: [ :aButton | self evaluateAndHighlightAllSource ].
	addOns addMainAction: 'Inspect' translated icon: BrGlamorousIcons playinspect action: [ :aButton | self runFrom: aButton ].
	addOns clearChanges
]

{ #category : #'initialize-release' }
GtPharoSnippetCoder >> initializeShortcuts [
	super initializeShortcuts.
	addOns
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						d;
						build);
				action: [ self doItSelection ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						g;
						build);
				action: [ :editorElement | self doItAndGoSelection: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						p;
						build);
				action: [ self printItSelection ])
]

{ #category : #ui }
GtPharoSnippetCoder >> newSourceStyler [
	| styler |
	styler := BrRBTextStyler new.
	styler workspace: bindingStrategy.
	^ styler
]

{ #category : #accessing }
GtPharoSnippetCoder >> object [
	^ bindingStrategy bindings receiver
]

{ #category : #ui }
GtPharoSnippetCoder >> requester [
	^ super requester
		bindingStrategy: (GtPlaygroundBindingStrategy new bindings: bindingStrategy bindings);
		yourself
]

{ #category : #actions }
GtPharoSnippetCoder >> runFrom: aButton [
	| aValue |
	self clearPreviousEvaluations.
	self validateSyntax
		ifFalse: [ ^ self ].
	aValue := self evaluateAndHighlightAllSource.
	aButton
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: aValue;
				sourceElement: aButton)
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
