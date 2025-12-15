Class {
	#name : #GtFilterModelSelectedItemChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'selectedItem'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #testing }
GtFilterModelSelectedItemChanged >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	^ true
]

{ #category : #accessing }
GtFilterModelSelectedItemChanged >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
GtFilterModelSelectedItemChanged >> selectedItem: anObject [
	selectedItem := anObject
]
