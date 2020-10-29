"
!Coder UI Model
Wraps ${class:GtCoderModel}$ and optionally adds UI related api and state. Coder UI Model should be passed to any Coder UI element instead of the ${class:GtCoderModel}$
"
Class {
	#name : #GtCoderUIModel,
	#superclass : #Object,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtCoderUIModel >> announcer [
	^ coder announcer
]

{ #category : #accessing }
GtCoderUIModel >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderUIModel >> coder: anObject [
	coder := anObject
]

{ #category : #accessing }
GtCoderUIModel >> coderLook [
	^ self coder coderLook
]

{ #category : #accessing }
GtCoderUIModel >> coders [
	^ self coder coders
]

{ #category : #accessing }
GtCoderUIModel >> expanded [
	^ coder expanded
]

{ #category : #accessing }
GtCoderUIModel >> expanded: aBoolean [
	self coder expanded: aBoolean
]
