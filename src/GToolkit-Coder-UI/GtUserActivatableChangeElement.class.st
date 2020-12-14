Class {
	#name : #GtUserActivatableChangeElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'activatableChange'
	],
	#category : #'GToolkit-Coder-UI-Refactoring'
}

{ #category : #'instance creation' }
GtUserActivatableChangeElement class >> fromActivatableChange: aGtUserActivatableChange [
	^ self new activatableChange: aGtUserActivatableChange
]

{ #category : #'instance creation' }
GtUserActivatableChangeElement >> activatableChange: aGtUserActivatableChange [
	self removeChildren.

	activatableChange := aGtUserActivatableChange.
	
	self addChild: ((aGtUserActivatableChange hasDiff)
		ifTrue: [ aGtUserActivatableChange change gtDiff asElement vFitContent beSmallSize ]
		ifFalse: [ BrLabel new
				look: BrGlamorousLabelLook new;
				text: aGtUserActivatableChange change displayString ])
]

{ #category : #initialization }
GtUserActivatableChangeElement >> initialize [
	super initialize.
	
	self hMatchParent.
	self vFitContent.
	
	
]
