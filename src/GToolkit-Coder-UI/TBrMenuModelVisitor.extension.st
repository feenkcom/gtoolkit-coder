Extension { #name : #TBrMenuModelVisitor }

{ #category : #'*GToolkit-Coder-UI' }
TBrMenuModelVisitor >> visitCoderMenuActionItem: aMenuModel [
	^ self visitMenuActionItem: aMenuModel
]

{ #category : #'*GToolkit-Coder-UI' }
TBrMenuModelVisitor >> visitCoderSubmenuItem: aMenuModel [
	^ self visitMenuSubmenuItem: aMenuModel
]

{ #category : #'*GToolkit-Coder-UI' }
TBrMenuModelVisitor >> visitTextualCoderMenu: aMenuModel [
	^ self visitMenu: aMenuModel
]
