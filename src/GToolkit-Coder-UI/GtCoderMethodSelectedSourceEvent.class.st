"
I am a helper event to indicate whether a selection happened due to a user click or changes in a model. 
In other words, {{gtClass:GtCoderMethodsGroupedListElement}} does nothing if a selection is triggered from its {{gtClass:GtCoderNavigationModel}}. 

I am instantiated in {{gtMethod:GtCoderMethodsGroupedListElement>>#onMethodSelected:}}  and checked in {{gtMethod:GtCoderMethodsGroupedListElement>>#onMethodsListSelectionChanged:}}. 

"
Class {
	#name : #GtCoderMethodSelectedSourceEvent,
	#superclass : #BlEvent,
	#instVars : [
		'originalSource'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #accessing }
GtCoderMethodSelectedSourceEvent >> originalSource [
	^ originalSource
]

{ #category : #accessing }
GtCoderMethodSelectedSourceEvent >> originalSource: anObject [
	originalSource := anObject
]
