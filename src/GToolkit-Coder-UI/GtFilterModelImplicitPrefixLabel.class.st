Class {
	#name : #GtFilterModelImplicitPrefixLabel,
	#superclass : #GtFilterModelLabel,
	#instVars : [
		'model'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModelImplicitPrefixLabel >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	^ self class = anObject class and: [ self model = anObject model ]
]

{ #category : #comparing }
GtFilterModelImplicitPrefixLabel >> hash [
	^ self class hash bitXor: self model hash
]

{ #category : #'as yet unclassified' }
GtFilterModelImplicitPrefixLabel >> label [
	^ self model name
]

{ #category : #accessing }
GtFilterModelImplicitPrefixLabel >> model [
	<return: #GtFilterModel>
	^ model
]

{ #category : #accessing }
GtFilterModelImplicitPrefixLabel >> model: aFilterModel [
	model := aFilterModel
]
