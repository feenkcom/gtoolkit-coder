Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder' }
RPackage >> gtBrowseFrom: anElement [
	| aSpace aCoder coder |
	coder := GtPackagesCoder new.
	aCoder := GtInspector withToolOn: coder.
	aSpace := BlSpace new.
	aSpace title: 'Coder'.
	aSpace extent: 1200 @ 600.
	aSpace addChild: aCoder.
	aSpace withHalos.
	anElement showSpace: aSpace.
	coder withPackage: self
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
				| textElement |
				textElement := BlTextElement new.
				textElement text: each name asRopedText.
				textElement
			];
		  with: (self withDeepCollect: #usedPackages).
		mondrian edges 
			shape: [ 
				BlParabollaArcElement new 
					zIndex: 0;
					curvatureFraction: 0.2;
					border: (BlBorder paint: (Color gray alpha: 0.2) width:2 );
					toHead: (BlArrowheadSimpleArrow new
						border: (BlBorder builder paint: (Color gray alpha: 0.2); width:2; build)) ];
			fromRightCenter;
			toLeftCenter;
			connectFrom: #yourself
			toAll: [ :each | |usedPackages | 
				usedPackages := each usedPackages].
		mondrian layout custom: (GtGradHorizontalTreeLayout new).
	]
]

{ #category : #'*GToolkit-Coder' }
RPackage >> gtUsedPackagesFor: aView [
	<gtView>
	^ (self usedPackages gtItemsFor: aView)
		title: 'Used Packages';
		priority: 1
]

{ #category : #'*GToolkit-Coder' }
RPackage >> usedPackages [
	| result |
	result := Set new.
	result addAll: (self usedPackagesByExtending).
	result addAll: (self usedPackagesBySubclassing).
	^ result
	
]

{ #category : #'*GToolkit-Coder' }
RPackage >> usedPackagesByExtending [
	^ (self extendedClasses collect: #package) asSet
	
]

{ #category : #'*GToolkit-Coder' }
RPackage >> usedPackagesBySubclassing [
	| selfClasses |
	selfClasses := self classes.
	^ (((selfClasses flatCollect: [ :aClass | aClass withDeep: #superclass collect: [:each | (selfClasses includes: each) ifFalse: [each]]]) select: #isNotNil)) collect: #package.
	
]
