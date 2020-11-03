Extension { #name : #RBAddTraitUsageRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBAddTraitUsageRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Add' asRopedText glamorousRoundedBackground)
		append: ' trait usage ' asRopedText;
		append: traitName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: class name asRopedText
]
