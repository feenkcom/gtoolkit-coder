Class {
	#name : #GtCreateBehaviorElement,
	#superclass : #GtCreateElement,
	#instVars : [
		'behaviorBlock'
	],
	#category : #'GToolkit-Coder-UI-Behaviour'
}

{ #category : #accessing }
GtCreateBehaviorElement class >> saveButtonName [
	^ #'creator--save-button'
]

{ #category : #accessing }
GtCreateBehaviorElement >> behaviorBlock: aBlock [
	behaviorBlock := aBlock
]

{ #category : #'private - instance creation' }
GtCreateBehaviorElement >> buildClassLabel [
	^ definition nameEditor asElement
		look: (BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 18);
		yourself
]

{ #category : #'private - instance creation' }
GtCreateBehaviorElement >> buildDefinitionEditor [
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
		action: [ self compileBehavior ];
		constraintsDo: [ :c | c grid horizontal span: 2 ];
		containerName: self class saveButtonName;
		disable.

	definition
		when: GtBehaviorChangeEvent
		do: [ :event | saveButton enabled: definition isValidForCreation ].

	theProperties addChild: (self buildClassLabel constraintsDo: [ :c | c grid horizontal span: 2 ]).

	self editors do: [ :eachEditor |
		theProperties addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self editableLabelLook ];
					margin: self buttonMargin;
					asElement) } ].

	theProperties addChild: saveButton.

	^ theProperties
]

{ #category : #private }
GtCreateBehaviorElement >> compileBehavior [
	| change |
	
	"before creating a class we should create a proper package + tag"
	definition category isValidForCreation
		ifTrue: [ definition category createPackageChange execute ].
	
	change := definition createBehaviorChange.
	
	change execute.
	
	behaviorBlock notNil
		ifTrue: [ behaviorBlock cull: change definedClass ]
]

{ #category : #private }
GtCreateBehaviorElement >> editors [
	^ definition editors
]

{ #category : #initialization }
GtCreateBehaviorElement >> forClassDefinition [
	definition := GtClassDefinition forNew.
	self addChild: self buildDefinitionEditor
]

{ #category : #initialization }
GtCreateBehaviorElement >> forClassName: aSymbol [
	definition name: aSymbol
]

{ #category : #initialization }
GtCreateBehaviorElement >> forPackage: aPackage [
	definition category package name: aPackage name
]

{ #category : #initialization }
GtCreateBehaviorElement >> forPackageTag: aPackageTag [
	definition category tag name: aPackageTag name
]

{ #category : #initialization }
GtCreateBehaviorElement >> forSuperclass: aClass [
	definition superclass name: aClass name
]

{ #category : #initialization }
GtCreateBehaviorElement >> forTraitDefinition [
	definition := GtTraitDefinition forNew.
	self addChild: self buildDefinitionEditor
]

{ #category : #private }
GtCreateBehaviorElement >> isValidForCreation [
	^ definition isValidForCreation
]
