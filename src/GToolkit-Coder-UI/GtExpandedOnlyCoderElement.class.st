Class {
	#name : #GtExpandedOnlyCoderElement,
	#superclass : #BrVerticalPane,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #adding }
GtExpandedOnlyCoderElement >> addCodersCoderLook: aSourceCoder to: anElement [	
	aSourceCoder coderLook
		ifNotNil: [ :aCoderLook | anElement addLook: aCoderLook ].

	(aSourceCoder coders ifNotNil: #coderLook)
		ifNotNil: [ :aCodersLook | anElement addLook: aCodersLook ]
]

{ #category : #converting }
GtExpandedOnlyCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #accessing }
GtExpandedOnlyCoderElement >> coder: aCoder [
	| anExpandedElement |
	self
		assert: [ aCoder isNotNil ]
		description: [ 'Coder must not be nil' ].
	self addChild: (anExpandedElement := self newExpandedElement: aCoder).
	self addLook: (BrLayoutResizerLook new inherit: anExpandedElement).
	aCoder expanded: true.
	aCoder coder announcer weak
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
