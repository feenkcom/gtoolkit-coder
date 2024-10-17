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
GtFilterShortListViewModel >> someItems [
	<return: #Collection of: #GtFilterModelItem>
	^ self filterModel someItems
]
