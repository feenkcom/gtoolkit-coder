Class {
	#name : #GtFilterModelSelectedItemChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'selectedItem'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterModelSelectedItemChanged >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
GtFilterModelSelectedItemChanged >> selectedItem: anObject [
	selectedItem := anObject
]
