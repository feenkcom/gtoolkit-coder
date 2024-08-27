Class {
	#name : #GtFilterTextViewModelTextChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterTextViewModelTextChanged >> text [
	^ text
]

{ #category : #accessing }
GtFilterTextViewModelTextChanged >> text: anObject [
	text := anObject
]
