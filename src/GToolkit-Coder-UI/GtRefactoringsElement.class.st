Class {
	#name : #GtRefactoringsElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'activatableRefactorings',
		'refactoringsList'
	],
	#category : #'GToolkit-Coder-UI-Refactoring'
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
	activatableRefactorings
		do: [ :eachRefactoring | eachRefactoring execute ]
]

{ #category : #initialization }
GtRefactoringsElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout vertical.
	self matchParent.
	self padding: (BlInsets all: 10).
	
	refactoringsList := BrSimpleTree new.
	refactoringsList
		nodeType: [ :aTypeFactory :aTreeNode | aTreeNode value elementClass ];
		nodeStencil: [ :aNodeType | aNodeType new ];
		nodeDataBinder: [ :eachElement :eachUserActivatableRefactoring |
			eachUserActivatableRefactoring isRefactoring
				ifTrue: [ (eachElement activatableRefactoring: eachUserActivatableRefactoring) ]
				ifFalse: [ (eachElement activatableChange: eachUserActivatableRefactoring) ] ].	

	self addLook: (BrLayoutResizerLook inherit inherit: refactoringsList).
	
	self addChild: refactoringsList
]

{ #category : #accessing }
GtRefactoringsElement >> refactorings: aCollectionOfRBRefactorings [
	activatableRefactorings := (aCollectionOfRBRefactorings
		collect: [ :eachRefactoring | self activatableRefactoring: eachRefactoring ])
		sorted: [ :a :b | a isDangerous ].

	refactoringsList
		items: activatableRefactorings
		lazy: [ :eachUserActivatableChangeOrRefactoring |
			eachUserActivatableChangeOrRefactoring isRefactoring
				ifTrue: [ eachUserActivatableChangeOrRefactoring allChanges ]
				ifFalse: [ #() ] ]
]
