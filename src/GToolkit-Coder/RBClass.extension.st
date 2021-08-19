Extension { #name : 'RBClass' }

{ #category : '*GToolkit-Coder' }
RBClass >> traitExpression [
	^ (self isDefined and: [ self realClass hasTraitComposition ])
		ifTrue: [ self realClass traitComposition printString ]
]
