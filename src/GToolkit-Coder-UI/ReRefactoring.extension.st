Extension { #name : #ReRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
ReRefactoring >> gtDescription [
	<return: #String or: #BlRunRopedText>
	
	^ self class name
]

{ #category : #'*GToolkit-Coder-UI' }
ReRefactoring >> gtDisplayOn: aStream [
	aStream nextPutAll: self gtDescription
]
