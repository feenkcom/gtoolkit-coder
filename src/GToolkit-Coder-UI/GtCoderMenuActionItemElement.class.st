Class {
	#name : #GtCoderMenuActionItemElement,
	#superclass : #BrMenuActionItemElement,
	#category : 'GToolkit-Coder-UI-Coder - Addons'
}

{ #category : #'event handling' }
GtCoderMenuActionItemElement >> leaveOnEvent: anEvent [
	| aMenuModel |
	aMenuModel := self menuModel.
	aMenuModel ifNil: [ ^ self ].
	aMenuModel leaveAction ifNotNil: [ :aLeaveBlock | 
		aLeaveBlock cull: aMenuModel textualCoderViewModel cull: anEvent ]
]

{ #category : #'event handling' }
GtCoderMenuActionItemElement >> onClick: anEvent element: anElement model: aButtonModel [
	| aMenuModel aCoderAction |
	aMenuModel := self menuModel.
	aMenuModel ifNil: [ ^ self ].
	self leaveOnEvent: anEvent.
	aCoderAction := aMenuModel coderContextMenuAction.
	aCoderAction ifNil: [ ^ self ].
	aCoderAction action ifNotNil: [ :anAction | 
		anAction gtValueWithArgs: {
			aMenuModel textualCoderEditorElement textualCoderViewModel.
			aMenuModel textualCoderEditorElement.
			anEvent } ].
	aMenuModel hideOnClick ifTrue: [ aMenuModel hideAll ]
]

{ #category : #'event handling' }
GtCoderMenuActionItemElement >> onMouseEnterEvent: anEvent [
	| aMenuModel |
	super onMouseEnterEvent: anEvent.
	aMenuModel := self menuModel.
	aMenuModel ifNil: [ ^ self ].
	aMenuModel hoverAction ifNotNil: [ :aHoverBlock | 
		aHoverBlock cull: aMenuModel textualCoderViewModel cull: anEvent ]
]

{ #category : #'event handling' }
GtCoderMenuActionItemElement >> onMouseLeaveEvent: anEvent [
	super onMouseLeaveEvent: anEvent.
	self leaveOnEvent: anEvent
]
