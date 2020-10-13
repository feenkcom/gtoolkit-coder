Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowse [
	^ (GtCoder forClass: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFrom: anElement [
	^ ((GtCoder forClass: self) 
		openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderCommentsFor: aView [
	<gtClassView>

	^ aView explicit
		title: 'Comment';
		tooltip: 'Class comment';
		priority: 30;
		disableAsync;
		stencil: [ (GtDocumenter forClass: self) ];
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

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderExamplesFor: aView context: aDictionary [
	<gtClassView>
	| anExamplesClassName |

	anExamplesClassName := (self name , 'Examples') asSymbol.

	^ self environment
		at: anExamplesClassName
		ifPresent: [ :aClass | 
			| methodsCoder |
			methodsCoder := GtClassMethodsCoder forClass: aClass.
			aView explicit
				priority: 50;
				title: 'Related examples';
				actionButtonIcon: BrGlamorousVectorIcons add
					action: [ methodsCoder addNewCoder ];
				stencil: [ methodsCoder asElement ] ]
		ifAbsent: [ aView empty ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderMethodsFor: aView context: aPhlowContext [
	<gtClassView>
	| aMethodsCoder |
	aMethodsCoder := self methodsCoderFromContext: aPhlowContext.
	^ aView explicit
		priority: 10;
		title: 'Methods';
		disableAsync;
		actionDropdownButtonIcon: BrGlamorousVectorIcons filter
			tooltip: 'Filter'
			content: [ :element | aMethodsCoder filterDropDown: element ];
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add new method'
			action: [ aMethodsCoder addNewCoder ];
		actionStencil:
				[ self runAllExamplesButtonForMethodsCoder: aMethodsCoder ];
		stencil: [ aMethodsCoder asElement ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> methodsCoderFromContext: aPhlowContext [ 
	^ aPhlowContext
		at: #methodsCoder
		ifPresent: [ :aCoder | aCoder ]
		ifAbsentPut: [
			aPhlowContext
				at: #classCoder
				ifPresent: [ :aCoder | 
					aCoder hasObject
						ifTrue: [ GtClassMethodsCoder forObject: aCoder object ]
						ifFalse: [ GtClassMethodsCoder forClass: self ] ]
				ifAbsent: [ GtClassMethodsCoder forClass: self ] ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> runAllExamplesButtonForMethodsCoder: aMethodsCoder [
	^ BrButton new
		addLook:
			(GtFilterRunExampleButtonFourStateIconLook new coder: aMethodsCoder);
		addLook: BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook;
		addLook: (GtFilterRunExampleButtonTooltipLook new coder: aMethodsCoder);
		icon: BrGlamorousVectorIcons play;
		label: 'Run All Examples';
		action: [ :element | aMethodsCoder exampler runExamplesFrom: element ]
]
