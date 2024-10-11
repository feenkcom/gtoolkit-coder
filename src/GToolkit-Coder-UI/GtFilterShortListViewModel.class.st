Class {
	#name : #GtFilterShortListViewModel,
	#superclass : #GtFilterSelectableItemViewModel,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterShortListViewModel >> filterElementClass [
	^ GtFilterShortListSettingsElement
]

{ #category : #accessing }
GtFilterShortListViewModel >> itemsWithoutSelection [
	<return: #Collection of: #GtFilterModelItem>
	^ self filterModel items select: [ :each | self selectedItem ~= each ]
]
