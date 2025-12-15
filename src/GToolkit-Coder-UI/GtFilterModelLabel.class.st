Class {
	#name : #GtFilterModelLabel,
	#superclass : #Object,
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelLabel >> label [
	<return: #String>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtFilterModelLabel >> labelElementClass [
	^ GtFilterPrefixLabelElement
]
