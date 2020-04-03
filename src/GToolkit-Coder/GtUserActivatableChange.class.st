Class {
	#name : #GtUserActivatableChange,
	#superclass : #Object,
	#instVars : [
		'change',
		'changes',
		'isEnabled',
		'dangers'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #'instance creation' }
GtUserActivatableChange class >> fromChange: aRBRefactoryChange [
	^ self new fromChange: aRBRefactoryChange
]

{ #category : #accessing }
GtUserActivatableChange >> allChanges [
	^ { self }, (self changes flatCollect: #allChanges)
]

{ #category : #converting }
GtUserActivatableChange >> asElement [
	^ GtUserActivatableChangeElement fromActivatableChange: self
]

{ #category : #accessing }
GtUserActivatableChange >> change [
	^ change
]

{ #category : #accessing }
GtUserActivatableChange >> changes [
	<return: #Collection of: #GtUserActivatableChange>

	^ changes
]

{ #category : #'instance creation' }
GtUserActivatableChange >> fromChange: anRBRefactoryChange [
	change := anRBRefactoryChange.
	changes := change gtChildren collect: [ :eachChange | self class fromChange: eachChange ].
	isEnabled := true
]

{ #category : #accessing }
GtUserActivatableChange >> isEnabled [
	^ isEnabled
]

{ #category : #accessing }
GtUserActivatableChange >> isEnabled: anObject [
	isEnabled := anObject
]

{ #category : #printing }
GtUserActivatableChange >> printOn: aStream [
	aStream print: self change
]
