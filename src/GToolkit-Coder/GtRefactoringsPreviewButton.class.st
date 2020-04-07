Class {
	#name : #GtRefactoringsPreviewButton,
	#superclass : #BrButton,
	#instVars : [
		'refactorings'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #initialization }
GtRefactoringsPreviewButton >> buildRefactoringsPreview [
	| theRefactoringsElement anAcceptButton aContainer |

	theRefactoringsElement := GtRefactoringsElement new
		hExact: self previewWidth * 1.25;
		vFitContent;
		refactorings: self refactorings.

	anAcceptButton := BrButton new
		icon: BrGlamorousIcons accept asElement;
		beSmall;
		look: BrGlamorousButtonWithIconLook new;
		label: 'Apply';
		margin: (BlInsets top: 0 left: 10 bottom: 10 right: 0);
		action: [
			self fireEvent: (BrDropdownHideWish new anchor: self).
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

{ #category : #initialization }
GtRefactoringsPreviewButton >> initialize [
	super initialize.
	
	refactorings := [ #() ].
	
	self
		icon: BrGlamorousIcons accept;
		beSmall;
		look: BrGlamorousButtonWithIconLook new + (BrGlamorousWithDropdownLook
			handle: [ BrButton new
				icon: BrGlamorousIcons empty asElement;
				beSmall;
				look: BrGlamorousButtonRectangularLook new + BrGlamorousButtonIconLook new ]
			content: [ self buildRefactoringsPreview ]);
		label: 'Apply'
]

{ #category : #initialization }
GtRefactoringsPreviewButton >> previewWidth [
	^ self isAttachedToSceneGraph
		ifTrue: [ (self topMostParent extent / 2.0) x ]
		ifFalse: [ 500 ]
]

{ #category : #accessing }
GtRefactoringsPreviewButton >> refactorings [
	^ refactorings value
]

{ #category : #accessing }
GtRefactoringsPreviewButton >> refactorings: aBlock [
	refactorings := aBlock
]
