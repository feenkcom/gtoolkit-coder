Extension { #name : #RBAddInstanceVariableRefactoring }

{ #category : #'*GToolkit-Coder' }
RBAddInstanceVariableRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Add' asRopedText glamorousRoundedBackground)
		append: ' instance variable ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' to ' asRopedText;
		append: class name asRopedText
]
