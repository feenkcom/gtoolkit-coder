Extension { #name : #GtCoderAction }

{ #category : #'*GToolkit-Coder-Extensions' }
GtCoderAction >> gtViewActionSourceCodeFor: aView [
	<gtView>
	^ self action 
		ifNil: [ aView ]
		ifNotNil: [ self action gtSourceCodeFor: aView ]
]
