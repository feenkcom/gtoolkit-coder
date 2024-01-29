Class {
	#name : #GtCoderViewModelRequester,
	#superclass : #Object,
	#traits : 'TGtCoderRequesterObject',
	#classTraits : 'TGtCoderRequesterObject classTrait',
	#instVars : [
		'coderViewModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtCoderViewModelRequester >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtCoderViewModelRequester >> coderViewModel: anObject [
	coderViewModel := anObject
]

{ #category : #testing }
GtCoderViewModelRequester >> isCoderViewModel: aCoderViewModel [
	^ aCoderViewModel = self coderViewModel 
]

{ #category : #accessing }
GtCoderViewModelRequester >> selfObject [
	^ self coderViewModel selfObject
]
