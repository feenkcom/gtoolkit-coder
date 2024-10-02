Class {
	#name : #GtFilterViewModelItemsChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'itemsBuilder'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterViewModelItemsChanged >> items [
	^ itemsBuilder create
]

{ #category : #accessing }
GtFilterViewModelItemsChanged >> itemsBuilder [
	^ itemsBuilder
]

{ #category : #accessing }
GtFilterViewModelItemsChanged >> itemsBuilder: aBuilder [
	itemsBuilder := aBuilder
]
