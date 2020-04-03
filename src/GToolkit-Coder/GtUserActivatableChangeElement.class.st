Class {
	#name : #GtUserActivatableChangeElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'activatableChange'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #'instance creation' }
GtUserActivatableChangeElement class >> fromActivatableChange: aGtUserActivatableChange [
	^ self new fromActivatableChange: aGtUserActivatableChange
]

{ #category : #'instance creation' }
GtUserActivatableChangeElement >> fromActivatableChange: aGtUserActivatableChange [
	activatableChange := aGtUserActivatableChange.
	
	self addChild: ((aGtUserActivatableChange change respondsTo: #gtDiff)
		ifTrue: [ aGtUserActivatableChange change gtDiff asElement vFitContent beSmall ]
		ifFalse: [ BrLabel new
				look: BrGlamorousLabelLook new;
				text: aGtUserActivatableChange change printString ])
]

{ #category : #initialization }
GtUserActivatableChangeElement >> initialize [
	super initialize.
	
	self hMatchParent.
	self vFitContent
]
