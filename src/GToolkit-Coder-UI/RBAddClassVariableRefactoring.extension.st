Extension { #name : #RBAddClassVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBAddClassVariableRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Add' asRopedText glamorousRoundedBackground)
		append: ' class variable ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: class name asRopedText
]
