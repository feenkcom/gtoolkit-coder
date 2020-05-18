Class {
	#name : #GtCreatePackageElement,
	#superclass : #GtCreateElement,
	#instVars : [
		'packageBlock'
	],
	#category : #'GToolkit-Coder-Behavior - UI'
}

{ #category : #initialization }
GtCreatePackageElement >> buildDefinitionEditor [
	| theProperties |
		
	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 10).
		
	theProperties addShortcut: (BlShortcut new
		combination: BlKeyCombination arrowUp;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					up;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).

	theProperties addShortcut: (BlShortcut new
		combination: BlKeyCombination arrowDown;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					down;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).
			
	
	theProperties addChild: (self buildPackageLabel constraintsDo: [ :c | c grid horizontal span: 2 ]).

	headerModel tag editors do: [ :eachEditor |
		theProperties addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self editableLabelLook ];
					margin: self buttonMargin;
					asElement) } ].

	theProperties
		addChild:
			(BrButton new
				icon: BrGlamorousVectorIcons accept;
				beSmall;
				look: BrGlamorousButtonWithIconLook new;
				label: 'Save';
				action: [ self createPackage ];
				constraintsDo: [ :c | c grid horizontal span: 2 ]).

	^ theProperties
]

{ #category : #'private - ui' }
GtCreatePackageElement >> buildPackageLabel [
	^ headerModel package packageEditor asElement
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
	change := headerModel createPackageChange.
	change execute.
	packageBlock notNil
		ifTrue: [ packageBlock cull: change package cull: change tag ]
]

{ #category : #initialization }
GtCreatePackageElement >> forPackage: aPackage [
	headerModel package name: aPackage name
]

{ #category : #initialization }
GtCreatePackageElement >> initialize [
	super initialize.
	headerModel := GtCategoryDefinition empty.
	headerModel package name: 'NewPackage'.
	self addChild: self buildDefinitionEditor
]

{ #category : #accessing }
GtCreatePackageElement >> packageBlock: aBlock [
	packageBlock := aBlock
]
