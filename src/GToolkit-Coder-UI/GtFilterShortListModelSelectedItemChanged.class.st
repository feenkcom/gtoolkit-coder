Class {
	#name : #GtFilterShortListModelSelectedItemChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'selectedItem'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterShortListModelSelectedItemChanged >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
GtFilterShortListModelSelectedItemChanged >> selectedItem: anObject [
	selectedItem := anObject
]
