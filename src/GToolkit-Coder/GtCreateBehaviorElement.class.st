Class {
	#name : #GtCreateBehaviorElement,
	#superclass : #BlElement,
	#instVars : [
		'headerModel',
		'classBlock'
	],
	#category : #'GToolkit-Coder-Behavior - UI'
}

{ #category : #'private - instance creation' }
GtCreateBehaviorElement >> buildClassLabel [
	^ headerModel definition nameEditor asElement
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 20);
		yourself
]

{ #category : #'private - instance creation' }
GtCreateBehaviorElement >> buildDefinitionEditor [
	| theProperties |
		
	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].
		
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
			
	
	theProperties addChild: (self buildClassLabel constraintsDo: [ :c | c grid horizontal span: 2 ]).

	headerModel editors do: [ :eachEditor |
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
				action: [ self compileClass ];
				constraintsDo: [ :c | c grid horizontal span: 2 ]).

	^ theProperties
]

{ #category : #'private - instance creation' }
GtCreateBehaviorElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName, ':';
		focusability: BlFocusability none;
		margin: (BlInsets top: 5 right: 2);
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #'private - ui' }
GtCreateBehaviorElement >> buttonMargin [
	^ BlInsets top: 3 left: 0 bottom: 3 right: 5
]

{ #category : #accessing }
GtCreateBehaviorElement >> classBlock: aBlock [
	classBlock := aBlock
]

{ #category : #private }
GtCreateBehaviorElement >> compileClass [
	| change |
	change := headerModel definition createClassChange.
	change execute.
	classBlock notNil
		ifTrue: [ classBlock cull: change definedClass ]
]

{ #category : #'private - ui' }
GtCreateBehaviorElement >> editableLabelLook [
	^ BrGlamorousEditableLabelLook new
		glamorousCodeFont;
		defaultForeground: Color black;
		fontSize: 10
]

{ #category : #initialization }
GtCreateBehaviorElement >> forPackage: aPackage [
	headerModel definition category package name: aPackage name
]

{ #category : #initialization }
GtCreateBehaviorElement >> forPackageTag: aPackageTag [
	headerModel definition category tag name: aPackageTag name
]

{ #category : #initialization }
GtCreateBehaviorElement >> forSuperclass: aClass [
	headerModel definition superclass name: aClass name
]

{ #category : #initialization }
GtCreateBehaviorElement >> initialize [
	super initialize.
	headerModel := GtBehaviorCoderHeaderModel new
		definition: GtClassDefinition forNew.
	self layout: BlFlowLayout vertical.
	self margin: (BlInsets all: 5).
	self
		constraintsDo: [ :c | 
			c horizontal exact: 400.
			c vertical fitContent ].
	self addChild: self buildDefinitionEditor
]
