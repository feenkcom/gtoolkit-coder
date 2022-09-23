Extension { #name : #GtRBAddPoolVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
GtRBAddPoolVariableRefactoring >> gtDescription [
	<return: #String or: #BlRunRopedText>
	
	^ ('Add' asRopedText glamorousRoundedBackground)
		append: ' pool named ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: class name asRopedText
]
