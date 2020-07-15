Extension { #name : #RBRemoveMethodChange }

{ #category : #'*GToolkit-Coder' }
RBRemoveMethodChange >> gtDiff [
	| oldSource |
	oldSource := (self methodSourceFor: self selector) ifNil: [ '' ].
	^ PrettyTextDiffBuilder
		from: oldSource
		to: ''
		inClass: self changeClass
]
