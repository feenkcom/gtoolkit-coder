Class {
	#name : #GtCoderElement,
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
GtCoderElement >> buildContent [
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
	
	contentPane := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: contentPane.
	
	self updateNavigationElement.
	self coderModel classCoder ifNotNil: [ :aClassCoder |
		| classCoderElement | 
		
		classCoderElement := aClassCoder asElement.
		classCoderElement constraintsDo: [ :c |
			c linear weight: 2 ].
		contentPane addChild: classCoderElement ]
]

{ #category : #'building ui' }
GtCoderElement >> buildNavigationElement [
	| element |
	element := self coderModel navigationModel asElement.
	element padding: (BlInsets all: 10).
	element constraintsDo: [ :c |
		c linear weight: 1 ].
	^ element
]

{ #category : #'building ui' }
GtCoderElement >> buildPanesNavigationToolbarButton [	
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
GtCoderElement >> buildToolbar [ 	
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
GtCoderElement >> buildTreeNavigationToolbarButton [	
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
GtCoderElement >> coderModel [
	^ coder
]

{ #category : #accessing }
GtCoderElement >> coderModel: aCoder [
	coder := aCoder.
	coder
		when: GtCoderClassSelectedAnnouncement
		do: [ :ann | self updateClassCoderElement ].
	coder
		when: GtCoderNavigationModelChangedAnnouncement
		do: [ :ann | self updateNavigationElement ].
	self buildContent.
]

{ #category : #accessing }
GtCoderElement >> contentPane [
	^ contentPane
]

{ #category : #initialization }
GtCoderElement >> initialize [ 
	super initialize.
	self 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
]

{ #category : #'updating ui' }
GtCoderElement >> removeNavigationElement [
	navigationElement ifNotNil: [
		contentPane removeChild: navigationElement.
		navigationElement := nil ].
]

{ #category : #'updating ui' }
GtCoderElement >> updateClassCoderElement [
	| classCoder |
	classCoder := self coderModel classCoder.
	[ self contentPane childrenCount > 1 ] whileTrue: [ self contentPane removeChildAt: 2 ].
	self contentPane addChild: classCoder asElement
]

{ #category : #'updating ui' }
GtCoderElement >> updateNavigationElement [
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
