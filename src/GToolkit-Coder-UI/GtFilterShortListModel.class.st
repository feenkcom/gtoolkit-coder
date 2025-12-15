Class {
	#name : #GtFilterShortListModel,
	#superclass : #GtFilterSelectableItemModel,
	#traits : 'TGtWithItemsSelector',
	#classTraits : 'TGtWithItemsSelector classTrait',
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterShortListModel >> filterViewModelClass [
	^ GtFilterShortListViewModel
]
