Class {
	#name : #GtRefactoringsElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'activatableRefactorings',
		'refactoringsList'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #initialization }
GtRefactoringsElement >> initialize [
	super initialize.
	
	self viewModel: (BrInteractiveModel new addStates: {
		BrLayoutHorizontalResizerModel matchParent.
		BrLayoutVerticalResizerModel matchParent.
	}).
	
	self layout: BlLinearLayout vertical.
	self matchParent.
	
	refactoringsList := BrSimpleList new matchParent.
	refactoringsList stencil: [ :eachRefactoring | eachRefactoring asElement ].
	
	self addLook: (BrLayoutResizerLook inherit inherit: refactoringsList).
	
	self addChild: refactoringsList
]

{ #category : #accessing }
GtRefactoringsElement >> refactorings: aCollectionOfRBRefactorings [
	activatableRefactorings := (aCollectionOfRBRefactorings
		collect: [ :eachRefactoring | GtUserActivatableRefactoring fromRefactoring: eachRefactoring ])
			sorted: [ :a :b | a isDangerous ].
	
	refactoringsList
		items: activatableRefactorings
]
