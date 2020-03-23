Class {
	#name : #GtClassCoderHeaderElement,
	#superclass : #BlElement,
	#instVars : [
		'classCoder'
	],
	#category : #'GToolkit-Coder-UI - Class'
}

{ #category : #'event handling' }
GtClassCoderHeaderElement >> actOnClassChanged: anAnnouncement [
	self classCoder navigationModel
		updateSelectionWith: anAnnouncement classOrMetaClass.

	self initializeElements
]

{ #category : #'event handling' }
GtClassCoderHeaderElement >> actOnPackageChanged: anAnnouncement [
	self classCoder navigationModel updateSelectionWith: anAnnouncement package.
	self removeChildren
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buildButtonForSlot: aSlot [

	^ GtClassCoderEditableLabel new
		text: aSlot name asRopedText;
		whenAccepted: [ :aText |
			(RBRenameInstanceVariableRefactoring
				rename: aSlot name
				to: aText characters asString asSymbol
				in: aSlot definingClass) execute ]
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
	
	aContainer addChildren: (self classCoder theClass slots collect: [ :eachSlot |
		(self buildButtonForSlot: eachSlot) margin: (BlInsets right: 5)
	]).
	
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
		constraintsDo: [ :c | c grid horizontal alignRight ]
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> buildSlots [
	| aContainer |
	
	aContainer := BlElement new.
	aContainer layout: BlFlowLayout new.
	aContainer constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	aContainer addChildren: (self classCoder theClass slots collect: [ :eachSlot |
		(self buildButtonForSlot: eachSlot) margin: (BlInsets right: 5)
	]).
	
	^ aContainer
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
	
	self layout: BlLinearLayout vertical.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ]
]

{ #category : #'private - ui' }
GtClassCoderHeaderElement >> initializeElements [
	| theClassProperties |
	self removeChildren.
	
	self addChild: (self buildClassName).
	
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
		self buildSlots.
		self buildSectionLabel: 'Class vars:'.
		self buildClassVarNames.
		self buildSectionLabel: 'Class instance vars:'.
		self buildSuperClassButton.
	}.
	
	self addChild: theClassProperties
]
