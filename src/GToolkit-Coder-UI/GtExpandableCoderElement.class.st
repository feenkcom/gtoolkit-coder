Class {
	#name : #GtExpandableCoderElement,
	#superclass : #BrExpander,
	#instVars : [
		'collapsedElement',
		'expandedElement',
		'coderUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #private }
GtExpandableCoderElement >> addCodersCoderLook: aSourceCoder to: anElement [	
	aSourceCoder coderLook
		ifNotNil: [ :aCoderLook | anElement addLook: aCoderLook ].

	(aSourceCoder coders ifNotNil: #coderLook)
		ifNotNil: [ :aCodersLook | anElement addLook: aCodersLook ]
]

{ #category : #converting }
GtExpandableCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #private }
GtExpandableCoderElement >> assignCollapsedCoder: aSourceCoder to: aCollapsedElement [
	aCollapsedElement coderUIModel: aSourceCoder.

	"Initialize look just once"
	aCollapsedElement look
		ifNil: [ self addCodersCoderLook: aSourceCoder to: aCollapsedElement.
			aCollapsedElement addLook: GtSourceCoderCollapsedWithoutHeaderLook ]
]

{ #category : #private }
GtExpandableCoderElement >> assignExpandedCoder: aSourceCoder to: anExpandedElement [
	anExpandedElement coderUIModel: aSourceCoder.

	"Initialize look just once"
	anExpandedElement look
		ifNil: [ self addCodersCoderLook: aSourceCoder to: anExpandedElement.
			anExpandedElement addLook: GtSourceCoderExpandedWithoutHeaderLook ]
]

{ #category : #accessing }
GtExpandableCoderElement >> coder [
	<return: #GtMethodCoder>
	
	self 
		deprecated: 'Use #coderUIModel instead.'
		transformWith: '`@receiver coder' -> '`@receiver coderUIModel'.
		
	^ self coderUIModel
]

{ #category : #accessing }
GtExpandableCoderElement >> coder: aCoderUIModel [
	self 
		deprecated: 'Use #coderUIModel: instead.'
		transformWith: '`@receiver coder: `@arg' -> '`@receiver coderUIModel: `@arg'.
		
	self coderUIModel: aCoderUIModel
]

{ #category : #accessing }
GtExpandableCoderElement >> coderUIModel [
	<return: #GtMethodCoder>
	self
		assert: [ coderUIModel isNotNil ]
		description: [ 'Coder is not set!' ].
	
	^ coderUIModel
]

{ #category : #accessing }
GtExpandableCoderElement >> coderUIModel: aCoderUIModel [
	self
		assert: [ aCoderUIModel isNotNil ]
		description: [ 'Coder must not be nil' ].
	coderUIModel
		ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
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
	coderUIModel announcer weak
		when: GtCoderExpandedChanged send: #updateExpanded to: self;
		when: GtCoderRequestFocus send: #requestFocusAsyncronously to: self
]

{ #category : #accessing }
GtExpandableCoderElement >> gtAllShortcutsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'All shortcuts' translated;
		priority: 10;
		items: [ self shortcuts , coderUIModel addOns shortcuts ];
		column: 'Key' item: [ :each | each combination gtDisplayString ]
		column: 'Action' item: [ :each | each action asString ]
]

{ #category : #initialization }
GtExpandableCoderElement >> initialize [
	super initialize.

	self
		vFitContent;
		hMatchParent;
		margin: (BlInsets all: 4);
		look: GtCoderExpanderLook;
		beInSingleCompositionLayer.

	self
		when: BrExpandedEvent
		do: [
			self beInSeparateCompositionLayer.
			coderUIModel ifNotNil: [ :aCoderUIModel |			
				aCoderUIModel expanded: true.
				(expandedElement notNil and: [ self isDirty: expandedElement ])
					ifTrue: [ self assignExpandedCoder: aCoderUIModel to: expandedElement ] ] ].

	self
		when: BrCollapsedEvent
		do: [  :anEvent |
			self beInSingleCompositionLayer.
			coderUIModel ifNotNil: [ :aCoderUIModel |
				aCoderUIModel expanded: false.
				(collapsedElement notNil and: [ self isDirty: collapsedElement ])
					ifTrue: [ self assignCollapsedCoder: aCoderUIModel to: collapsedElement ] ] ].

	self
		header: [ collapsedElement := self newCollapsedElement ];
		content: [ expandedElement := self newExpandedElement ]
]

{ #category : #private }
GtExpandableCoderElement >> isDirty: anElement [
	^ anElement userData
		at: #coderDirty
		ifAbsent: [ false ]
]

{ #category : #private }
GtExpandableCoderElement >> markDirty: anElement as: aBoolean [
	anElement userData at: #coderDirty put: aBoolean
]

{ #category : #private }
GtExpandableCoderElement >> newCollapsedElement [
	| aCollapsedElement |
	aCollapsedElement := GtSourceCoderCollapsedContentElement new.

	coderUIModel
		ifNotNil: [ :aCoder | self assignCollapsedCoder: aCoder to: aCollapsedElement ].

	^ aCollapsedElement
]

{ #category : #private }
GtExpandableCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := GtSourceCoderExpandedContentElement new.

	coderUIModel
		ifNotNil: [ :aCoder | self assignExpandedCoder: aCoder to: anExpandedElement ].

	^ anExpandedElement
]

{ #category : #'focus requesting' }
GtExpandableCoderElement >> requestFocus [
	self
		childNamed: #editor
		ifFound: [ :anEditorElement | anEditorElement requestFocus ]
		ifNone: [ super requestFocus ] 
]

{ #category : #'focus requesting' }
GtExpandableCoderElement >> requestFocusAsyncronously [
	^ self
		enqueueTask:
			(BlTaskAction new
				action: [ self requestFocus ])
]

{ #category : #accessing }
GtExpandableCoderElement >> saveCoderUIModel: aCoderUIModel [
	self
		assert: [ aCoderUIModel isNotNil ]
		description: [ 'Coder must not be nil' ].
	
	expandedElement ifNotNil: [ :anExpandedElement | anExpandedElement saveCoderUIModel: aCoderUIModel ]
]

{ #category : #events }
GtExpandableCoderElement >> updateExpanded [
	"Is sent when the coder model was requested to expand/collapse"

	self expanded: coderUIModel expanded
]
