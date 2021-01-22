Class {
	#name : #GtExpandedOnlyCoderElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'coderUIModel',
		'expandedElement'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #adding }
GtExpandedOnlyCoderElement >> addCodersCoderLook: aSourceCoder to: anElement [	
	aSourceCoder coderLook
		ifNotNil: [ :aCoderLook | anElement addLook: aCoderLook ]
]

{ #category : #converting }
GtExpandedOnlyCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #accessing }
GtExpandedOnlyCoderElement >> coder: aCoderUIModel [

	self 
		deprecated: 'Use #coderUIModel: instead.'
		transformWith: '`@receiver coder: `@arg' -> '`@receiver coderUIModel: `@arg'.

	^ self coderUIModel: aCoderUIModel
]

{ #category : #accessing }
GtExpandedOnlyCoderElement >> coderUIModel [
	^ coderUIModel
]

{ #category : #accessing }
GtExpandedOnlyCoderElement >> coderUIModel: aCoderUIModel [

	self
		assert: [ aCoderUIModel isNotNil ]
		description: [ 'Coder must not be nil' ].
	coderUIModel == aCoderUIModel ifTrue: [ ^ self ].

	coderUIModel ifNotNil: 
		[ coderUIModel coder announcer unsubscribe: self.
		coderUIModel := aCoderUIModel.
		expandedElement coderUIModel: aCoderUIModel.
		^ self ].

	coderUIModel := aCoderUIModel.
	expandedElement := self newExpandedElement: aCoderUIModel.
	self addChild: expandedElement.
	self addLook: (BrLayoutResizerLook new inherit: expandedElement).
	aCoderUIModel expanded: true.
	aCoderUIModel coder announcer weak
		when: GtCoderRequestFocus
		send: #requestFocusAsyncronously
		to: self
]

{ #category : #initialization }
GtExpandedOnlyCoderElement >> initialize [
	super initialize.
	
	self
		hMatchParent;
		vFitContent;
		margin: (BlInsets all: 10)
]

{ #category : #'instance creation' }
GtExpandedOnlyCoderElement >> newExpandedElement: aCoderModel [
	^ GtSourceCoderExpandedContentElement new
		coderUIModel: aCoderModel;
		in: [ :anElement | self addCodersCoderLook: aCoderModel to: anElement ];
		addLook: GtSourceCoderExpandedWithoutHeaderLook;
		yourself
]

{ #category : #'focus requesting' }
GtExpandedOnlyCoderElement >> requestFocus [
	self
		childNamed: #editor
		ifFound: [ :anEditorElement | anEditorElement requestFocus ]
		ifNone: [ super requestFocus ] 
]

{ #category : #'focus requesting' }
GtExpandedOnlyCoderElement >> requestFocusAsyncronously [
	^ self 
		enqueueTask:
			(BlTaskAction new
				action: [ self requestFocus ])
]

{ #category : #accessing }
GtExpandedOnlyCoderElement >> saveCoderUIModel: aCoderUIModel [
	self
		assert: [ aCoderUIModel isNotNil ]
		description: [ 'Coder must not be nil' ].

	expandedElement ifNotNil: [ :anExpandedElement | anExpandedElement saveCoderUIModel: aCoderUIModel ]
]
