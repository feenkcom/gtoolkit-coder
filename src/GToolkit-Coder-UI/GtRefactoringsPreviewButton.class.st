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
		vFitContentLimited;
		refactorings: self refactorings.

	applyAction := [
		self fireEvent: (BrDropdownHideWish new anchor: self).
		theRefactoringsElement applyRefactorings.
		self dispatchEvent: GtRefactoringsAppliedEvent new ].

	anAcceptButton := BrButton new
		id: GtRefactoringsPreviewAcceptId;
		icon: BrGlamorousVectorIcons accept;
		beSmallSize;
		requestFocus;
		look: BrGlamorousButtonWithIconLook new;
		label: 'Save';
		margin: (BlInsets top: 0 left: 10 bottom: 10 right: 0);
		action: applyAction;
		yourself.
		
	anAcceptButton addShortcut: (BlShortcutWithAction new
		combination: BlKeyCombination return;
		action: applyAction).
	
	aContainer := BlElement new
		layout: BlLinearLayout vertical;
		when: GtPhlowObjectToSpawn do: [ :anEvent | 
			anEvent target phlow spawnObject: anEvent object ];
		constraintsDo: [ :c |
			c horizontal exact: self previewWidth.
			c vertical fitContentLimited ].
	aContainer addChild: ((theRefactoringsElement asScalableElement
			width: self previewWidth;
			fitWidth;
			constraintsDo: [ :c | c vertical fitContentLimited ]) asScrollableElement
				constraintsDo: [ :c | c vertical fitContentLimited ]).
	aContainer addChild: anAcceptButton. 

	^ aContainer
]

{ #category : #initialization }
GtRefactoringsPreviewButton >> initialize [
	super initialize.
	
	refactoringsComputation := [ #() ].
	
	self
		icon: BrGlamorousVectorIcons accept;
		beSmallSize;
		look: BrGlamorousButtonWithIconLook new + (BrGlamorousWithDropdownLook
			handle: [
				BrButton new
					icon: BrGlamorousIcons empty;
					beSmallSize;
					look: BrGlamorousButtonRectangularLook new + BrGlamorousButtonIconLook new ]
			content: [
				BlLazyElement new
					layout: BlLinearLayout vertical;
					withGlamorousPreview: 'Computing...';
					constraintsDo: [ :c |
						c vertical exact: 50.
						c horizontal exact: self previewWidth ];
					postAction: [ :theLazyElement |								
						theLazyElement constraintsDo: [ :c | 
							c vertical fitContentLimited ] ];
					elementBuilder: [ self buildRefactoringsPreview ] ]);
		label: 'Preview'.
		
	self addShortcut: (BlShortcutWithAction new
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
