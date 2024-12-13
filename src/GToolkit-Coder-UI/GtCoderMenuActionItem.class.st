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

{ #category : #'event handling' }
GtCoderMenuActionItem >> onClick: anEvent element: anElement model: aButtonModel [
	self coderContextMenuAction ifNil: [ ^ self ].	
	self coderContextMenuAction action ifNotNil: [ :anAction |
		anAction gtValueWithArgs: { 
			textualCoderEditorElement textualCoderViewModel. 
			textualCoderEditorElement.
			anEvent } ].
	self hideOnClick ifTrue: [ self hideAll ]
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
