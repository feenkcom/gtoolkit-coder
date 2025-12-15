Class {
	#name : #GtFilterParametersElement,
	#superclass : #GtFilterSettingsElement,
	#category : 'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #'api - filter view model' }
GtFilterParametersElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.
	self updateElement
]

{ #category : #'private - updating' }
GtFilterParametersElement >> updateElement [
	| someParameters someElements |
	someParameters := self filterViewModel parameters.

	self removeChildren.
	
	someParameters 
		ifEmpty: [ 
			self visibility: BlVisibility gone.
			^ self ]
		ifNotEmpty: [ 
			self visibility: BlVisibility visible ].
	
	true ifTrue: [ ^ self ].
	
	someElements := someParameters collect: #asUserParametersElement.
	self addChildren: someElements
]
