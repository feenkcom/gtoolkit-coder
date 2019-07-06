Class {
	#name : #GtCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderElement >> coder [
	<return: #GtCoder>
	^ coder
]

{ #category : #'initialize-release' }
GtCoderElement >> coder: aCoder editorElement: anElement [
	coder := aCoder.
	self addChild: self newHeaderElement as: #header.
	self addChild: anElement as: #editor
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

{ #category : #'initialize-release' }
GtCoderElement >> initialize [
	super initialize.
	self layout: BlLinearLayout vertical
]

{ #category : #'instance creation' }
GtCoderElement >> newBreadcrumb [
	<return: #BrBreadcrumb>
	^ BrBreadcrumb new
		look: self newBreadcrumbLook;
		addItems: coder breadcrumbItemElements;
		vFitContent;
		hFitContent;
		background: Color transparent;
		constraintsDo: [ :c | 
			c margin: (BlInsets top: 2).
			c frame horizontal alignLeft.
			c frame vertical alignCenter ];
		yourself
]

{ #category : #'instance creation' }
GtCoderElement >> newBreadcrumbLook [
	^ BrGlamorousBreadcrumbLook new
		separator: [ BrLabel new
			look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
			text: '>';
			margin: (BlInsets left: 5 right: 5) ]
]

{ #category : #'instance creation' }
GtCoderElement >> newHeaderElement [
	^ BlElement new
		clipChildren: false;
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c padding: BlInsets empty.
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: self newBreadcrumb as: #breadcrumb;
		yourself
]
