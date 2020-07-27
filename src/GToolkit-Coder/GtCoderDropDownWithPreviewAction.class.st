Class {
	#name : #GtCoderDropDownWithPreviewAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'changeAction',
		'changeStencil'
	],
	#category : #'GToolkit-Coder-GToolkit-Coder'
}

{ #category : #ui }
GtCoderDropDownWithPreviewAction >> buildElementIn: aCoderActionsElement [
	^ GtPreviewChangeButton new
		icon: self icon;
		label: self title;
		changeAction: self changeAction;
		changeStencil:
			(self changeStencil isBlock
				ifTrue: [ self changeStencil asStencil arguments: {aCoderActionsElement} ]
				ifFalse: [ self changeStencil ])
]

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
