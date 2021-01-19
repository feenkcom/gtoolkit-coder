Class {
	#name : #GtExpandableSourceCoderElement,
	#superclass : #BrExpander,
	#instVars : [
		'collapsedElement',
		'expandedElement',
		'coderUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #private }
GtExpandableSourceCoderElement >> addCodersCoderLook: aSourceCoder to: anElement [	
	aSourceCoder coderLook
		ifNotNil: [ :aCoderLook | anElement addLook: aCoderLook ]
]

{ #category : #converting }
GtExpandableSourceCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #private }
GtExpandableSourceCoderElement >> assignCollapsedCoder: aSourceCoder to: aCollapsedElement [
	aCollapsedElement coderUIModel: aSourceCoder.

	"Initialize look just once"
	aCollapsedElement look
		ifNil: [ self addCodersCoderLook: aSourceCoder to: aCollapsedElement.
			aCollapsedElement addLook: GtSourceCoderCollapsedWithoutHeaderLook ]
]

{ #category : #private }
GtExpandableSourceCoderElement >> assignExpandedCoder: aSourceCoder to: anExpandedElement [
	anExpandedElement coderUIModel: aSourceCoder.

	"Initialize look just once"
	anExpandedElement look
		ifNil: [
			self addCodersCoderLook: aSourceCoder to: anExpandedElement.
			anExpandedElement addLook: GtSourceCoderExpandedWithoutHeaderLook ]
]

{ #category : #accessing }
GtExpandableSourceCoderElement >> coderUIModel [
	<return: #GtMethodCoder>
	self
		assert: [ coderUIModel isNotNil ]
		description: [ 'Coder is not set!' ].
	
	^ coderUIModel
]

{ #category : #accessing }
GtExpandableSourceCoderElement >> coderUIModel: aCoderUIModel [
	self
		assert: [ aCoderUIModel isNotNil ]
		description: [ 'Coder must not be nil' ].

	coderUIModel == aCoderUIModel
		ifTrue: [ ^ self ].

	coderUIModel
		ifNotNil: [ :aPreviousCoder | aPreviousCoder coder announcer unsubscribe: self ].

	coderUIModel := aCoderUIModel.

	coderUIModel expanded
		ifTrue: [ expandedElement
				ifNotNil: [ :anElement | self assignExpandedCoder: aCoderUIModel to: anElement ].
			collapsedElement
				ifNotNil: [ :anElement | self markDirty: anElement as: true ] ]
		ifFalse: [ collapsedElement
				ifNotNil:
					[ :anElement | self assignCollapsedCoder: aCoderUIModel to: anElement ].
			expandedElement
				ifNotNil: [ :anElement | self markDirty: anElement as: true ] ].

	coderUIModel focused
		ifFalse: [ self loseFocus ].

	self expanded: coderUIModel expanded.

	coderUIModel coder subscribeToSystem.
	coderUIModel coder announcer weak
		when: GtCoderRequestFocus send: #requestFocusAsyncronously to: self;
		when: GtCoderMethodRemoved send: #onMethodRemoved: to: self
]

{ #category : #accessing }
GtExpandableSourceCoderElement >> gtAllShortcutsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'All shortcuts' translated;
		priority: 10;
		items: [ self shortcuts , coderUIModel addOns shortcuts ];
		column: 'Key' item: [ :each | each combination gtDisplayString ];
		column: 'Action' item: [ :each | each action asString ]
]

{ #category : #initialization }
GtExpandableSourceCoderElement >> initialize [
	super initialize.

	self
		vFitContent;
		hMatchParent;
		margin: (BlInsets all: 4);
		look: GtCoderExpanderLook;
		beInSingleCompositionLayer.

	self states withExpansion.

	self when: BrExpandedEvent do: [ self onExpanded ].
	self when: BrCollapsedEvent do: [ self onCollapsed ].

	self
		header: [ collapsedElement := self newCollapsedElement ];
		content: [ expandedElement := self newExpandedElement ]
]

{ #category : #private }
GtExpandableSourceCoderElement >> isDirty: anElement [
	^ anElement userData
		at: #coderDirty
		ifAbsent: [ false ]
]

{ #category : #private }
GtExpandableSourceCoderElement >> markDirty: anElement as: aBoolean [
	anElement userData at: #coderDirty put: aBoolean
]

{ #category : #private }
GtExpandableSourceCoderElement >> newCollapsedElement [
	| aCollapsedElement |
	aCollapsedElement := GtSourceCoderCollapsedContentElement new.

	coderUIModel
		ifNotNil: [ :aCoder | self assignCollapsedCoder: aCoder to: aCollapsedElement ].

	^ aCollapsedElement
]

{ #category : #private }
GtExpandableSourceCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := GtSourceCoderExpandedContentElement new.

	coderUIModel
		ifNotNil: [ :aCoder | self assignExpandedCoder: aCoder to: anExpandedElement ].

	^ anExpandedElement
]

{ #category : #private }
GtExpandableSourceCoderElement >> onCollapsed [
	self beInSingleCompositionLayer.
	
	coderUIModel ifNotNil: [ :aCoderUIModel |
		aCoderUIModel expanded: false.
		(collapsedElement notNil and: [ self isDirty: collapsedElement ])
			ifTrue: [ self assignCollapsedCoder: aCoderUIModel to: collapsedElement ] ]
]

{ #category : #private }
GtExpandableSourceCoderElement >> onExpanded [
	self beInSeparateCompositionLayer.

	coderUIModel ifNotNil: [ :aCoderUIModel |			
		aCoderUIModel expanded: true.
		(expandedElement notNil and: [ self isDirty: expandedElement ])
			ifTrue: [ self assignExpandedCoder: aCoderUIModel to: expandedElement ] ]
]

{ #category : #events }
GtExpandableSourceCoderElement >> onMethodRemoved: anAnnouncement [
]

{ #category : #'focus requesting' }
GtExpandableSourceCoderElement >> requestFocus [
	self
		childNamed: #editor
		ifFound: [ :anEditorElement | anEditorElement requestFocus ]
		ifNone: [ super requestFocus ] 
]

{ #category : #'focus requesting' }
GtExpandableSourceCoderElement >> requestFocusAsyncronously [
	^ self
		enqueueTask:
			(BlTaskAction new
				action: [ self requestFocus ])
]

{ #category : #accessing }
GtExpandableSourceCoderElement >> saveCoderUIModel: aCoderUIModel [
	self
		assert: [ aCoderUIModel isNotNil ]
		description: [ 'Coder must not be nil' ].
	
	expandedElement ifNotNil: [ :anExpandedElement | anExpandedElement saveCoderUIModel: aCoderUIModel ]
]
