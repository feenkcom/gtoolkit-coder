Class {
	#name : #GtFilterShortListModelParameter,
	#superclass : #GtFilterSelectableItemModelParameter,
	#traits : 'TGtWithItemsSelector',
	#classTraits : 'TGtWithItemsSelector classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterShortListModelParameter >> filterViewModelClass [
	^ GtFilterShortListViewModel
]
