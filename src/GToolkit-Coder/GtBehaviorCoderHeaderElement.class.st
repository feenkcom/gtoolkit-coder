Class {
	#name : #GtBehaviorCoderHeaderElement,
	#superclass : #BrExpander,
	#instVars : [
		'classCoder',
		'expanderElement',
		'headerModel',
		'instVars',
		'classVars',
		'theSuperclass',
		'thePackage',
		'theTag',
		'theClassName',
		'traits'
	],
	#category : #'GToolkit-Coder-Behavior - UI'
}

{ #category : #'event handling' }
GtBehaviorCoderHeaderElement >> actOnClassChanged: theClass [
	self classCoder navigationModel
		updateSelectionWith: theClass.

	self initializeElements
]

{ #category : #'event handling' }
GtBehaviorCoderHeaderElement >> actOnClassUpdated [
	self initializeElements
]

{ #category : #'event handling' }
GtBehaviorCoderHeaderElement >> actOnPackageChanged: anAnnouncement [
	self classCoder navigationModel updateSelectionWith: anAnnouncement package.
	
	self header: [ BlElement new ].
	self content: [ BlElement new ]
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> buildDefinitionEditor [
	| theProperties anAcceptButton |
		
	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	headerModel editors do: [ :eachEditor |
		theProperties addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self editableLabelLook ];
					margin: self buttonMargin;
					asElement) } ].

	theProperties addChild: (anAcceptButton := BrButton new
		icon: BrGlamorousIcons accept;
		beSmall;
		look: BrGlamorousButtonWithIconLook new + (BrGlamorousWithDropdownLook
			handle: [ BrButton new
				icon: BrGlamorousIcons empty asElement;
				beSmall;
				look: BrGlamorousButtonRectangularLook new + BrGlamorousButtonIconLook new ]
			content: [ self buildRefactoringPreviewFrom: anAcceptButton ]);
		label: 'Apply';
		constraintsDo: [ :c | c grid horizontal span: 2 ]).

	^ theProperties
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> buildDefinitionViewer [
	| theProperties |

	theProperties := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	(headerModel editors first: 2) do: [ :eachEditor |
		theProperties addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: [ self editableLabelLook ];
					margin: self buttonMargin;
					asElement) } ].
	
	
	
	^ theProperties
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> buildRefactoringPreviewFrom: aDropdownAnchor [
	| theRefactoringsElement anAcceptButton aContainer |

	theRefactoringsElement := GtRefactoringsElement new
		hExact: self previewWidth * 1.25;
		vFitContent;
		refactorings: headerModel refactorings.
		
	anAcceptButton := BrButton new
		icon: BrGlamorousIcons accept asElement;
		beSmall;
		look: BrGlamorousButtonWithIconLook new;
		label: 'Apply';
		margin: (BlInsets top: 0 left: 10 bottom: 10 right: 0);
		action: [
			aDropdownAnchor fireEvent: (BrDropdownHideWish new anchor: aDropdownAnchor).
			theRefactoringsElement applyRefactorings ];
		yourself.
	
	aContainer := BlElement new
		layout: BlLinearLayout vertical;
		when: GtPhlowObjectToSpawn do: [ :anEvent | self fireEvent: (GtPhlowObjectToSpawn new
			object: anEvent object;
			sourceElement: anEvent target) ];
		constraintsDo: [ :c |
			c horizontal exact: self previewWidth.
			c vertical fitContentLimitedOffset: 20 ].
	aContainer addChild: (theRefactoringsElement asScalableElement
			width: self previewWidth;
			fitWidth;
			constraintsDo: [ :c | c vertical fitContent ]) asScrollableElement.
	aContainer addChild: anAcceptButton. 

	^ aContainer
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName, ':';
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
		when: GtCoderClassUpdatedAnnouncement
			do: [ :anAnnouncement | headerModel behavior: anAnnouncement classOrMetaClass ];
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
	self header: [ self buildDefinitionViewer ].
	self content: [ self buildDefinitionEditor ]
]

{ #category : #'private - instance creation' }
GtBehaviorCoderHeaderElement >> previewWidth [
	^ self isAttachedToSceneGraph
		ifTrue: [ (self topMostParent extent / 2.0) x ]
		ifFalse: [ 500 ]
]
