Class {
	#name : #GtFilterRemoveFilterViewModelWish,
	#superclass : #BrWish,
	#instVars : [
		'filterViewModel'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterRemoveFilterViewModelWish >> filterViewModel [
	^ filterViewModel
]

{ #category : #accessing }
GtFilterRemoveFilterViewModelWish >> filterViewModel: anObject [
	filterViewModel := anObject
]
