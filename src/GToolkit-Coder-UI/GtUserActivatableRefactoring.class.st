Class {
	#name : #GtUserActivatableRefactoring,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'refactoring',
		'refactoringChanges',
		'changes',
		'dangers',
		'enablementState'
	],
	#category : #'GToolkit-Coder-UI-Refactoring'
}

{ #category : #'instance creation' }
GtUserActivatableRefactoring class >> fromRefactoring: aRBRefactoring [
	^ self new fromRefactoring: aRBRefactoring
]

{ #category : #accessing }
GtUserActivatableRefactoring >> allChanges [
	^ self changes flatCollect: #allChanges
]

{ #category : #accessing }
GtUserActivatableRefactoring >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtUserActivatableRefactoring >> asElement [
	^ self elementClass fromActivatableRefactoring: self
]

{ #category : #private }
GtUserActivatableRefactoring >> changeStateChanged [
	| hasEnabled hasDisabled |
	
	hasEnabled := false.
	hasDisabled := false.
	
	self allChanges do: [ :eachChange |
		hasEnabled := hasEnabled or: eachChange isEnabled.
		hasDisabled := hasDisabled or: eachChange isEnabled not ].
	
	self enablementState: ((hasEnabled and: [ hasDisabled ])
		ifTrue: [ BrCheckboxState indeterminate ]
		ifFalse: [
			hasEnabled
				ifTrue: [ BrCheckboxState checked ]
				ifFalse: [ BrCheckboxState unchecked ] ])
]

{ #category : #accessing }
GtUserActivatableRefactoring >> changes [
	<return: #Collection of: #GtUserActivatableChange>

	^ changes
]

{ #category : #private }
GtUserActivatableRefactoring >> computeActivatedRefactoringChange [
	
]

{ #category : #private }
GtUserActivatableRefactoring >> computeInterestingChanges: aRefactoryChange [	
	self
		assert: [ aRefactoryChange class = RBCompositeRefactoryChange ]
		description: [ 'We assume that changes returned by the refactoring is a composite change' ].
	
	^ (aRefactoryChange gtChildren collect: [ :eachRefactoryChange | (GtUserActivatableChange fromChange: eachRefactoryChange) refactoring: self ])
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

{ #category : #converting }
GtUserActivatableRefactoring >> elementClass [
	^ GtUserActivatableRefactoringElement
]

{ #category : #accessing }
GtUserActivatableRefactoring >> enablementState [
	^ enablementState
]

{ #category : #accessing }
GtUserActivatableRefactoring >> enablementState: aBrCheckboxState [
	enablementState = aBrCheckboxState
		ifTrue: [ ^ self ].
		
	enablementState := aBrCheckboxState.
	self onEnablementStateChanged.

	self isIndeterminate
		ifFalse: [ self allChanges do: [ :eachChange | eachChange setEnabledWithoutRefactoring: self isEnabled ] ]
]

{ #category : #execution }
GtUserActivatableRefactoring >> execute [
	| aCompositeChange theChanges |

	self isDisabled
		ifTrue: [ ^ self ].

	aCompositeChange := RBCompositeRefactoryChange new.
	theChanges := self allChanges
		select: [ :eachChange | eachChange isEnabled ]
		thenCollect: [ :eachChange | eachChange change gtWithoutChanges ].

	aCompositeChange changes: theChanges.

	RBRefactoryChangeManager instance
		performChange: aCompositeChange;
		addUndoPointer: 1
]

{ #category : #initialization }
GtUserActivatableRefactoring >> fromRefactoring: anRBRefactoring [
	refactoring := anRBRefactoring.

	dangers := self computeRefactoringDangers: refactoring.
	refactoringChanges := self computeRefactoringChanges: refactoring.
	changes := self computeInterestingChanges: refactoringChanges.

	self isEnabled: dangers isEmpty
]

{ #category : #testing }
GtUserActivatableRefactoring >> isChange [
	^ false
]

{ #category : #accessing }
GtUserActivatableRefactoring >> isDangerous [
	^ dangers isNotEmpty
]

{ #category : #testing }
GtUserActivatableRefactoring >> isDisabled [
	^ enablementState isUnchecked
]

{ #category : #testing }
GtUserActivatableRefactoring >> isEnabled [
	^ enablementState isChecked
]

{ #category : #accessing }
GtUserActivatableRefactoring >> isEnabled: aBoolean [
	self enablementState: (aBoolean
		ifTrue: [ BrCheckboxState checked ]
		ifFalse: [ BrCheckboxState unchecked ])
]

{ #category : #testing }
GtUserActivatableRefactoring >> isIndeterminate [
	^ enablementState isIndeterminate
]

{ #category : #testing }
GtUserActivatableRefactoring >> isRefactoring [
	^ true
]

{ #category : #private }
GtUserActivatableRefactoring >> onEnablementStateChanged [
	announcer ifNotNil: [ announcer announce: #enablementChanged ]
]

{ #category : #accessing }
GtUserActivatableRefactoring >> refactoring [
	^ refactoring
]
