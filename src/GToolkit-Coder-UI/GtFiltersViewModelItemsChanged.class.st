Class {
	#name : #GtFiltersViewModelItemsChanged,
	#superclass : #GtFiltersViewModelAnnouncement,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFiltersViewModelItemsChanged >> items [
	^ items
]

{ #category : #accessing }
GtFiltersViewModelItemsChanged >> items: anObject [
	items := anObject
]
