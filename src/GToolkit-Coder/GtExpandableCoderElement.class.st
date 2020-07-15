Class {
	#name : #GtExpandableCoderElement,
	#superclass : #BrExpander,
	#instVars : [
		'coder',
		'collapsedElement',
		'expandedElement',
		'removed'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #private }
GtExpandableCoderElement >> addCodersCoderLookTo: anElement [
	| aLook |

	aLook := anElement look.

	(coder coderLook ifNil: [ coder coders ifNotNil: #coderLook ])
		ifNotNil: [ :f | aLook := aLook ifNil: [ f ] ifNotNil: [ aLook + f ] ].

	aLook notNil
		ifTrue: [ anElement look: aLook ]
]

{ #category : #converting }
GtExpandableCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
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
	self
		header: [ collapsedElement := self newCollapsedElement ];
		content: [ expandedElement := self newExpandedElement ].

	collapsedElement ifNotNil: [ collapsedElement coder: coder ].
	expandedElement ifNotNil: [ expandedElement coder: coder ].

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
	removed := false.
	
	self
		vFitContent;
		hMatchParent;
		margin: (BlInsets all: 4);
		look:
			GtCoderExpanderLook new + (BrInteractiveCommonLook new
				default: [ self background: Color transparent ];
				expanded: [ self background: Color white ]);
		addShortcut:
			(BlShortcut new
				combination: BlKeyCombination primaryReturn;
				action: [ self toggle ]).
	self
		when: BrExpansionChanged
		do: [ :event | coder ifNotNil: [ :e | e expanded: self isExpanded ] ]
]

{ #category : #private }
GtExpandableCoderElement >> newCollapsedElement [
	^ GtCoderCollapsedContentElement new
		coder: coder;
		in: [ :e | self addCodersCoderLookTo: e ];
		yourself
]

{ #category : #private }
GtExpandableCoderElement >> newExpandedElement [
	^ GtCoderExpandedContentElement new
		coder: coder;
		in: [ :e | self addCodersCoderLookTo: e ];
		yourself
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

{ #category : #events }
GtExpandableCoderElement >> updateSource: aGtCoderMethodChanged [
]
