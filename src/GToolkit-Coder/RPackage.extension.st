Extension { #name : 'RPackage' }

{ #category : '*GToolkit-Coder' }
RPackage >> gtClassExtensions [
	^ self extensionMethods collect: [ :each | GtPharoClassExtension new extendingMethod: each ]
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtClassReferences [
	^ self gtMethodReferences flatCollectAsSet: [ :m | 
		m method gtReferencedClasses collect: [ :each | 
			GtPharoClassReference new 
				referencingMethod: m; 
				referencedClass: each ]]
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtDependencies [
	| all |
	all := Set new.
	all addAll: self gtClassExtensions.
	all addAll: self gtInheritances.
	all addAll: self gtTraitUsages.
	all addAll: self gtClassReferences.
	^ all select: [ :each | each toPackage ~= self ]
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtInheritances [
	^ self definedClasses 
		select: [ : each | each isClass and: [ each superclass notNil ] ]
		thenCollect: [ :each | each gtInheritance ]
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtMethodReferences [
	^ self methods collect: [:each | each methodReference] thenSelect: [:each| each isValid and: [each isLocalSelector]].
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtPackageScope [
	^ self
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtPackagesUsed [
	| result |
	result := Set new.
	result addAll: self gtPackagesUsedThroughClassExtensions.
	result addAll: self gtPackagesUsedThroughSubclassing.
	result addAll: self gtPackagesUsedThroughTraitUsages.
	result addAll: self gtPackagesUsedThroughClassReferences.
	^ result
	
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtPackagesUsedThroughClassExtensions [
	^ self gtClassExtensions collectAsSet: [ :each | each toPackage ]
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtPackagesUsedThroughClassReferences [
	^ (self gtClassReferences collectAsSet: [ :each | each toPackage ])
		remove: self ifAbsent: [];
		yourself
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtPackagesUsedThroughSubclassing [
	^ (self gtInheritances collectAsSet: [ :each | each toPackage ]) 
		remove: self ifAbsent: []; 
		yourself
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtPackagesUsedThroughTraitUsages [
	^ (self gtTraitUsages collectAsSet: [ :each | each toPackage ])
		remove: self ifAbsent: [];
		yourself
]

{ #category : '*GToolkit-Coder' }
RPackage >> gtTraitUsages [
	^ self definedClasses flatCollect: [ :each | each gtTraitUsages ]
]
