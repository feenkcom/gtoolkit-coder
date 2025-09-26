Class {
	#name : #GtCoderMenuSubmenuItem,
	#superclass : #BrMenuSubmenuItem,
	#instVars : [
		'textualCoderEditorElement'
	],
	#category : #'GToolkit-Coder-UI-Coder - Addons'
}

{ #category : #visiting }
GtCoderMenuSubmenuItem >> acceptVisitor: aVisitor [
	^ aVisitor visitCoderSubmenuItem: self
]

{ #category : #accessing }
GtCoderMenuSubmenuItem >> coderContextMenuAction [
	<return: #GtCoderContextMenuAction>
	^ self action
]

{ #category : #accessing }
GtCoderMenuSubmenuItem >> coderContextMenuAction: aCoderContextMenuAction [
	self action: aCoderContextMenuAction.
	self id: aCoderContextMenuAction id.
	aCoderContextMenuAction group ifNotNil: [ :aGroup | 
		self group: aGroup ].
	aCoderContextMenuAction shortcutKey
		ifNotEmpty: [ self label: aCoderContextMenuAction title shortcut: aCoderContextMenuAction shortcutKey ]
		ifEmpty: [ self label: aCoderContextMenuAction title ]
]

{ #category : #accessing }
GtCoderMenuSubmenuItem >> hoverAction [
	^ self coderContextMenuAction hoverAction
]

{ #category : #accessing }
GtCoderMenuSubmenuItem >> leaveAction [
	^ self coderContextMenuAction leaveAction
]

{ #category : #accessing }
GtCoderMenuSubmenuItem >> textualCoderEditorElement [
	<return: #GtTextualCoderEditorElement>
	^ textualCoderEditorElement
]

{ #category : #accessing }
GtCoderMenuSubmenuItem >> textualCoderEditorElement: aCoderElement [
	textualCoderEditorElement := aCoderElement
]

{ #category : #accessing }
GtCoderMenuSubmenuItem >> textualCoderViewModel [
	^ self textualCoderEditorElement textualCoderViewModel
]
