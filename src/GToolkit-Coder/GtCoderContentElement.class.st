Class {
	#name : #GtCoderContentElement,
	#superclass : #BlElement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderContentElement >> coder [
	<return: #GtCoder>
	^ coder
]

{ #category : #'initialize-release' }
GtCoderContentElement >> coder: aCoder editorElement: anElement [
	coder := aCoder.
	self addChild: self newHeaderElement as: #header.
	self addChild: anElement as: #editor
]

{ #category : #accessing }
GtCoderContentElement >> gtAllShortcutsFor: aView [
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
GtCoderContentElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent.
			c margin: (BlInsets left: 5) ]
]

{ #category : #'instance creation' }
GtCoderContentElement >> newBreadcrumb [
	<return: #BrBreadcrumb>
	^ BrBreadcrumb new
		look: self newBreadcrumbLook;
		addItems: self newBreadcrumbItemElements;
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
GtCoderContentElement >> newBreadcrumbItemElements [
	<return: #Collection of: #BrButton>
	^ coder breadcrumbNamedActions
		collect: [ :eachNamedAction | 
			BrButton new
				look:
					(BrGlamorousLabelLook new
						foreground: BrGlamorousColors defaultButtonTextColor;
						fontSize: 12);
				label: eachNamedAction key;
				action: eachNamedAction value ]
]

{ #category : #'instance creation' }
GtCoderContentElement >> newBreadcrumbLook [
	^ BrGlamorousBreadcrumbLook new
		separator: [ BrLabel new
			look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
			text: '>';
			margin: (BlInsets left: 5 right: 5) ]
]

{ #category : #'instance creation' }
GtCoderContentElement >> newHeaderElement [
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
