Extension { #name : #TBrMenuModelVisitor }

{ #category : #'*GToolkit-Coder-UI' }
TBrMenuModelVisitor >> visitCoderMenuActionItem: aMenuModel [
	^ self visitMenuActionItem: aMenuModel
]

{ #category : #'*GToolkit-Coder-UI' }
TBrMenuModelVisitor >> visitTextualCoderMenu: aMenuModel [
	^ self visitMenu: aMenuModel
]
