Class {
	#name : #GtFilterModelItemsChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterModelItemsChanged >> items [
	^ items
]

{ #category : #accessing }
GtFilterModelItemsChanged >> items: anObject [
	items := anObject
]
