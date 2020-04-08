Extension { #name : #RBNamespace }

{ #category : #'*GToolkit-Coder' }
RBNamespace >> changedClasses [
	^ changedClasses
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> removePool: aString from: aRBClass [ 
	^changes removePool: aString from: aRBClass
]
