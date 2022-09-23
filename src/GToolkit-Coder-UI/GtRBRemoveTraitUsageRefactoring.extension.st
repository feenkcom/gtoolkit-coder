Extension { #name : #GtRBRemoveTraitUsageRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
GtRBRemoveTraitUsageRefactoring >> gtDescription [
	<return: #String or: #BlRunRopedText>
	
	^ ('Remove' asRopedText glamorousRoundedBackground)
		append: ' trait usage ' asRopedText;
		append: traitName asRopedText glamorousRoundedBackground;
		append: ' from ' asRopedText;
		append: class name asRopedText
]
