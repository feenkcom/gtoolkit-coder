Class {
	#name : #GtCreateBehaviorElement,
	#superclass : #GtCreateElement,
	#instVars : [
		'behaviorBlock'
	],
	#category : #'GToolkit-Coder-Behavior - UI'
}

{ #category : #accessing }
GtCreateBehaviorElement >> behaviorBlock: aBlock [
	behaviorBlock := aBlock
]

{ #category : #'private - instance creation' }
GtCreateBehaviorElement >> buildClassLabel [
	^ headerModel definition nameEditor asElement
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 18);
		yourself
]

{ #category : #'private - instance creation' }
GtCreateBehaviorElement >> buildDefinitionEditor [
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
				action: [ self compileBehavior ];
				constraintsDo: [ :c | c grid horizontal span: 2 ]).

	^ theProperties
]

{ #category : #private }
GtCreateBehaviorElement >> compileBehavior [
	| change |
	change := headerModel definition createBehaviorChange.
	change execute.
	behaviorBlock notNil
		ifTrue: [ behaviorBlock cull: change definedClass ]
]

{ #category : #initialization }
GtCreateBehaviorElement >> forClassDefinition [
	headerModel := GtBehaviorCoderHeaderModel new
		definition: GtClassDefinition forNew.
	self addChild: self buildDefinitionEditor
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
GtCreateBehaviorElement >> forTraitDefinition [
	headerModel := GtBehaviorCoderHeaderModel new
		definition: GtTraitDefinition forNew.
	self addChild: self buildDefinitionEditor
]
