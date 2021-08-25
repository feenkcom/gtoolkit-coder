Extension { #name : 'GtRBAddTraitUsageRefactoring' }

{ #category : '*GToolkit-Coder-UI' }
GtRBAddTraitUsageRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Add' asRopedText glamorousRoundedBackground)
		append: ' trait usage ' asRopedText;
		append: traitName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: class name asRopedText
]
