Class {
	#name : #GtCoderDropDownMenuAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'group',
		'menuBlock'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #initialization }
GtCoderDropDownMenuAction >> computeActionDefinition [
	self menuBlock isClosure
		ifTrue: [ ^ GtCoderActionClosureDefinition new closure: self menuBlock ].
	^ nil
]

{ #category : #accessing }
GtCoderDropDownMenuAction >> content: aBlock [
	self actionDefinitionFromBlock: aBlock.
	self menu: [ BrMenuExplicit new stencil: aBlock ]
]

{ #category : #accessing }
GtCoderDropDownMenuAction >> group [
	<return: #BrMenuItemGroupConfiguration or: nil>
	^ group
]

{ #category : #accessing }
GtCoderDropDownMenuAction >> group: aMenuItemGroupConfiguration [
	group := aMenuItemGroupConfiguration
]

{ #category : #accessing }
GtCoderDropDownMenuAction >> items: aBlock [
	self actionDefinitionFromBlock: aBlock.
	self
		menu: [ BrMenuItems new
				in: [ :theMenuItems | aBlock cull: theMenuItems ];
				yourself ]
]

{ #category : #accessing }
GtCoderDropDownMenuAction >> menu: aBlock [
	"The block can have two arguments: [ :aTextualCoderViewModel :aTextualCoderEditorElement | ].
	The block returns BrMenu."

	menuBlock := aBlock
]

{ #category : #accessing }
GtCoderDropDownMenuAction >> menuBlock [
	^ menuBlock
]
