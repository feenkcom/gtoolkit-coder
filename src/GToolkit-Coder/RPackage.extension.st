Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder' }
RPackage >> gtBrowseFrom: anElement [
	| aSpace |

	aSpace := BlSpace new
		title: 'Coder';
		extent: 1200 @ 600;
		addChild: (GtInspector withToolOn: (GtCoder forPackage: self));
		withHalos.

	anElement showSpace: aSpace
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtClassExtensions [
	^ self extensionMethods collect: [ :each | GtPharoClassExtension new extendingMethod: each ]
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtClassReferences [
	^ self methodReferences flatCollectAsSet: [ :m | 
		m method referencedClasses collect: [ :each | 
			GtPharoClassReference new 
				referencingMethod: m; 
				referencedClass: each ]]
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtDependencies [
	| all |
	all := Set new.
	all addAll: self gtClassExtensions.
	all addAll: self gtInheritances.
	all addAll: self gtTraitUsages.
	all addAll: self gtClassReferences.
	^ all select: [ :each | each toPackage ~= self ]
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtDependenciesMapFor: aView [
	<gtView>
	^ aView mondrian
	title: 'Dependencies Map';
	priority: 10;
	painting: [ :mondrian |
		mondrian nodes 
			shape: [ :each | 
				BrLabel new 
					text: each name asRopedText;
					look: BrGlamorousLabelLook
			];
		  with: (self gtPackagesUsed, {self}).
		mondrian edges 
			shape: [ 
				BlParabollaArcElement new 
					zIndex: 0;
					curvatureFraction: 0.1;
					border: (BlBorder paint: (Color gray alpha: 0.1) width:2 );
					toHead: (BlArrowheadSimpleArrow new
						border: (BlBorder builder paint: (Color gray alpha: 0.1); width:2; build)) ];
			fromRightCenter;
			toLeftCenter;
			connectFrom: #yourself
			toAll: [ :each | |usedPackages | 
				usedPackages := each gtPackagesUsed].
		mondrian layout custom: (GtGraphHorizontalDominanceTreeLayout new).
	]
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtInheritances [
	^ self definedClasses 
		select: [ : each | each isClass and: [ each superclass notNil ] ]
		thenCollect: [ :each | each gtInheritance ]
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtPackageScope [
	^ self
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtPackagesUsed [
	| result |
	result := Set new.
	result addAll: self gtPackagesUsedThroughClassExtensions.
	result addAll: self gtPackagesUsedThroughSubclassing.
	result addAll: self gtPackagesUsedThroughTraitUsages.
	result addAll: self gtPackagesUsedThroughClassReferences.
	^ result
	
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtPackagesUsedThroughClassExtensions [
	^ self gtClassExtensions collectAsSet: [ :each | each toPackage ]
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtPackagesUsedThroughClassReferences [
	^ (self gtClassReferences collectAsSet: [ :each | each toPackage ])
		remove: self ifAbsent: [];
		yourself
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtPackagesUsedThroughSubclassing [
	^ (self gtInheritances collectAsSet: [ :each | each toPackage ]) 
		remove: self ifAbsent: []; 
		yourself
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtPackagesUsedThroughTraitUsages [
	^ (self gtTraitUsages collectAsSet: [ :each | each toPackage ])
		remove: self ifAbsent: [];
		yourself
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtTraitUsages [
	^ self definedClasses flatCollect: [ :each | each gtTraitUsages ]
]
