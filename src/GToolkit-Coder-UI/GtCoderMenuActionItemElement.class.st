Class {
	#name : #GtCoderMenuActionItemElement,
	#superclass : #BrMenuActionItemElement,
	#category : #'GToolkit-Coder-UI-Coder - Addons'
}

{ #category : #initialization }
GtCoderMenuActionItemElement >> initialize [
	super initialize
]

{ #category : #'event handling' }
GtCoderMenuActionItemElement >> onMouseEnterEvent: anEvent [
	super onMouseEnterEvent: anEvent.

	self menuModel hoverAction ifNotNil: [ :aHoverBlock | 
		aHoverBlock cull: self menuModel textualCoderViewModel cull: anEvent ]
]

{ #category : #'event handling' }
GtCoderMenuActionItemElement >> onMouseLeaveEvent: anEvent [
	super onMouseLeaveEvent: anEvent.

	self menuModel leaveAction ifNotNil: [ :aLeaveBlock | 
		aLeaveBlock cull: self menuModel textualCoderViewModel cull: anEvent ]
]
