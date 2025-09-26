Extension { #name : #BrGlamorousMenuItemTypeBuilder }

{ #category : #'*GToolkit-Coder-UI' }
BrGlamorousMenuItemTypeBuilder >> visitCoderMenuActionItem: aMenuModel [
	^ self
		visitMenuLabeledItem: aMenuModel
		withElementClass: GtCoderMenuActionItemElement
]

{ #category : #'*GToolkit-Coder-UI' }
BrGlamorousMenuItemTypeBuilder >> visitCoderSubmenuItem: aMenuModel [
	^ self
		visitMenuLabeledItem: aMenuModel
		withElementClass: GtCoderMenuSubmenuItemElement
]
