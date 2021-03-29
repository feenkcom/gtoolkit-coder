Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtBaselinesFor: aView [
	<gtPackageView>
	^ aView explicit
		title: 'References';
		priority: 30;
		stencil: [ self name gtSubstringLiteralCaseSensitiveMatch ]
]

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
RPackage >> gtCommentFor: aView context: aPhlowContext [
	<gtPackageView>
	(aPhlowContext isKindOf: GtPhlowExecutionContext) ifFalse: [ ^ aView empty ].
	aPhlowContext hasPackageCoder ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10.8;
		title: 'Comment';
		tooltip: 'Package comment';
		disableAsync;
		stencil: [ (GtDocumenter forPackage: self) ];
		actionButtonIcon: BrGlamorousVectorIcons accept 
			tooltip: 'Save document' 
			action: [ :aToggle :aTab | aTab viewContentElement save ];
		actionToggleIcon: BrGlamorousIcons edit 
			tooltip: 'Show/Hide Markups'
			activated: [ :aToggle :aTab | aTab viewContentElement showMarkup ] 
			deactivated: [ :aToggle :aTab | aTab viewContentElement hideMarkup ];
		actionButtonIcon: BrGlamorousVectorIcons remove
			tooltip: 'Decrease font size'
			action: [ :aToggle :aTab | aTab viewContentElement decreaseNormalFontSize ];
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Increase font size'
			action: [ :aToggle :aTab | aTab viewContentElement increaseNormalFontSize ];
		actionUpdateButtonTooltip: 'Update class comment'
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
					asSortedCollection: [ :a :b | a name < b name ]);
				addEventFilterOn: BlClickEvent do: [ :anEvent | anEvent currentTarget requestFocus ] ]
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
					aptitude: BrGlamorousLabelAptitude
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
