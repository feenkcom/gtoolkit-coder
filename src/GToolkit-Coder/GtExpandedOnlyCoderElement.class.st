Class {
	#name : #GtExpandedOnlyCoderElement,
	#superclass : #BrVerticalPane,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #adding }
GtExpandedOnlyCoderElement >> addCodersLookTo: anElement coder: aCoderModel [ 
	| aLook |
	aLook := anElement look.
	(aCoderModel coderLook ifNil: [ aCoderModel coders ifNotNil: #coderLook ])
		ifNotNil: [ :f | aLook := aLook ifNil: [ f ] ifNotNil: [ aLook + f ] ].
	aLook notNil
		ifTrue: [ anElement look: aLook ]
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
	self addChild: (self newActionsElement: aCoder) as: #actions.
	
	self addLook: (BrLayoutResizerLook new inheritIn: [ :aBlock | aBlock value: anExpandedElement ]).

	aCoder stylerView: self.
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
GtExpandedOnlyCoderElement >> newActionsElement: aCoderModel [
	^ GtCoderActionsElement new
		coder: aCoderModel;
		margin: (BlInsets top: 5);
		yourself
]

{ #category : #'instance creation' }
GtExpandedOnlyCoderElement >> newExpandedElement: aCoderModel [
	^ GtCoderContentElement new
		coder: aCoderModel editorElement: aCoderModel expandedEditorElement;
		in: [ :anElement | self addCodersLookTo: anElement coder: aCoderModel ];
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
