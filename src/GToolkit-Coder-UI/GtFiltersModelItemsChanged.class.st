Class {
	#name : #GtFiltersModelItemsChanged,
	#superclass : #GtFiltersModelAnnouncement,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFiltersModelItemsChanged >> items [
	^ items
]

{ #category : #accessing }
GtFiltersModelItemsChanged >> items: anObject [
	items := anObject
]
