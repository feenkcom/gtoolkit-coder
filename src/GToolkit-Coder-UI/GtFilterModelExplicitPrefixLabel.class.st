Class {
	#name : #GtFilterModelExplicitPrefixLabel,
	#superclass : #GtFilterModelLabel,
	#instVars : [
		'label'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModelExplicitPrefixLabel >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	^ self class = anObject class and: [ self label = anObject label ]
]

{ #category : #comparing }
GtFilterModelExplicitPrefixLabel >> hash [
	^ self class hash bitXor: self label hash
]

{ #category : #accessing }
GtFilterModelExplicitPrefixLabel >> label [
	^ label
]

{ #category : #accessing }
GtFilterModelExplicitPrefixLabel >> label: anObject [
	label := anObject
]
