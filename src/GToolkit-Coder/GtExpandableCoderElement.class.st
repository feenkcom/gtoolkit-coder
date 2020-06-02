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
	self assert: [ coder isNotNil ] description: [ 'Coder is not set!' ].
	^ coder
]

{ #category : #accessing }
GtExpandableCoderElement >> coder: aCoder [
	self
		assert: [ aCoder isNotNil ]
		description: [ 'Coder must not be nil' ].

	coder := aCoder.
	self
		header: [ collapsedElement := self newCollapsedElement ];
		content: [ expandedElement := self newExpandedElement ].

	coder stylerView: self.
	coder expanded
		ifTrue: [ self expand ].
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
				matchParent ];
		column: 'Action'
			do: [ :aColumn | 
			aColumn
				item: [ :each | each action asString ];
				matchParent ]
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

{ #category : #testing }
GtExpandableCoderElement >> isExpanded [
	^ expandableModel isExpanded
]

{ #category : #testing }
GtExpandableCoderElement >> isVerticallyResizeableElement [
	^ true
]

{ #category : #'instance creation' }
GtExpandableCoderElement >> newActionsElement [
	^ GtCoderActionsElement new
		coder: coder;
		margin: (BlInsets top: 5);
		yourself
]

{ #category : #private }
GtExpandableCoderElement >> newCollapsedElement [
	^ GtCoderContentElement new
		coder: coder labelElement: coder collapsedLabelElement;
		in: [ :e | self addCodersCoderLookTo: e ];
		yourself
]

{ #category : #private }
GtExpandableCoderElement >> newExpandedElement [
	^ GtCoderContentElement new
		coder: coder editorElement: coder expandedEditorElement;
		addChild: self newActionsElement as: #actions;
		in: [ :e | self addCodersCoderLookTo: e ];
		yourself
]

{ #category : #events }
GtExpandableCoderElement >> onAddedToSceneGraph [
	removed := false.
	^ super onAddedToSceneGraph
]

{ #category : #events }
GtExpandableCoderElement >> onRemovedFromSceneGraph [
	removed := true.
	^ super onRemovedFromSceneGraph
]

{ #category : #'focus requesting' }
GtExpandableCoderElement >> requestFocus [
	^ self
		childNamed: #editor
		ifFound: [ :element | element requestFocus ]
		ifNone: [ super requestFocus ]
]

{ #category : #events }
GtExpandableCoderElement >> updateExpanded [
	removed ifTrue: [ ^self ].
	coder expanded
		ifTrue: [ self isExpanded
				ifFalse: [ self expand ] ]
		ifFalse: [ self isExpanded
				ifTrue: [ self collapse ] ]
]
