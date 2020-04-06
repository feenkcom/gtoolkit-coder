Class {
	#name : #GtRefactoringChangesAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'refactoring',
		'element'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #private }
GtRefactoringChangesAttribute >> applyRefactoring [
	refactoring model changes execute
]

{ #category : #private }
GtRefactoringChangesAttribute >> buildRefactoringPreview [
	| theRefactoringsPreview |
	theRefactoringsPreview := (GtRefactoringsElement new
		hExact: self previewWidth * 1.25;
		vFitContent;
		refactorings: {refactoring}) asScalableElement
		width: self previewWidth;
		fitWidth;
		constraintsDo: [ :c | c vertical fitContent ].
	^ theRefactoringsPreview asScrollableElement
]

{ #category : #accessing }
GtRefactoringChangesAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| anAcceptButton |
	element := anEditorElement.
	anAcceptButton := BrButton new
		icon: BrGlamorousIcons accept;
		beSmall;
		look:
			BrGlamorousButtonWithIconLook new
				+
					(BrGlamorousWithDropdownLook
						handle: [ BrButton new
								icon: BrGlamorousIcons empty asElement;
								beSmall;
								look: BrGlamorousButtonRectangularLook new + BrGlamorousButtonIconLook new ]
						content: [ | aContainer |
							aContainer := BlElement new
								layout: BlLinearLayout vertical;
								when: GtPhlowObjectToSpawn
									do: [ :anEvent | 
									anEditorElement
										fireEvent:
											(GtPhlowObjectToSpawn new
												object: anEvent object;
												sourceElement: anEvent target) ];
								constraintsDo: [ :c | 
									c horizontal exact: self previewWidth.
									c vertical fitContentLimitedOffset: 20 ].
							aContainer addChild: self buildRefactoringPreview.
							aContainer
								addChild:
									(BrButton new
										icon: BrGlamorousIcons accept asElement;
										beSmall;
										look: BrGlamorousButtonWithIconLook new;
										label: 'Apply';
										margin:
											(BlInsets
												top: 0
												left: 5
												bottom: 5
												right: 0);
										action: [ anAcceptButton
												fireEvent: (BrDropdownHideWish new anchor: anAcceptButton).
											self applyRefactoring ];
										yourself) ]);
		label: 'Preview'.
	^ anAcceptButton
]

{ #category : #initialization }
GtRefactoringChangesAttribute >> initialize [
	super initialize.
	self beAppend beNotOverwritableByStyler
]

{ #category : #private }
GtRefactoringChangesAttribute >> previewWidth [
	^ element isAttachedToSceneGraph
		ifTrue: [ (element topMostParent extent / 2.0) x ]
		ifFalse: [ 500 ]
]

{ #category : #accessing }
GtRefactoringChangesAttribute >> refactoring: aRBRefactoring [
	refactoring := aRBRefactoring
]
