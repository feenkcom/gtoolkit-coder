Class {
	#name : #GtClassCoderSlotsElement,
	#superclass : #BlElement,
	#instVars : [
		'classCoder'
	],
	#category : #'GToolkit-Coder-UI - Class'
}

{ #category : #'event handling' }
GtClassCoderSlotsElement >> actOnSlotsChanged: anAnnouncement [
	self initializeElements
]

{ #category : #initialization }
GtClassCoderSlotsElement >> addNewSlotEditorBefore: aButton [
	| aNewSlotCreator |

	aNewSlotCreator := nil.
	aNewSlotCreator := GtClassCoderEditableLabel new
		text: '';
		requestFocus;
		switchToEditor;
		margin: self buttonMargin;
		padding: (BlInsets top: 5 left: 10 bottom: 5 right: 10);
		whenAccepted: [ :aText |
			aNewSlotCreator isAttachedToSceneGraph
				ifTrue: [
					| aNewSlotName |
					aNewSlotName := aText characters asString trimmed asSymbol.

					(Slot gtIsValidName: aNewSlotName)
						ifTrue: [
							(RBAddInstanceVariableRefactoring
								variable: aNewSlotName
								class: self classCoder theClass) execute ].
			aNewSlotCreator removeFromParent ] ];
		whenCancelled: [ :anEditableLabel | anEditableLabel removeFromParent ].
		
	aNewSlotCreator navigator
		moveTo: 0;
		apply.

	self addChild: aNewSlotCreator at: (self childIndexOf: aButton)
]

{ #category : #'instance creation' }
GtClassCoderSlotsElement >> buildButtonForSlot: aSlot [
	^ GtClassCoderEditableLabel new
		text: aSlot name asRopedText;
		margin: self buttonMargin;
		whenAccepted: [ :aText |
			| aCurrentSlotName aNewSlotName |
			
			aCurrentSlotName := aSlot name asSymbol.
			aNewSlotName := aText characters asString trimmed asSymbol.
			
			aCurrentSlotName ~= aNewSlotName
				ifTrue: [
					(RBRenameInstanceVariableRefactoring
						rename: aCurrentSlotName
						to: aNewSlotName
						in: aSlot definingClass) execute ] ];
		whenCancelled: [ :anEditableLabel | anEditableLabel text: aSlot name asRopedText ];
		whenDeleted: [ :anEditableLabel |
			(anEditableLabel parent childAt: (((anEditableLabel parent childIndexOf: anEditableLabel) + 1) min: anEditableLabel parent childrenCount)) requestFocus.
			anEditableLabel removeFromParent.

			(RBRemoveInstanceVariableRefactoring
				remove: aSlot name
				from: aSlot definingClass) execute ]
]

{ #category : #'as yet unclassified' }
GtClassCoderSlotsElement >> buttonMargin [
	^ BlInsets top: 0 right: 5 bottom: 3 left: 0
]

{ #category : #accessing }
GtClassCoderSlotsElement >> classCoder [
	<return: #GtClassCoder>

	^ classCoder
]

{ #category : #accessing }
GtClassCoderSlotsElement >> classCoder: aGtClassCoder [
	classCoder := aGtClassCoder.
	
	self initializeElements.

	classCoder
		when: GtClassCoderSlotsChanged do: [ :anAnnouncement | self actOnSlotsChanged: anAnnouncement ]
]

{ #category : #initialization }
GtClassCoderSlotsElement >> initialize [
	super initialize.
	
	self layout: BlFlowLayout new.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ]
]

{ #category : #initialization }
GtClassCoderSlotsElement >> initializeElements [
	self removeChildren.
	
	self addChildren: (self classCoder theClass slots collect: [ :eachSlot |
		(self buildButtonForSlot: eachSlot) ]).
	
	self addChild: (BrButton new
		look: BrGlamorousButtonWithIconLook new;
		icon: BrGlamorousIcons add;
		label: 'Add slot';
		action: [ :aButton | self addNewSlotEditorBefore: aButton ])
]
