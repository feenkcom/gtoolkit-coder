Extension { #name : #RBRemoveClassVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBRemoveClassVariableRefactoring >> gtDescription [
	<return: #String or: #BlRunRopedText>
	
	^ ('Remove' asRopedText glamorousRoundedBackground)
		append: ' class variable ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' from ' asRopedText;
		append: class name asRopedText
]
