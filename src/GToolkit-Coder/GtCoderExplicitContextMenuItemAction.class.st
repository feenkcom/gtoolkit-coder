Class {
	#name : #GtCoderExplicitContextMenuItemAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'menuItemBlock',
		'group'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderExplicitContextMenuItemAction >> group [
	<return: #BrMenuItemGroupConfiguration or: nil>
	^ group
]

{ #category : #accessing }
GtCoderExplicitContextMenuItemAction >> group: aMenuItemGroupConfiguration [
	group := aMenuItemGroupConfiguration
]

{ #category : #accessing }
GtCoderExplicitContextMenuItemAction >> menuItem: aBlock [
	"Set block that creates a menu item, an instance of `BrMenuItem`.
	The block have two arguments [ :aTextualCoderEditorElement :aTextualCoderViewModel :aCoderAction | ]"

	menuItemBlock := aBlock
]
