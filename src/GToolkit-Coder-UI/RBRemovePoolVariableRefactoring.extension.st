Extension { #name : #RBRemovePoolVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBRemovePoolVariableRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Remove' asRopedText glamorousRoundedBackground)
		append: ' pool named ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' from ' asRopedText;
		append: class name asRopedText
]
