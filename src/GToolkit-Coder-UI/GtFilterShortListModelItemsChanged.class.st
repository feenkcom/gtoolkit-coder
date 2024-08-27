Class {
	#name : #GtFilterShortListModelItemsChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterShortListModelItemsChanged >> items [
	^ items
]

{ #category : #accessing }
GtFilterShortListModelItemsChanged >> items: anObject [
	items := anObject
]
