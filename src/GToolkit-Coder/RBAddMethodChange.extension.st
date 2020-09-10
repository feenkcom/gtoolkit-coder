Extension { #name : #RBAddMethodChange }

{ #category : #'*GToolkit-Coder' }
RBAddMethodChange >> gtDiff [
	| oldSource newSource |
	oldSource := (self changeClass notNil
		ifTrue: [ self methodSourceFor: self selector ]) ifNil: [ '' ].
	newSource := source.
	^ PrettyTextDiffBuilder
		from: oldSource
		to: newSource
		inClass: self changeClass
]
