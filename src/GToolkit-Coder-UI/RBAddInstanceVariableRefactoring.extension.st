Extension { #name : #RBAddInstanceVariableRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBAddInstanceVariableRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Add' asRopedText glamorousRoundedBackground)
		append: ' instance variable ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: class printString asRopedText
]
