Extension { #name : #BrGlamorousMenuElementBuilder }

{ #category : #'*GToolkit-Coder-UI' }
BrGlamorousMenuElementBuilder >> visitTextualCoderMenu: aMenuModel [
	| aCoderViewModel aCoderElement |
	aMenuModel coderViewModelStencil ifNil: [ ^ nil ].
	aCoderViewModel := aMenuModel coderViewModelStencil create.
	aCoderViewModel ifNil: [ ^ nil ].
	
	aCoderElement := aCoderViewModel asExpandedOnlyElement.
	aCoderElement addAptitude: (BrGlamorousPopoverDefiningMethodAptitude new
		menuModel: aMenuModel).
	
	^ aCoderElement
]
