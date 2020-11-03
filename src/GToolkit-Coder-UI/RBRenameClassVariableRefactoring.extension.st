Extension { #name : #RBRenameClassVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBRenameClassVariableRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Rename' asRopedText glamorousRoundedBackground)
		append: ' class variable ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: newName asRopedText glamorousRoundedBackground;
		append: ' in ' asRopedText;
		append: class name asRopedText
]
