Class {
	#name : #GtFilterInvariableViewModel,
	#superclass : #GtFilterViewModel,
	#category : 'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterInvariableViewModel >> filterElementClass [
	<return: #'GtFilterSettingsElement class'>
	^ GtFilterInvariableSettingsElement
]
