Class {
	#name : #GtCreatePackageElement,
	#superclass : #GtCreateElement,
	#instVars : [
		'packageBlock'
	],
	#category : #'GToolkit-Coder-UI-Behaviour'
}

{ #category : #initialization }
GtCreatePackageElement >> buildDefinitionEditor [
	| theProperties saveButton |
		
	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 10).
		
	theProperties addShortcut: (BlShortcutWithAction new
		combination: BlKeyCombination arrowUp;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					up;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).

	theProperties addShortcut: (BlShortcutWithAction new
		combination: BlKeyCombination arrowDown;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					down;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).

	saveButton := BrButton new
		icon: BrGlamorousVectorIcons accept;
		beSmallSize;
		look: BrGlamorousButtonWithIconLook new;
		label: 'Save';
		action: [ self createPackage ];
		constraintsDo: [ :c | c grid horizontal span: 2 ];
		disable.

	definition package
		when: GtBehaviorChangeEvent
		do: [ :event | saveButton enabled: definition isValidForCreation ].
	
	theProperties addChild: (self buildPackageLabel constraintsDo: [ :c | c grid horizontal span: 2 ]).

	definition tag editors do: [ :eachEditor |
		eachEditor definition
			when: GtBehaviorChangeEvent
			do: [ :event | saveButton enabled: definition isValidForCreation ].
		theProperties addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self editableLabelLook ];
					margin: self buttonMargin;
					asElement) } ].

	theProperties addChild: saveButton.

	^ theProperties
]

{ #category : #'private - ui' }
GtCreatePackageElement >> buildPackageLabel [
	^ definition package packageEditor asElement
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 18);
		yourself
]

{ #category : #initialization }
GtCreatePackageElement >> createPackage [
	| change |
	change := definition createPackageChange.
	change execute.
	packageBlock notNil
		ifTrue: [ packageBlock cull: change package cull: change tag ]
]

{ #category : #initialization }
GtCreatePackageElement >> forPackage: aPackage [
	definition package name: aPackage name
]

{ #category : #initialization }
GtCreatePackageElement >> initialize [
	super initialize.
	definition := GtCategoryDefinition empty.
	definition package name: 'NewPackage'.
	self addChild: self buildDefinitionEditor
]

{ #category : #accessing }
GtCreatePackageElement >> packageBlock: aBlock [
	packageBlock := aBlock
]
