Class {
	#name : #GtCoderContentElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'coder',
		'breadcrumb',
		'header'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderContentElement >> coder [
	<return: #GtCoderModel>

	^ coder
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

{ #category : #initialization }
GtCoderContentElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		margin: (BlInsets left: 5).

	self viewModel: (BrInteractiveModel new addStates: {
		BrLayoutHorizontalResizerModel matchParent.
		BrLayoutVerticalResizerModel fitContentLimited }).

	breadcrumb := nil.
	header := self newHeaderElement.
	self addChild: header as: #header
]

{ #category : #'instance creation' }
GtCoderContentElement >> newBreadcrumb [
	<return: #BrBreadcrumb>

	^ GtCoderBreadcrumbElement new
		constraintsDo: [ :c | 
			c margin: (BlInsets top: 2).
			c frame horizontal alignLeft.
			c frame vertical alignCenter ];
		yourself
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
		yourself
]

{ #category : #'as yet unclassified' }
GtCoderContentElement >> withBreadcrumb [
	breadcrumb
		ifNotNil: [ ^ self ].

	breadcrumb := self newBreadcrumb.
	coder ifNotNil: [ :aCoder | breadcrumb coder: aCoder ].

	header addChild: breadcrumb as: #breadcrumb.
]
