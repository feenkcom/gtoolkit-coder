Extension { #name : #GtCoderAction }

{ #category : #'*GToolkit-Coder-Extensions' }
GtCoderAction >> gtSourceCodeFor: aView [
	<gtView>
	^ self action 
		ifNil: [ aView ]
		ifNotNil: [ self action gtSourceCodeFor: aView ]
]
