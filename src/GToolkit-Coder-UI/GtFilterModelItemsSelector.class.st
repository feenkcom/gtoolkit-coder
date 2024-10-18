Class {
	#name : #GtFilterModelItemsSelector,
	#superclass : #Object,
	#instVars : [
		'filterModel'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelItemsSelector >> filterModel [
	^ filterModel
]

{ #category : #accessing }
GtFilterModelItemsSelector >> filterModel: anObject [
	filterModel := anObject
]

{ #category : #accessing }
GtFilterModelItemsSelector >> items [
	<return: #Collection of: #GtFilterModelItem>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtFilterModelItemsSelector >> selectedItem [
	^ self filterModel selectedItem
]
