Class {
	#name : #GtRefactoringsPreviewButton,
	#superclass : #BrButton,
	#instVars : [
		'refactoringsComputation'
	],
	#category : #'GToolkit-Coder-UI-Refactoring'
}

{ #category : #initialization }
GtRefactoringsPreviewButton >> buildRefactoringsPreview [
	| applyAction theRefactoringsElement anAcceptButton aContainer |

	theRefactoringsElement := GtRefactoringsElement new
		hExact: self previewWidth * 1.25;
		vFitContent;
		refactorings: self refactorings.

	applyAction := [
		self fireEvent: (BrDropdownHideWish new anchor: self).
		theRefactoringsElement applyRefactorings.
		self dispatchEvent: GtRefactoringsAppliedEvent new ].

	anAcceptButton := BrButton new
		icon: BrGlamorousVectorIcons accept;
		beSmall;
		requestFocus;
		look: BrGlamorousButtonWithIconLook new;
		label: 'Save';
		margin: (BlInsets top: 0 left: 10 bottom: 10 right: 0);
		action: applyAction;
		yourself.
		
	anAcceptButton addShortcut: (BlShortcut new
		combination: BlKeyCombination return;
		action: applyAction).
	
	aContainer := BlElement new
		layout: BlLinearLayout vertical;
		when: GtPhlowObjectToSpawn do: [ :anEvent | 
			anEvent target phlow spawnObject: anEvent object ];
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

{ #category : #initialization }
GtRefactoringsPreviewButton >> initialize [
	super initialize.
	
	refactoringsComputation := [ #() ].
	
	self
		icon: BrGlamorousVectorIcons accept;
		beSmall;
		look: BrGlamorousButtonWithIconLook new + (BrGlamorousWithDropdownLook
			handle: [ BrButton new
				icon: BrGlamorousIcons empty;
				beSmall;
				look: BrGlamorousButtonRectangularLook new + BrGlamorousButtonIconLook new ]
			content: [ self buildRefactoringsPreview ]);
		label: 'Preview'.
		
	self addShortcut: (BlShortcut new
		combination: BlKeyCombination return;
		action: [ self fireEvent: (BrDropdownShowWish new anchor: self) ])
]

{ #category : #initialization }
GtRefactoringsPreviewButton >> previewWidth [
	^ self isAttachedToSceneGraph
		ifTrue: [ (self topMostParent extent / 2.0) x ]
		ifFalse: [ 500 ]
]

{ #category : #accessing }
GtRefactoringsPreviewButton >> refactorings [
	^ refactoringsComputation value
]

{ #category : #accessing }
GtRefactoringsPreviewButton >> refactorings: aBlock [
	refactoringsComputation := aBlock
]
