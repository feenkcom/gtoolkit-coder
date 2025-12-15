Class {
	#name : #GtFilterSelectableItemModel,
	#superclass : #GtFilterModel,
	#traits : 'TGtWithFilterModelParameters + TGtWithSelectableItem',
	#classTraits : 'TGtWithFilterModelParameters classTrait + TGtWithSelectableItem classTrait',
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #testing }
GtFilterSelectableItemModel class >> isAbstract [
	^ self name = #GtFilterSelectableItemModel
]

{ #category : #testing }
GtFilterSelectableItemModel >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	<return: #Boolean>
	^ self selectedItem 
		ifSome: [ true ] 
		ifNone: [ self parameters anySatisfy: #changesFilteredResult ]
]

{ #category : #'private - notifying' }
GtFilterSelectableItemModel >> notifyItemsChanged [
	self
		announce: (GtFilterModelItemsChanged new
				model: self;
				itemsBuilder: self itemsBuilder)
]

{ #category : #'private - notifying' }
GtFilterSelectableItemModel >> notifySelectedItemChanged [
	self
		announce: (GtFilterModelSelectedItemChanged new
				model: self;
				selectedItem: self selectedItem)
]
