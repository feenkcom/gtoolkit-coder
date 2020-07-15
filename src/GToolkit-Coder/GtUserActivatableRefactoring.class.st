Class {
	#name : #GtUserActivatableRefactoring,
	#superclass : #Object,
	#instVars : [
		'refactoring',
		'refactoringChanges',
		'changes',
		'isEnabled',
		'dangers'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #'instance creation' }
GtUserActivatableRefactoring class >> fromRefactoring: aRBRefactoring [
	^ self new fromRefactoring: aRBRefactoring
]

{ #category : #accessing }
GtUserActivatableRefactoring >> allChanges [
	^ self changes flatCollect: #allChanges
]

{ #category : #converting }
GtUserActivatableRefactoring >> asElement [
	^ GtUserActivatableRefactoringElement fromActivatableRefactoring: self
]

{ #category : #accessing }
GtUserActivatableRefactoring >> changes [
	<return: #Collection of: #GtUserActivatableChange>

	^ changes
]

{ #category : #private }
GtUserActivatableRefactoring >> computeInterestingChanges: aRefactoryChange [	
	self
		assert: [ aRefactoryChange class = RBCompositeRefactoryChange ]
		description: [ 'We assume that changes returned by the refactoring is a composite change' ].
	
	^ (aRefactoryChange gtChildren collect: [ :eachRefactoryChange | GtUserActivatableChange fromChange: eachRefactoryChange ])
]

{ #category : #private }
GtUserActivatableRefactoring >> computeRefactoringChanges: aRBRefactoring [
	[ aRBRefactoring gtTransform ]
		on: Error
		do: [ :e | dangers := dangers copyWith: (GtRefactoringDanger new description: e description) ].	

	^ aRBRefactoring changes
]

{ #category : #private }
GtUserActivatableRefactoring >> computeRefactoringDangers: aRBRefactoring [
	^ aRBRefactoring gtDangers
]

{ #category : #accessing }
GtUserActivatableRefactoring >> dangers [
	^ dangers
]

{ #category : #accessing }
GtUserActivatableRefactoring >> description [
	^ self refactoring gtDescription
]

{ #category : #execution }
GtUserActivatableRefactoring >> execute [
	self isEnabled
		ifFalse: [ ^ self ].

	RBRefactoryChangeManager instance performChange: refactoringChanges; addUndoPointer: 1
]

{ #category : #initialization }
GtUserActivatableRefactoring >> fromRefactoring: anRBRefactoring [
	refactoring := anRBRefactoring.

	dangers := self computeRefactoringDangers: refactoring.
	refactoringChanges := self computeRefactoringChanges: refactoring.
	changes := self computeInterestingChanges: refactoringChanges.
	
	isEnabled := dangers isEmpty
]

{ #category : #accessing }
GtUserActivatableRefactoring >> isDangerous [
	^ dangers isNotEmpty
]

{ #category : #accessing }
GtUserActivatableRefactoring >> isEnabled [
	^ isEnabled
]

{ #category : #accessing }
GtUserActivatableRefactoring >> isEnabled: aBoolean [
	isEnabled := aBoolean
]

{ #category : #accessing }
GtUserActivatableRefactoring >> refactoring [
	^ refactoring
]
