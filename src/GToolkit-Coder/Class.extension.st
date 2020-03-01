Extension { #name : #Class }

{ #category : #'*GToolkit-Coder' }
Class >> gtInheritance [
	^ GtPharoInheritance new subclass: self; superclass: self superclass
]

{ #category : #'*GToolkit-Coder' }
Class >> gtReferences [
	^ GtSearchReferencesFilter literal: self binding
]

{ #category : #'*GToolkit-Coder' }
Class >> gtTraitUsages [
	^ self traits collect: [ :each | GtPharoTraitUsage new baseBehavior: self; usedTrait: each ]
]
