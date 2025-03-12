"
Use {{gtClass:GtCoderDropDownMenuAction}} instead.
"
Class {
	#name : #GtCoderDropDownAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'stencil'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #initialization }
GtCoderDropDownAction >> computeActionDefinition [
	self stencil isClosure
		ifTrue: [ ^ GtCoderActionClosureDefinition new closure: self stencil ].
	^ nil
]

{ #category : #accessing }
GtCoderDropDownAction >> stencil [
	^ stencil
]

{ #category : #accessing }
GtCoderDropDownAction >> stencil: anObject [
	stencil := anObject
]
