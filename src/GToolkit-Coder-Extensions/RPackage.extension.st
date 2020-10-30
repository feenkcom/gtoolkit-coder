Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtBrowse [
	^ ((GtCoder forPackage: self) 
		openInPager) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtBrowseFrom: anElement [
	^ ((GtCoder forPackage: self) 
		openInPagerFrom: anElement) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtDefinedClassesFor: aView context: aPhlowContext [
	<gtPackageView>
	(aPhlowContext isKindOf: GtPhlowExecutionContext) ifFalse: [ ^ aView empty ].
	aPhlowContext hasPackageCoder ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'Classes';
		disableAsync;
		stencil: [ aPhlowContext packageCoder classesCoder asElement ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtDefinedTagsFor: aView context: aPhlowContext [
	<gtPackageView>
	(aPhlowContext isKindOf: GtPhlowExecutionContext) ifFalse: [ ^ aView empty ].
	aPhlowContext hasPackageCoder ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10.5;
		title: 'Tags';
		disableAsync;
		stencil: [ 
			BrSimpleList new
				itemStencil: [ GtPackageTagCardElement new ];
				itemDataBinder: [ :eachTagCard :eachTagCoder | 
					eachTagCard coder: eachTagCoder ];
				items: (aPhlowContext packageCoder packageTagCoders 
					asSortedCollection: [ :a :b | a name < b name ]) ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
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
