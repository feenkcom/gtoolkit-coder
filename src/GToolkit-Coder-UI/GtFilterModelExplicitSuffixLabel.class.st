Class {
	#name : #GtFilterModelExplicitSuffixLabel,
	#superclass : #GtFilterModelLabel,
	#instVars : [
		'label'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModelExplicitSuffixLabel >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	^ self class = anObject class and: [ self label = anObject label ]
]

{ #category : #comparing }
GtFilterModelExplicitSuffixLabel >> hash [
	^ self class hash bitXor: self label hash
]

{ #category : #accessing }
GtFilterModelExplicitSuffixLabel >> label [
	^ label
]

{ #category : #accessing }
GtFilterModelExplicitSuffixLabel >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtFilterModelExplicitSuffixLabel >> labelElementClass [
	^ GtFilterSuffixLabelElement
]
