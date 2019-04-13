Class {
	#name : #GtClassCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'coder',
		'contentPane',
		'headerPane',
		'navigationElement',
		'panesNavigationButton',
		'treeNavigationButton'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtClassCoderElement >> buildContent [
	self buildHeaderPane.
	contentPane := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: contentPane.
	
	self updateNavigationElement.
	self coderModel methodsCoder ifNotNil: [ :aMethodsCoder |
		| methodsCoderElement | 
		
		methodsCoderElement := aMethodsCoder asElement.
		methodsCoderElement constraintsDo: [ :c |
			c linear weight: 2 ].
		contentPane addChild: methodsCoderElement ]
]

{ #category : #'building ui' }
GtClassCoderElement >> buildHeaderPane [
	| selectorElement toolbarElement |
	headerPane := BlElement new
		layout: BlLinearLayout new;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	selectorElement := self coderModel searchFilter asElement.
	toolbarElement := self buildToolbar.
	toolbarElement 
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c horizontal fitContent.
			c vertical matchParent ].
	headerPane addChild: selectorElement.
	headerPane addChild: toolbarElement.	
	self addChild: headerPane.
]

{ #category : #'building ui' }
GtClassCoderElement >> buildNavigationElement [
	| element |
	element := self coderModel navigationModel asElement.
	"element padding: (BlInsets all: 10)."
	element constraintsDo: [ :c |
		c linear weight: 0.5 ].
	^ element
]

{ #category : #'building ui' }
GtClassCoderElement >> buildPanesNavigationToolbarButton [	
	| toggle |
	toggle := BrToggle new 
		look: BrMaterialToggleBackgroundLook + BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons threepanes asElement;
		when: BrToggleActivatedEvent do: [ :anEvent | 
			treeNavigationButton deactivate.
			self coderModel 
				navigationModel: GtCoderPackagesPanesNavigation new ];
		when: BrToggleDeactivatedEvent do: [ :anEvent | 
			self coderModel navigationModel: nil ].
	^ toggle
]

{ #category : #'building ui' }
GtClassCoderElement >> buildToolbar [ 	
	| toolbar |
	toolbar := BrToolbar new.
	toolbar look: BrGlamorousToolbarLook new.
	panesNavigationButton := self buildPanesNavigationToolbarButton.
	treeNavigationButton := self buildTreeNavigationToolbarButton.
	toolbar addItem: treeNavigationButton.
	toolbar addItem: panesNavigationButton.
	^ toolbar
]

{ #category : #'building ui' }
GtClassCoderElement >> buildTreeNavigationToolbarButton [	
	| toggle |
	toggle := BrToggle new 
		look: BrMaterialToggleBackgroundLook + BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons tree asElement;
		when: BrToggleActivatedEvent do: [ :anEvent | 
			panesNavigationButton deactivate.
			self coderModel 
				navigationModel: GtCoderPackagesTreeNavigation new ];
		when: BrToggleDeactivatedEvent do: [ :anEvent |
			self coderModel navigationModel: nil ].
	^ toggle
]

{ #category : #accessing }
GtClassCoderElement >> coderModel [
	^ coder
]

{ #category : #accessing }
GtClassCoderElement >> coderModel: aCoder [
	coder := aCoder.
	coder
		when: GtCoderClassSelectedAnnouncement
		do: [ :ann | self updateMethodsCoderElement ].
	coder
		when: GtCoderNavigationModelChangedAnnouncement
		do: [ :ann | self updateNavigationElement ].
	self buildContent.
]

{ #category : #accessing }
GtClassCoderElement >> contentPane [
	^ contentPane
]

{ #category : #initialization }
GtClassCoderElement >> initialize [ 
	super initialize.
	self 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self padding: (BlInsets left: 10 right: 10).
]

{ #category : #'updating ui' }
GtClassCoderElement >> removeNavigationElement [
	navigationElement ifNotNil: [
		contentPane removeChild: navigationElement.
		navigationElement := nil ].
]

{ #category : #'updating ui' }
GtClassCoderElement >> updateMethodsCoderElement [
	| methodsCoder |
	methodsCoder := self coderModel methodsCoder.
	self contentPane removeChildAt: self contentPane childrenCount.
	self contentPane addChild: methodsCoder asElement
]

{ #category : #'updating ui' }
GtClassCoderElement >> updateNavigationElement [
	| navigationModel |
	
	self removeNavigationElement.
	navigationModel := self coderModel navigationModel.
	navigationModel ifNil: [ ^ self ].
	
	navigationModel displayPosition = #top
		ifTrue: [ contentPane layout: BlLinearLayout vertical ].
	navigationModel displayPosition = #left
		ifTrue: [ contentPane layout: BlLinearLayout horizontal ].
	
	navigationElement := self buildNavigationElement.
	contentPane addChildFirst: navigationElement.
]
