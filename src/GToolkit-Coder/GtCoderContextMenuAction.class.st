Class {
	#name : #GtCoderContextMenuAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'hoverAction',
		'leaveAction'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderContextMenuAction >> hoverAction [
	^ hoverAction
]

{ #category : #accessing }
GtCoderContextMenuAction >> hoverAction: aBlock [
	hoverAction := aBlock
]

{ #category : #accessing }
GtCoderContextMenuAction >> leaveAction [
	^ leaveAction
]

{ #category : #accessing }
GtCoderContextMenuAction >> leaveAction: aBlock [
	leaveAction := aBlock
]
