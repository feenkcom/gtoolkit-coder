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
		ifNotNil: [ :aCoderLook | anElement addAptitude: aCoderLook ]
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

	^ self coderViewModel: aCoderUIModel
]

{ #category : #accessing }
GtExpandedOnlyCoderElement >> coderViewModel [
	^ coderUIModel
]

{ #category : #accessing }
GtExpandedOnlyCoderElement >> coderViewModel: aCoderViewModel [

	self
		assert: [ aCoderViewModel isNotNil ]
		description: [ 'Coder must not be nil' ].
	coderUIModel == aCoderViewModel ifTrue: [ ^ self ].

	coderUIModel ifNotNil: 
		[ coderUIModel coder announcer unsubscribe: self.
		coderUIModel := aCoderViewModel.
		expandedElement coderViewModel: aCoderViewModel.
		^ self ].

	coderUIModel := aCoderViewModel.
	expandedElement := self newExpandedElement: aCoderViewModel.
	self addChild: expandedElement.
	self addAptitude: (BrLayoutResizerAptitude new inherit: expandedElement).
	aCoderViewModel expanded: true
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
		textualCoderViewModel: aCoderModel;
		in: [ :anElement | self addCodersCoderLook: aCoderModel to: anElement ];
		yourself
]

{ #category : #'focus requesting' }
GtExpandedOnlyCoderElement >> requestFocus [
	self
		childNamed: #editor
		ifFound: [ :anEditorElement | anEditorElement requestFocus ]
		ifNone: [ super requestFocus ] 
]
