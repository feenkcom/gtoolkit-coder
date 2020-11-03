Extension { #name : #RBAddPoolVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBAddPoolVariableRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Add' asRopedText glamorousRoundedBackground)
		append: ' pool named ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: class name asRopedText
]
