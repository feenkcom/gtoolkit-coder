Extension { #name : #GtRBRemovePoolVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
GtRBRemovePoolVariableRefactoring >> gtDescription [
	<return: #String or: #BlRunRopedText>
	
	^ ('Remove' asRopedText glamorousRoundedBackground)
		append: ' pool named ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' from ' asRopedText;
		append: class name asRopedText
]
