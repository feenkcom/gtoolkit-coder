Class {
	#name : #GtBehaviorCoderHeaderElement,
	#superclass : #BrExpander,
	#instVars : [
		'classCoder',
		'headerModel'
	],
	#category : #'GToolkit-Coder-UI-Behaviour'
}

{ #category : #'event handling' }
GtBehaviorCoderHeaderElement >> actOnClassChanged: theClass [
	self initializeElements
]

{ #category : #'event handling' }
GtBehaviorCoderHeaderElement >> actOnPackageChanged: anAnnouncement [	
	self header: [ BlElement new ].
	self content: [ BlElement new ]
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> addDefinitionEditorShortcutsTo: aPropertiesElement [
	aPropertiesElement addShortcut: (BlShortcut new
		combination: BlKeyCombination arrowUp;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					up;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).

	aPropertiesElement addShortcut: (BlShortcut new
		combination: BlKeyCombination arrowDown;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					down;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> buildDefinitionEditor [
	| theProperties |
		
	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].
		
	self addDefinitionEditorShortcutsTo: theProperties.

	headerModel editors do: [ :eachEditor |
		theProperties addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self editableLabelLook ];
					margin: self buttonMargin;
					asElement) } ].

	theProperties addChild: (GtRefactoringsPreviewButton new
		refactorings: [ headerModel refactorings ];
		when: GtRefactoringsAppliedEvent do: [ headerModel behavior: headerModel behavior ];
		constraintsDo: [ :c | c grid horizontal span: 2 ]).

	^ theProperties
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> buildDefinitionReader [
	| theProperties theReaders |

	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	theReaders := headerModel readers.
	theReaders := theReaders first: (2 min: theReaders size).
	theReaders do: [ :eachEditor |
		theProperties addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self readonlyLabelLook ];
					margin: self buttonMargin;
					asElement) } ].

	^ theProperties
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName, ':';
		focusability: BlFocusability none;
		margin: (BlInsets top: 5 right: 2);
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #'private - ui' }
GtBehaviorCoderHeaderElement >> buttonMargin [
	^ BlInsets top: 3 left: 0 bottom: 3 right: 5
]

{ #category : #accessing }
GtBehaviorCoderHeaderElement >> classCoder [
	<return: #GtClassCoder>

	^ classCoder
]

{ #category : #accessing }
GtBehaviorCoderHeaderElement >> classCoder: aGtClassCoder [
	classCoder := aGtClassCoder.	
	classCoder
		when: GtCoderPackageUpdatedAnnouncement
			do: [ :anAnnouncement | self actOnPackageChanged: anAnnouncement ].
			
	headerModel behavior: classCoder theClass
]

{ #category : #'private - ui' }
GtBehaviorCoderHeaderElement >> editableLabelLook [
	^ BrGlamorousEditableLabelLook new
		glamorousCodeFont;
		defaultForeground: Color black;
		fontSize: 10
]

{ #category : #initialization }
GtBehaviorCoderHeaderElement >> initialize [
	super initialize.	
	
	self viewModel add: (headerModel := GtBehaviorCoderHeaderModel new).

	self
		look: GtCoderExpanderLook;
		hMatchParent;
		vFitContent.

	self
		when: GtBehaviorCoderHeaderClassChanged
		do: [ :anEvent | self actOnClassChanged: anEvent theClass ]
]

{ #category : #'private - ui' }
GtBehaviorCoderHeaderElement >> initializeElements [
	self header: [ self buildDefinitionReader ].
	self content: [ self buildDefinitionEditor ]
]

{ #category : #'private - ui' }
GtBehaviorCoderHeaderElement >> readonlyLabelLook [
	^ BrGlamorousEditorLook new
		glamorousCodeFont;
		fontSize: 10;
		foreground: Color black;
		add: (BrInteractiveCommonLook new
			default: [ :aWidget |
				aWidget
					geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
					border: BlBorder empty ];
			hovered: [ :aWidget | aWidget border: (BlBorder paint: BrGlamorousColors hoveredButtonBorderColor width: 1) ]);
		yourself
]
