Extension { #name : #RBRenameInstanceVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBRenameInstanceVariableRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Rename' asRopedText glamorousRoundedBackground)
		append: ' instance variable ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: newName asRopedText glamorousRoundedBackground;
		append: ' in ' asRopedText;
		append: class name asRopedText
]
