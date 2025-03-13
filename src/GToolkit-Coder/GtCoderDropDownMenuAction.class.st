Class {
	#name : #GtCoderDropDownMenuAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'menuStencil'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #initialization }
GtCoderDropDownMenuAction >> computeActionDefinition [
	self menuStencil isClosure
		ifTrue: [ ^ GtCoderActionClosureDefinition new closure: self menuStencil ].
	^ nil
]

{ #category : #accessing }
GtCoderDropDownMenuAction >> content: aBlock [
	self actionDefinitionFromBlock: aBlock.
	self menu: [ BrMenuExplicit new stencil: aBlock ]
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
GtCoderDropDownMenuAction >> menu: aBlockOrStencil [
	menuStencil := aBlockOrStencil
]

{ #category : #accessing }
GtCoderDropDownMenuAction >> menuStencil [
	^ menuStencil
]
