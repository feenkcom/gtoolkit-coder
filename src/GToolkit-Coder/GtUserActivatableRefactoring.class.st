Class {
	#name : #GtUserActivatableRefactoring,
	#superclass : #Object,
	#instVars : [
		'refactoring',
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
GtUserActivatableRefactoring >> computeRefactoringChanges: aRBRefactoring [
	| theChanges |

	[ aRBRefactoring transform ] on: Error do: [ :e | ].	
	theChanges := aRBRefactoring changes.
	
	self
		assert: [ theChanges class = RBCompositeRefactoryChange ]
		description: [ 'We assume that changes returned by the refactoring is a composite change' ].
	
	^ (theChanges gtChildren collect: [ :eachRefactoryChange | GtUserActivatableChange fromChange: eachRefactoryChange ])
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

{ #category : #initialization }
GtUserActivatableRefactoring >> fromRefactoring: anRBRefactoring [
	refactoring := anRBRefactoring.

	dangers := self computeRefactoringDangers: refactoring.
	changes := self computeRefactoringChanges: refactoring.
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

{ #category : #accessing }
GtUserActivatableRefactoring >> refactoring: anRBRefactoring [
	
	refactoring := anRBRefactoring.
	changes := self computeRefactoringChanges: refactoring.
	dangers := self computeRefactoringDangers: refactoring.
]
