Class {
	#name : #GtCoderCustomAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'stencil'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #initialization }
GtCoderCustomAction >> computeActionDefinition [
	self stencil isClosure
		ifTrue: [ ^ GtCoderActionClosureDefinition new closure: self stencil ].
	^ nil
]

{ #category : #accessing }
GtCoderCustomAction >> stencil [

	^ stencil
]

{ #category : #accessing }
GtCoderCustomAction >> stencil: anObject [

	stencil := anObject
]
