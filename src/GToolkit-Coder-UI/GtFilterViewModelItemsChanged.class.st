Class {
	#name : #GtFilterViewModelItemsChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterViewModelItemsChanged >> items [
	^ items
]

{ #category : #accessing }
GtFilterViewModelItemsChanged >> items: anObject [
	items := anObject
]
