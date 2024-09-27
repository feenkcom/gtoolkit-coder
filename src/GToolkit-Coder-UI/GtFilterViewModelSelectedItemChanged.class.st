Class {
	#name : #GtFilterViewModelSelectedItemChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'selectedItem'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterViewModelSelectedItemChanged >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
GtFilterViewModelSelectedItemChanged >> selectedItem: anObject [
	selectedItem := anObject
]
