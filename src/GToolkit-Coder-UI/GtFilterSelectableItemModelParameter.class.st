Class {
	#name : #GtFilterSelectableItemModelParameter,
	#superclass : #GtFilterModelParameter,
	#traits : 'TGtWithSelectableItem',
	#classTraits : 'TGtWithSelectableItem classTrait',
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'private - notifying' }
GtFilterSelectableItemModelParameter >> notifyItemsChanged [
	self
		announce: (GtFilterModelItemsChanged new
				model: self;
				itemsBuilder: self itemsBuilder)
]

{ #category : #'private - notifying' }
GtFilterSelectableItemModelParameter >> notifySelectedItemChanged [
	self
		announce: (GtFilterModelSelectedItemChanged new
				model: self;
				selectedItem: self selectedItem)
]
