Class {
	#name : #GtFilterShortListViewModelSelectedItemChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'selectedItem'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterShortListViewModelSelectedItemChanged >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
GtFilterShortListViewModelSelectedItemChanged >> selectedItem: anObject [
	selectedItem := anObject
]
