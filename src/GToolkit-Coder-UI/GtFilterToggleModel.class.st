Class {
	#name : #GtFilterToggleModel,
	#superclass : #GtFilterSelectableItemModel,
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterToggleModel >> filterViewModelClass [
	<return: #'GtFilterViewModel class'>
	^ GtFilterToggleViewModel
]
