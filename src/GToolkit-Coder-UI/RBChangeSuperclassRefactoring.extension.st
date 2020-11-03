Extension { #name : #RBChangeSuperclassRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBChangeSuperclassRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Change' asRopedText glamorousRoundedBackground)
		append: ' superclass of ' asRopedText;
		append: className asRopedText;
		append: ' to ' asRopedText;
		append: newSuperclass name asRopedText glamorousRoundedBackground
]
