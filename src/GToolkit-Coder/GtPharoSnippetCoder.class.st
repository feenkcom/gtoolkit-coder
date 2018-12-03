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

{ #category : #initialization }
GtPharoSnippetCoder >> evaluateSource: aString [
	| value |
	value := self class compiler
		requestor: self requester;
		source: aString;
		receiver: nil;
		context: nil;
		failBlock: [ ^ self flag: 'insert error adornment' ];
		evaluate.
	^ value
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
	addOns addMainAction: 'Run' translated icon: BrGlamorousIcons play action: [ :aButton | self runFrom: aButton ].
	addOns clearChanges
]

{ #category : #ui }
GtPharoSnippetCoder >> newSourceStyler [
	| styler |
	styler := BrRBTextStyler new.
	styler workspace: bindingStrategy.
	^ styler
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
	aValue := self evaluateSource: self sourceEditor text asString.
	self sourceEditor
		styleTextAndAfterDo: [ self sourceEditor text
				attributes:
					{(GtPlaygroundEvaluatedCodeButtonAttribute new
						result: aValue;
						paint: (Color fromHexString: #'90CAF9')).
					(GtPlaygroundEvaluatedCodeHighlightedAttribute new paint: (Color fromHexString: #'90CAF9'))} ].
	aButton
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: aValue;
				sourceElement: aButton)
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
