Extension { #name : #RBRemoveInstanceVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBRemoveInstanceVariableRefactoring >> gtDescription [
	<return: #String or: #BlRunRopedText>
	
	^ ('Remove' asRopedText glamorousRoundedBackground)
		append: ' instance variable ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' from ' asRopedText;
		append: class printString asRopedText
]
