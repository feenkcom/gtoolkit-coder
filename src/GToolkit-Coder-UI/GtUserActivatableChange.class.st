Class {
	#name : #GtUserActivatableChange,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'change',
		'changes',
		'refactoring',
		'isEnabled',
		'isExpanded'
	],
	#category : #'GToolkit-Coder-UI-Refactoring'
}

{ #category : #'instance creation' }
GtUserActivatableChange class >> fromChange: aRBRefactoryChange [
	^ self new fromChange: aRBRefactoryChange
]

{ #category : #accessing }
GtUserActivatableChange >> allChanges [
	^ { self }, (self changes flatCollect: #allChanges)
]

{ #category : #accessing }
GtUserActivatableChange >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtUserActivatableChange >> asElement [
	^ self elementClass fromActivatableChange: self
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

{ #category : #converting }
GtUserActivatableChange >> elementClass [
	^ GtUserActivatableChangeWithExpanderElement
]

{ #category : #'instance creation' }
GtUserActivatableChange >> fromChange: anRBRefactoryChange [
	change := anRBRefactoryChange.
	changes := change gtChildren collect: [ :eachChange | self class fromChange: eachChange ].
	isEnabled := true
]

{ #category : #testing }
GtUserActivatableChange >> hasDiff [
	^ self change respondsTo: #gtDiff
]

{ #category : #initialization }
GtUserActivatableChange >> initialize [
	super initialize.
	
	isEnabled := false.
	isExpanded := false
]

{ #category : #testing }
GtUserActivatableChange >> isChange [
	^ true
]

{ #category : #accessing }
GtUserActivatableChange >> isEnabled [
	^ isEnabled
]

{ #category : #accessing }
GtUserActivatableChange >> isEnabled: aBoolean [
	isEnabled = aBoolean
		ifTrue: [ ^ self ].

	self setEnabledWithoutRefactoring: aBoolean.
	self refactoring changeStateChanged
]

{ #category : #accessing }
GtUserActivatableChange >> isExpanded [
	^ isExpanded
]

{ #category : #accessing }
GtUserActivatableChange >> isExpanded: anObject [
	isExpanded := anObject
]

{ #category : #testing }
GtUserActivatableChange >> isRefactoring [
	^ false
]

{ #category : #private }
GtUserActivatableChange >> onEnablementStateChanged [
	announcer ifNotNil: [ announcer announce: #enablementChanged ]
]

{ #category : #printing }
GtUserActivatableChange >> printOn: aStream [
	aStream print: self change
]

{ #category : #accessing }
GtUserActivatableChange >> refactoring [
	^ refactoring
]

{ #category : #accessing }
GtUserActivatableChange >> refactoring: anObject [
	refactoring := anObject.
	self changes do: [ :eachChange | eachChange refactoring: self refactoring ]
]

{ #category : #accessing }
GtUserActivatableChange >> setEnabledWithoutRefactoring: aBoolean [
	isEnabled = aBoolean
		ifTrue: [ ^ self ].

	isEnabled := aBoolean.
	self onEnablementStateChanged
]
