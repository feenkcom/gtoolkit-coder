Class {
	#name : #GtFilterTextModelTextChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterTextModelTextChanged >> text [
	^ text
]

{ #category : #accessing }
GtFilterTextModelTextChanged >> text: anObject [
	text := anObject
]
