Class {
	#name : #GtCoderElement,
	#superclass : #BrExpander,
	#traits : 'TBlDrawingCache',
	#classTraits : 'TBlDrawingCache classTrait',
	#instVars : [
		'coder',
		'collapsedElement',
		'expandedElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #private }
GtCoderElement >> addCodersCoderLookTo: anElement [
	| aLook |
	aLook := anElement look.
	(coder coders ifNotNil: #coderLook)
		ifNotNil: [ :f | aLook := aLook ifNil: [ f ] ifNotNil: [ aLook + f ] ].
	aLook notNil
		ifTrue: [ anElement look: aLook ]
]

{ #category : #converting }
GtCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #accessing }
GtCoderElement >> coder [
	<return: #GtMethodCoder>
	self assert: [ coder isNotNil ] description: [ 'Coder is not set!' ].
	^ coder
]

{ #category : #accessing }
GtCoderElement >> coder: aCoder [
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
GtCoderElement >> gtAllShortcutsFor: aView [
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
GtCoderElement >> initialize [
	super initialize.

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
GtCoderElement >> isExpanded [
	^ expandableModel isExpanded
]

{ #category : #testing }
GtCoderElement >> isVerticallyResizeableElement [
	^ true
]

{ #category : #'instance creation' }
GtCoderElement >> newActionsElement [
	^ GtCoderActionsElement new
		coder: coder;
		padding:
			(BlInsets
				top: 0
				left: -3
				bottom: -3
				right: 0);
		margin: (BlInsets top: 5);
		yourself
]

{ #category : #private }
GtCoderElement >> newCollapsedElement [
	^ GtCoderContentElement new
		coder: coder editorElement: coder collapsedEditorElement;
		in: [ :e | self addCodersCoderLookTo: e ];
		yourself
]

{ #category : #private }
GtCoderElement >> newExpandedElement [
	^ GtCoderContentElement new
		coder: coder editorElement: coder expandedEditorElement;
		addChild: self newActionsElement as: #actions;
		in: [ :e | self addCodersCoderLookTo: e ];
		yourself
]

{ #category : #'focus requesting' }
GtCoderElement >> requestFocus [
	^ self
		childNamed: #editor
		ifFound: [ :element | element requestFocus ]
		ifNone: [ super requestFocus ]
]

{ #category : #events }
GtCoderElement >> updateExpanded [
	coder expanded
		ifTrue: [ self isExpanded
				ifFalse: [ self expand ] ]
		ifFalse: [ self isExpanded
				ifTrue: [ self collapse ] ]
]
