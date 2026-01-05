Extension { #name : #RBRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBRefactoring >> gtDescription [
	<return: #String or: #BlRunRopedText>
	
	^ self class name
]

{ #category : #'*GToolkit-Coder-UI' }
RBRefactoring >> gtDisplayOn: aStream [
	aStream nextPutAll: self gtDescription
]
