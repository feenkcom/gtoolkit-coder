Class {
	#name : #GtCoderDropDownWithPreviewAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'changeAction',
		'changeStencil'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderDropDownWithPreviewAction >> changeAction [
	^ changeAction
]

{ #category : #accessing }
GtCoderDropDownWithPreviewAction >> changeAction: aBlock [
	changeAction := aBlock
]

{ #category : #accessing }
GtCoderDropDownWithPreviewAction >> changeStencil [
	^ changeStencil
]

{ #category : #accessing }
GtCoderDropDownWithPreviewAction >> changeStencil: aBlock [
	changeStencil := aBlock
]
