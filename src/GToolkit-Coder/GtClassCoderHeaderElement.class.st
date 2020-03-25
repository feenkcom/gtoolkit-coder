Class {
	#name : #GtClassCoderHeaderElement,
	#superclass : #BrExpander,
	#instVars : [
		'classCoder',
		'expanderElement'
	],
	#category : #'GToolkit-Coder-Class - UI'
}

{ #category : #'event handling' }
GtClassCoderHeaderElement >> actOnClassChanged: anAnnouncement [
	self classCoder navigationModel
		updateSelectionWith: anAnnouncement classOrMetaClass.

	self initializeElements
]

{ #category : #'event handling' }
GtClassCoderHeaderElement >> actOnClassUpdated [
	self initializeElements
]

{ #category : #'event handling' }
GtClassCoderHeaderElement >> actOnPackageChanged: anAnnouncement [
	self classCoder navigationModel updateSelectionWith: anAnnouncement package.
	
	self header: [ BlElement new ].
	self content: [ BlElement new ]
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buildClassName [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: classCoder name
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buildClassVarNames [
	| aContainer |
	
	aContainer := BlElement new.
	aContainer layout: BlFlowLayout new.
	aContainer constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	
	
	^ aContainer
]

{ #category : #'private - instance creation' }
GtClassCoderHeaderElement >> buildDefinitionEditor [
	| aContainer theClassProperties |
	
	aContainer := BrVerticalPane new
		hMatchParent;
		vFitContent.
	
	aContainer addChild: (self buildClassName).
	
	theClassProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2; cellSpacing: 5);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	theClassProperties addChildren: { 
		self buildSectionLabel: 'Super:'.
		self buildSuperClassButton.
		self buildSectionLabel: 'Traits:'.
		self buildSuperClassButton.
		self buildSectionLabel: 'Package:'.
		self buildSuperClassButton.
		self buildSectionLabel: 'Instance vars:'.
		(GtClassCoderSlotsElement new classCoder: self classCoder).
		self buildSectionLabel: 'Class vars:'.
		self buildClassVarNames.
		self buildSectionLabel: 'Class instance vars:'.
		self buildSuperClassButton.
	}.
	
	aContainer addChild: theClassProperties.
	
	^ aContainer
]

{ #category : #'private - instance creation' }
GtClassCoderHeaderElement >> buildDefinitionViewer [
	| aContainer theClassProperties |
	
	aContainer := BrVerticalPane new
		hMatchParent;
		vFitContent.
	
	aContainer addChild: (self buildClassName).
	
	theClassProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2; cellSpacing: 5);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	theClassProperties addChildren: { 
		self buildSectionLabel: 'Super:'.
		self buildSuperClassButton.
		self buildSectionLabel: 'Package:'.
		self buildSuperClassButton.
	}.
	
	aContainer addChild: theClassProperties.
	
	^ aContainer
]

{ #category : #'private - ui blocks' }
GtClassCoderHeaderElement >> buildEditableButton [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook new
]

{ #category : #'private - ui blocks' }
GtClassCoderHeaderElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray);
		text: aSectionName;
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buildSuperClassButton [
	^ self buildEditableButton
		label: self classCoder theClass superclass asString
]

{ #category : #accessing }
GtClassCoderHeaderElement >> classCoder [
	<return: #GtClassCoder>

	^ classCoder
]

{ #category : #accessing }
GtClassCoderHeaderElement >> classCoder: aGtClassCoder [
	classCoder := aGtClassCoder.
	classCoder
		when: GtCoderClassUpdatedAnnouncement
			do: [ :anAnnouncement | self actOnClassChanged: anAnnouncement ];
		when: GtCoderPackageUpdatedAnnouncement
			do: [ :anAnnouncement | self actOnPackageChanged: anAnnouncement ].
			
	self initializeElements
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> initialize [
	super initialize.

	self
		look: GtCoderExpanderLook new;
		hMatchParent;
		vFitContent
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> initializeElements [
	self header: [ self buildDefinitionViewer ].
	self content: [ self buildDefinitionEditor ]
]
