Class {
	#name : #GtCoderSidebarVisibilityWish,
	#superclass : #BrWish,
	#instVars : [
		'isVisible'
	],
	#category : 'GToolkit-Coder-UI-Basic'
}

{ #category : #accessing }
GtCoderSidebarVisibilityWish >> isVisible [
	^ isVisible ifNil: [ false ]
]

{ #category : #accessing }
GtCoderSidebarVisibilityWish >> isVisible: anObject [
	isVisible := anObject
]
