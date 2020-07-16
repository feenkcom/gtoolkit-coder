Class {
	#name : #GtExpandableCoderElement,
	#superclass : #BrExpander,
	#instVars : [
		'coder',
		'collapsedElement',
		'expandedElement'
	],
	#category : #'GToolkit-Coder-UI'
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
	aCollapsedElement coder: aSourceCoder.

	"Initialize look just once"
	aCollapsedElement look ifNil: [
		self addCodersCoderLook: aSourceCoder to: aCollapsedElement.
		aCollapsedElement addLook: GtSourceCoderCollapsedWithoutHeaderLook ].
]

{ #category : #private }
GtExpandableCoderElement >> assignExpandedCoder: aSourceCoder to: anExpandedElement [
	anExpandedElement coder: aSourceCoder.

	"Initialize look just once"
	anExpandedElement look ifNil: [
		self addCodersCoderLook: aSourceCoder to: anExpandedElement.
		anExpandedElement addLook: GtSourceCoderExpandedWithoutHeaderLook ]
]

{ #category : #accessing }
GtExpandableCoderElement >> coder [
	<return: #GtMethodCoder>
	self
		assert: [ coder isNotNil ]
		description: [ 'Coder is not set!' ].
	
	^ coder
]

{ #category : #accessing }
GtExpandableCoderElement >> coder: aCoder [
	self
		assert: [ aCoder isNotNil ]
		description: [ 'Coder must not be nil' ].
		
	coder ifNotNil: [ :aPreviousCoder |
		aPreviousCoder announcer unsubscribe: self ].

	coder := aCoder.

	coder expanded
		ifTrue: [ expandedElement ifNotNil: [ :anElement | self assignExpandedCoder: aCoder to: anElement ] ]
		ifFalse: [ collapsedElement ifNotNil: [ :anElement | self assignCollapsedCoder: aCoder to: anElement ] ].

	self expanded: coder expanded.

	coder announcer weak
		when: GtCoderExpandedChanged send: #updateExpanded to: self;
		when: GtCoderRequestFocus send: #requestFocus to: self
]

{ #category : #accessing }
GtExpandableCoderElement >> gtAllShortcutsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'All shortcuts' translated;
		priority: 10;
		items: [ self shortcuts , coder addOns shortcuts ];
		column: 'Key'
			do: [ :aColumn | 
			aColumn
				item: [ :each | each combination gtDisplayString ];
				weight: 1 ];
		column: 'Action'
			do: [ :aColumn | 
			aColumn
				item: [ :each | each action asString ];
				weight: 1 ]
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
		when: BrExpansionChanged
		do: [ :anEvent |
			anEvent isExpanded
				ifTrue: [ self beInSeparateCompositionLayer ]
				ifFalse: [ self beInSingleCompositionLayer ].
			coder ifNotNil: [ :aCoder | aCoder expanded: anEvent isExpanded ] ].

	self
		header: [ collapsedElement := self newCollapsedElement ];
		content: [ expandedElement := self newExpandedElement ]
]

{ #category : #private }
GtExpandableCoderElement >> newCollapsedElement [
	| aCollapsedElement |
	aCollapsedElement := GtSourceCoderCollapsedContentElement new.

	coder
		ifNotNil: [ :aCoder | self assignCollapsedCoder: aCoder to: aCollapsedElement ].

	^ aCollapsedElement
]

{ #category : #private }
GtExpandableCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := GtSourceCoderExpandedContentElement new.

	coder
		ifNotNil: [ :aCoder | self assignExpandedCoder: aCoder to: anExpandedElement ].

	^ anExpandedElement
]

{ #category : #'focus requesting' }
GtExpandableCoderElement >> requestFocus [
	^ self
		enqueueTask:
			(BlTaskAction new
				action: [ self
						childNamed: #editor
						ifFound: [ :anEditorElement | anEditorElement requestFocus ]
						ifNone: [ super requestFocus ] ])
]

{ #category : #events }
GtExpandableCoderElement >> updateExpanded [
	"Is sent when the coder model was requested to expand/collapse"

	self expanded: coder expanded
]
