Class {
	#name : #GtFilterShortListViewModelItemsChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterShortListViewModelItemsChanged >> items [
	^ items
]

{ #category : #accessing }
GtFilterShortListViewModelItemsChanged >> items: anObject [
	items := anObject
]
