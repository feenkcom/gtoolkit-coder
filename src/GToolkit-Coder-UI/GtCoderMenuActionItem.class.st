Class {
	#name : #GtCoderMenuActionItem,
	#superclass : #BrMenuActionItem,
	#instVars : [
		'textualCoderEditorElement'
	],
	#category : #'GToolkit-Coder-UI-Coder - Addons'
}

{ #category : #accessing }
GtCoderMenuActionItem >> coderContextMenuAction [
	<return: #GtCoderContextMenuAction>
	^ self action
]

{ #category : #accessing }
GtCoderMenuActionItem >> coderContextMenuAction: anAction [
	self action: anAction.
	self id: anAction id.
	anAction shortcutKey
		ifNotEmpty: [ self label: anAction title shortcut: anAction shortcutKey ]
		ifEmpty: [ self label: anAction title ]
]

{ #category : #'api - converting' }
GtCoderMenuActionItem >> elementType [
	^ GtCoderMenuActionItemElement
]

{ #category : #'as yet unclassified' }
GtCoderMenuActionItem >> hoverAction [
	^ self coderContextMenuAction hoverAction
]

{ #category : #'as yet unclassified' }
GtCoderMenuActionItem >> leaveAction [
	^ self coderContextMenuAction leaveAction
]

{ #category : #accessing }
GtCoderMenuActionItem >> textualCoderEditorElement [
	<return: #GtTextualCoderEditorElement>
	^ textualCoderEditorElement
]

{ #category : #accessing }
GtCoderMenuActionItem >> textualCoderEditorElement: aCoderElement [
	textualCoderEditorElement := aCoderElement
]

{ #category : #accessing }
GtCoderMenuActionItem >> textualCoderViewModel [
	^ self textualCoderEditorElement textualCoderViewModel
]
