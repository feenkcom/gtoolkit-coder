Extension { #name : #GtCoderAction }

{ #category : #'*GToolkit-Coder-Extensions' }
GtCoderAction >> gtSourceCodeFor: aView [
	<gtView>
	^ self action 
		ifNil: [ aView empty ]
		ifNotNil: [ self action gtSourceCodeFor: aView ]
]
