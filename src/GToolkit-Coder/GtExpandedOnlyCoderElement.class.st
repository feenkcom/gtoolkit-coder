Class {
	#name : #GtExpandedOnlyCoderElement,
	#superclass : #BrVerticalPane,
	#category : #'GToolkit-Coder-UI'
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
	self addLook: (BrLayoutResizerLook new inheritIn: [ :aBlock | aBlock value: anExpandedElement ]).

	aCoder expanded: true.
	aCoder announcer weak
		when: GtCoderRequestFocus send: #requestFocus to: self
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
		coder: aCoderModel;
		in: [ :anElement | self addCodersCoderLook: aCoderModel to: anElement ];
		addLook: GtSourceCoderExpandedWithHeaderLook;
		yourself
]

{ #category : #'focus requesting' }
GtExpandedOnlyCoderElement >> requestFocus [
	^ self
		enqueueTask:
			(BlTaskAction new
				action: [ self
						childNamed: #editor
						ifFound: [ :anEditorElement | anEditorElement requestFocus ]
						ifNone: [ super requestFocus ] ])
]
