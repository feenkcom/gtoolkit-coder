"
I let to know that another method is selected in a {{gtMethod:GtPharoStreamingMethodsCoderElement}} and that this new selection should be reflected in a corresponding {{gtClass:GtCoderMethodsGroupedListElement | label=sidebar index method list}}. 

To make it happen, I am handled by {{gtMethod:GtCoderElement>>#onGtNavigationMethodSelectionWish: | label=#methodClass}}, followed by a {{gtMethod:GtCoderNavigationModel>>#selectedMethod:source:}} call.

"
Class {
	#name : #GtNavigationMethodSelectionWish,
	#superclass : #BrWish,
	#instVars : [
		'method'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #accessing }
GtNavigationMethodSelectionWish >> method [
	^ method
]

{ #category : #accessing }
GtNavigationMethodSelectionWish >> method: anObject [
	method := anObject
]
