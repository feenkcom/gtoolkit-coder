Class {
	#name : #GtFilterModelItemsChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'itemsBuilder'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterModelItemsChanged >> items [
	^ itemsBuilder create
]

{ #category : #accessing }
GtFilterModelItemsChanged >> itemsBuilder [
	^ itemsBuilder
]

{ #category : #accessing }
GtFilterModelItemsChanged >> itemsBuilder: aBuilder [
	itemsBuilder := aBuilder
]
