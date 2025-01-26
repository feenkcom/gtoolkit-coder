Class {
	#name : #GtCoderMenuActionItem,
	#superclass : #BrMenuActionItem,
	#instVars : [
		'textualCoderEditorElement'
	],
	#category : #'GToolkit-Coder-UI-Coder - Addons'
}

{ #category : #visiting }
GtCoderMenuActionItem >> acceptVisitor: aVisitor [
	^ aVisitor visitCoderMenuActionItem: self
]

{ #category : #accessing }
GtCoderMenuActionItem >> coderContextMenuAction [
	<return: #GtCoderContextMenuAction>
	^ self action
]

{ #category : #accessing }
GtCoderMenuActionItem >> coderContextMenuAction: aCoderContextMenuAction [
	self action: aCoderContextMenuAction.
	self id: aCoderContextMenuAction id.
	aCoderContextMenuAction group ifNotNil: [ :aGroup | 
		self group: aGroup ].
	aCoderContextMenuAction shortcutKey
		ifNotEmpty: [ self label: aCoderContextMenuAction title shortcut: aCoderContextMenuAction shortcutKey ]
		ifEmpty: [ self label: aCoderContextMenuAction title ]
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
