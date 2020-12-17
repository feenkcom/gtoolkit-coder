Class {
	#name : #GtBehaviorDefinitionCoderElement,
	#superclass : #BrExpander,
	#instVars : [
		'behaviorCoderUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Behavior-Definition'
}

{ #category : #'private - instance creation' }
GtBehaviorDefinitionCoderElement >> addDefinitionEditorShortcutsTo: aPropertiesElement [
	aPropertiesElement addShortcut: (BlShortcutWithAction new
		combination: BlKeyCombination arrowUp;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					up;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).

	aPropertiesElement addShortcut: (BlShortcutWithAction new
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
GtBehaviorDefinitionCoderElement >> buildDefinitionEditor [
	| theProperties |
		
	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].
		
	self addDefinitionEditorShortcutsTo: theProperties.

	self editors do: [ :eachEditor |
		theProperties addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self editableLabelLook ];
					margin: self buttonMargin;
					asElement) } ].

	theProperties addChild: (GtRefactoringsPreviewButton new
		refactorings: [ self coderUIModel coder refactorings ];
		when: GtRefactoringsAppliedEvent do: [
			self initializeElements
		];
		constraintsDo: [ :c | c grid horizontal span: 2 ]).

	^ theProperties
]

{ #category : #'private - instance creation' }
GtBehaviorDefinitionCoderElement >> buildDefinitionReader [
	| theProperties theReaders |

	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	theReaders := self readers.
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
GtBehaviorDefinitionCoderElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName, ':';
		focusability: BlFocusability none;
		margin: (BlInsets top: 5 right: 2);
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #'private - ui' }
GtBehaviorDefinitionCoderElement >> buttonMargin [
	^ BlInsets top: 3 left: 0 bottom: 3 right: 5
]

{ #category : #accessing }
GtBehaviorDefinitionCoderElement >> coderUIModel [
	^ behaviorCoderUIModel
]

{ #category : #accessing }
GtBehaviorDefinitionCoderElement >> coderUIModel: aGtBehaviorDefinitionCoderUIModel [
	behaviorCoderUIModel := aGtBehaviorDefinitionCoderUIModel.	
	self initializeElements
]

{ #category : #'private - ui' }
GtBehaviorDefinitionCoderElement >> editableLabelLook [
	^ BrGlamorousEditableLabelLook new
		glamorousCodeFont;
		defaultForeground: Color black;
		fontSize: 10
]

{ #category : #'private - accessing' }
GtBehaviorDefinitionCoderElement >> editors [
	<return: #Collection of: #GtCodeDefinitionViewer>

	^ behaviorCoderUIModel coder definition editors
]

{ #category : #initialization }
GtBehaviorDefinitionCoderElement >> initialize [
	super initialize.	

	self
		look: GtCoderExpanderLook;
		hMatchParent;
		vFitContent
]

{ #category : #'private - ui' }
GtBehaviorDefinitionCoderElement >> initializeElements [
	self header: [ self buildDefinitionReader ].
	self content: [ self buildDefinitionEditor ]
]

{ #category : #'private - accessing' }
GtBehaviorDefinitionCoderElement >> readers [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ behaviorCoderUIModel coder definition readers
]

{ #category : #'private - ui' }
GtBehaviorDefinitionCoderElement >> readonlyLabelLook [
	^ BrGlamorousEditorLook new
		glamorousCodeFont;
		fontSize: 10;
		foreground: Color black;
		add: (BrStyleCommonLook new
			default: [ :aStyle |
				aStyle
					geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
					border: BlBorder empty ];
			hovered: [ :aStyle | aStyle border: (BlBorder paint: BrGlamorousColors hoveredButtonBorderColor width: 1) ]);
		yourself
]
