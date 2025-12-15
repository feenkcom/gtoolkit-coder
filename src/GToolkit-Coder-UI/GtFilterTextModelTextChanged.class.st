Class {
	#name : #GtFilterTextModelTextChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'text'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #testing }
GtFilterTextModelTextChanged >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	^ true
]

{ #category : #accessing }
GtFilterTextModelTextChanged >> text [
	^ text
]

{ #category : #accessing }
GtFilterTextModelTextChanged >> text: anObject [
	text := anObject
]
