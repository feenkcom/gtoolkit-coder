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

{ #category : #accessing }
GtRefactoringsElement >> activatableRefactoring: aRefactoring [
	^ aRefactoring options
		at: #activatableRefactoring
		ifAbsent: [ | activatableRefactoring |
			activatableRefactoring := GtUserActivatableRefactoring
				fromRefactoring: aRefactoring.
			aRefactoring
				setOption: #activatableRefactoring
				toUse: activatableRefactoring.
			activatableRefactoring ]
]

{ #category : #'api - refactorings' }
GtRefactoringsElement >> applyRefactorings [
	activatableRefactorings do: [ :eachRefactoring |
		eachRefactoring isEnabled
			ifTrue: [ eachRefactoring execute ] ]
]

{ #category : #initialization }
GtRefactoringsElement >> initialize [
	super initialize.
	
	self viewModel: (BrInteractiveModel new addStates: {
		BrLayoutHorizontalResizerModel matchParent.
		BrLayoutVerticalResizerModel matchParent.
	}).
	
	self layout: BlLinearLayout vertical.
	self matchParent.
	self padding: (BlInsets all: 10).
	
	refactoringsList := BrSimpleList new matchParent.
	refactoringsList stencil: [ :eachRefactoring | eachRefactoring asElement ].
	
	self addLook: (BrLayoutResizerLook inherit inherit: refactoringsList).
	
	self addChild: refactoringsList
]

{ #category : #accessing }
GtRefactoringsElement >> refactorings: aCollectionOfRBRefactorings [
	activatableRefactorings := (aCollectionOfRBRefactorings
		collect: [ :eachRefactoring | self activatableRefactoring: eachRefactoring ])
		sorted: [ :a :b | a isDangerous ].
	refactoringsList items: activatableRefactorings
]
