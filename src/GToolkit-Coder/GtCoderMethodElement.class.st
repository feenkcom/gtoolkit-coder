Class {
	#name : #GtCoderMethodElement,
	#superclass : #BrExpander,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #converting }
GtCoderMethodElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #accessing }
GtCoderMethodElement >> collapsedElement [
	| element |
	element := GtCoderMethodPatternElement new.
	element methodCoder: self methodCoder.
	element margin: (BlInsets left: 5).
	element
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ].
	methodCoder methodsCoder ifNotNil: [ :coder | coder methodCoderLook ifNotNil: [ :look | element look: look ] ].
	^ element
]

{ #category : #accessing }
GtCoderMethodElement >> contentElement [
	| element look |
	element := GtCoderMethodBodyElement new.
	element methodCoder: self methodCoder.
	element margin: (BlInsets left: 5).
	element
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ].
	look := methodCoder coderLook.
	methodCoder methodsCoder
		ifNotNil: [ :coder | 
			coder methodCoderLook
				ifNotNil: [ :methodsLook | 
					look := look notNil
						ifTrue: [ look + methodsLook ]
						ifFalse: [ methodsLook ] ] ].
	look notNil
		ifTrue: [ element look: look ].
	^ element
]

{ #category : #accessing }
GtCoderMethodElement >> gtAllShortcutsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].
	^ aView columnedList 
		title: 'All shortcuts' translated;
		priority: 10;
		items: [ self shortcuts, self methodCoder addOns shortcuts ];
		column: 'Key' do: [:aColumn | 
			aColumn item: [ :each | each combination gtDisplayString ]; matchParent ];
		column: 'Action' do: [:aColumn |
			aColumn item: [ :each | each action asString ]; matchParent ]
]

{ #category : #initialization }
GtCoderMethodElement >> initialize [
	| resizer |
	super initialize.
	self
		vFitContent;
		hMatchParent.
	resizer := BrResizer new
		beBottom;
		look: BrGlamorousResizerLook new;
		constraintsDo: [ :c | c ignoreByLayout ];
		when: BlDoubleClickEvent do: [ self 
			childNamed: #bodyEditor 
			ifFound: [ :anEditor | anEditor 
				constraintsDo: [ :c | c vertical fitContent ] ] 
			ifNone: [  ] ];
		yourself.
	self
		look:
			(GtCoderExpanderLook new
				borderWidth: 0;
				padding:
					(BlInsets
						top: 1
						left: 10
						bottom: 1
						right: 10))
				+
					(BrInteractiveLook new
						style: [ :aStyler | 
							aStyler
								default: [ resizer removeFromParent.
									self background: Color transparent ].
							aStyler
								expanded: [ self addChild: resizer.
									self enqueueTask: (BlTaskAction new action: [ self 
										childNamed: #bodyEditor 
										ifFound: [ :anEditor | resizer target: anEditor ] 
										ifNone: [ resizer target: nil ] ]).
									self background: Color white ] ]).
	self
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						return;
						build);
				action: [ self toggle ])
]

{ #category : #testing }
GtCoderMethodElement >> isExpanded [
	^ expandableModel isExpanded
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoder: aGtMethodCoder [
	methodCoder := aGtMethodCoder.
	self header: [ self collapsedElement ].
	self content: [ self contentElement ].
	self margin: (BlInsets all: 4).
	expandableModel when: BrExpansionChanged do: [ :event | methodCoder expanded: self isExpanded ].
	methodCoder expanded
		ifTrue: [ self expand ]
]

{ #category : #private }
GtCoderMethodElement >> updateExpanded [
	self methodCoder expanded: expandableModel isExpanded
]
