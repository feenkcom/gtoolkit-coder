Class {
	#name : #GtFilterToggleViewModel,
	#superclass : #GtFilterSelectableItemViewModel,
	#category : 'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterToggleViewModel >> filterElementClass [
	<return: #'GtFilterSettingsElement class'>
	^ GtFilterToggleSettingsElement
]
