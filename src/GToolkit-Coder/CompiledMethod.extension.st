Extension { #name : 'CompiledMethod' }

{ #category : '*GToolkit-Coder' }
CompiledMethod >> gtPackageScope [
	^ self package
]

{ #category : '*GToolkit-Coder' }
CompiledMethod >> gtReferencedClasses [
	"Return classes that are directly referenced by this method.
	Compared to #referencedClasses I do not count a value of the ClassVariable as a reference"

	^ self literals
		select: [ :l | (l isKindOf: ClassVariable) not and: [ l value isClass ] ] 
		thenCollect: [:v | v value ].
]
