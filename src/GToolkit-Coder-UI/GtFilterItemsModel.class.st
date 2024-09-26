Class {
	#name : #GtFilterItemsModel,
	#superclass : #GtFiltersModel,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #initialization }
GtFilterItemsModel >> initialize [
	super initialize.
	items := Array empty
]

{ #category : #accessing }
GtFilterItemsModel >> items [
	<return: #Collection of: #GtFilterModel>
	^ items
]

{ #category : #accessing }
GtFilterItemsModel >> items: aCollection [
	self items = aCollection ifTrue: [ ^ self ].

	items := aCollection.
	self notifyItemsChanged.
]

{ #category : #'private - notifying' }
GtFilterItemsModel >> notifyItemsChanged [
	self announce: (GtFiltersModelItemsChanged new model: self)
]
