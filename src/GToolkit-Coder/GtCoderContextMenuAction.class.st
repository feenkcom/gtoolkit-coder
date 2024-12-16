Class {
	#name : #GtCoderContextMenuAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'hoverAction',
		'leaveAction',
		'group'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderContextMenuAction >> group [
	<return: #BrMenuItemGroupConfiguration or: nil>
	^ group
]

{ #category : #accessing }
GtCoderContextMenuAction >> group: aMenuItemGroupConfiguration [
	group := aMenuItemGroupConfiguration
]

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
