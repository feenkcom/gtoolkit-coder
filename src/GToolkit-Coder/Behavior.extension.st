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
Behavior >> gtCoderMethodsFor: aView context: aDictionary [
	<gtClassView>
	| methodsCoder object |
	aDictionary
		at: #classCoder
		ifPresent: [ :coder | object := coder object ].
	methodsCoder := object notNil
		ifTrue: [ GtClassMethodsCoder forObject: object ]
		ifFalse: [ GtClassMethodsCoder forClass: self ].
	^ aView explicit
		priority: 10;
		title: 'Methods';
		disableAsync;
		actionDropdownButtonIcon: BrGlamorousVectorIcons filter
			tooltip: 'Filter'
			content: [ :element | methodsCoder filterDropDown: element ];
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add new method'
			action: [ methodsCoder addNewCoder ];
		actionStencil: [ BrButton new
				addLook: (GtFilterRunExampleButtonFourStateIconLook new 
					coder: methodsCoder);
				addLook: BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook;
				addLook: (GtFilterRunExampleButtonTooltipLook new coder: methodsCoder);
				icon: BrGlamorousIcons play;
				label: 'Run All Examples';
				action: [ :element | 
					methodsCoder exampler runExamplesFrom: element ] ];
		stencil: [ methodsCoder asElement ]
]
