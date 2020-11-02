Class {
	#name : #GtBehaviorDefinitionElement,
	#superclass : #BlElement,
	#instVars : [
		'definition'
	],
	#category : #'GToolkit-Coder-UI-Behaviour'
}

{ #category : #'private - instance creation' }
GtBehaviorDefinitionElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName, ':';
		focusability: BlFocusability none;
		margin: (BlInsets top: 5 right: 2);
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #'private - instance creation' }
GtBehaviorDefinitionElement >> buttonMargin [
	^ BlInsets top: 3 left: 0 bottom: 3 right: 5
]

{ #category : #accessing }
GtBehaviorDefinitionElement >> definition [
	^ definition
]

{ #category : #accessing }
GtBehaviorDefinitionElement >> definition: aGtBehaviorDefinition [
	definition := aGtBehaviorDefinition.
	self initializeElements
]

{ #category : #'private - instance creation' }
GtBehaviorDefinitionElement >> editableLabelLook [
	^ BrGlamorousEditableLabelLook new
		glamorousCodeFont;
		defaultForeground: Color black;
		fontSize: 10
]

{ #category : #initialization }
GtBehaviorDefinitionElement >> initialize [
	super initialize.
	
	self
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].
]

{ #category : #initialization }
GtBehaviorDefinitionElement >> initializeElements [	
	self removeChildren.
		
	self addShortcut: (BlShortcut new
		combination: BlKeyCombination arrowUp;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					up;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).

	self addShortcut: (BlShortcut new
		combination: BlKeyCombination arrowDown;
		action: [ :anEvent |
			anEvent currentTarget deepestFocusedChild ifNotNil: [ :aFocusedChild |
				BlFocusFinder new
					down;
					root: anEvent currentTarget;
					referenceElement: aFocusedChild;
					nextFocusDo: [ :aNextFocusElement | aNextFocusElement requestFocus ] ] ]).

	({ self definition nameEditor }, self definition editors) do: [ :eachEditor |
		self addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self editableLabelLook ];
					margin: self buttonMargin;
					asElement) } ].

	self addChild: (GtRefactoringsPreviewButton new
		refactorings: [ { 
				RBDefineClassRefactoring
					model: RBNamespace new
					addClass: self definition name
					superclass: self definition superclass name
					category: self definition category name
					definition: self definition asDefinitionString
		} ];
		when: GtRefactoringsAppliedEvent do: [  ];
		constraintsDo: [ :c | c grid horizontal span: 2 ]).

	^ self
]
