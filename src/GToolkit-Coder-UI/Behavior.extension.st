Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtBrowseButtonFor: anAction [
	<gtClassAction>
	^ anAction explicit
		priority: 1;
		stencil: [ | button |
			button := BrButton new
					id: GtCoderBrowseCoderButtonId;
					aptitude: BrGlamorousButtonWithIconAptitude;
					label: 'Browse class';
					icon: BrGlamorousVectorIcons emphasizedBrowse;
					action: [ :aButton :aModel :anEvent | 
						anEvent modifiers isPrimaryModifier
							ifTrue: [ self gtBrowseFromButton: aButton ]
							ifFalse: [ aButton phlow
									spawnTool: (GtPhlowValuableTool new
											name: self gtDisplayString;
											valuable: [ | aCoder |
												aButton phlow firstParentCoderNavigationModel
													coderDo: [ :oldCoder | aCoder := GtCoder forCoder: oldCoder asNewCoderModelWithSameSubject ].
												aCoder ]) ] ].
			button viewModel
				when: BlClickEvent
				do: [ :anEvent | 
					anEvent modifiers isPrimaryModifier
						ifTrue: [ button viewModel clickEvent: anEvent ] ].
			button viewModel
				when: BlMouseEnterEvent
				do: [ :anEvent | 
					anEvent consumed: true.
					anEvent modifiers isPrimaryModifier
						ifTrue: [ anEvent target mouseCursor: BlCopyCursor new ]
						ifFalse: [ anEvent target mouseCursor: nil ].
					anEvent target requestFocus ].
			button ]
]

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtCoderStreamingMethodsFor: aView context: aPhlowContext [
	<gtClassView>
	| aMethodsCoder aMethodsCoderViewModel aTestSuiteViewModel anExampleViewModel view |
	aMethodsCoder := GtPharoStreamingMethodsCoder forBehavior: self.
	aMethodsCoderViewModel := GtPharoStreamingMethodsCoderViewModel new
			streamingCodersModel: aMethodsCoder;
			shouldExpandByDefault: false;
			shouldHaveHeaderByDefault: false;
			selfObject: (aPhlowContext
					optionAt: #behaviorCoder
					ifPresent: [ :aBehaviorCoderUIModel | aBehaviorCoderUIModel coderModel object ]
					ifAbsent: [ nil ]).

	aTestSuiteViewModel := self
			testSuiteViewModelWith: aMethodsCoder
			fromContext: aPhlowContext.

	anExampleViewModel := GtPharoCoderUIUtility
			exampleViewModelCachedAs: #exampleViewModelHandler_gtCoderStreamingMethodsForContext
			inPhlowContext: aPhlowContext
			forMethodsCoder: aMethodsCoder.


	view := aView explicit
			priority: 9;
			title: 'Methods';
			disableAsync;
			actionDropdownButtonIcon: BrGlamorousVectorIcons filter
				tooltip: 'Filter'
				content: [ :element | aMethodsCoder filterDropDown: element ];
			actionDropdownButtonDo: [ :aDrodownAction | 
				aDrodownAction dropdown
					name: GtPharoBehaviorCoder addNewMethodButtonName;
					icon: BrGlamorousVectorIcons add;
					tooltip: 'Add new method';
					content: [ :aButton | self gtNewMethodDropdownOn: aButton withViewModel: aMethodsCoderViewModel ] ].

	(aMethodsCoder codeGeneratorsAvailableFor: aMethodsCoderViewModel)
		ifTrue: [ view
				actionDropdownButtonIcon: BrGlamorousVectorIcons robot
				tooltip: 'Generate'
				content: [ :anElement | aMethodsCoder codeGeneratorsDropDown: anElement for: aMethodsCoderViewModel ] ].
	^ view
		actionButtonDo: [ :aButtonAction | 
			aButtonAction
				icon: BrGlamorousVectorIcons inspect;
				tooltip: 'Inspect view model';
				action: [ :aButton | aButton phlow spawnObject: aMethodsCoderViewModel ] ];
		actionStencil: [ :aBrTab | GtPharoCoderUIUtility newExamplesDropdownButtonForViewModel: anExampleViewModel ];
		actionStencil: [ :aBrTab | GtPharoCoderUIUtility newTestsDropdownButtonForViewModel: aTestSuiteViewModel ];
		stencil: [ GtPharoStreamingMethodsCoderElement new
				streamingCodersViewModel: aMethodsCoderViewModel ];
		actionStencil: [ :aButton | 
				GtSpotterDropdownButtonStencil new
					object: self;
					tooltip: 'Search Code';
					id: GtPharoSearchCodeButtonId;
					actOn: [ :anActOnEvent :anItem :theButton | 
						| acted navigationModel |
						acted := false.
						navigationModel := theButton phlow firstParentWithView phlow
								firstParentWithView navigationModel.
						(anItem isKindOf: RPackage)
							ifTrue: [ navigationModel selectPackage: anItem.
								acted := true ].
						(anItem isKindOf: ClassDescription)
							ifTrue: [ navigationModel selectClass: anItem.
								acted := true ].
						(anItem isKindOf: CompiledMethod)
							ifTrue: [ navigationModel selectMethod: anItem.
								acted := true ].
						acted ifTrue: [ anActOnEvent beActed ] ];
					asElement ]
			tooltip: 'Search Code'
]

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtHierarchyButtonFor: anAction [
	<gtClassAction>
	^ anAction dropdown
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		id: GtCoderClassHierarchyButtonId;
		priority: 3;
		content: [ :aButton | 
			| aNavigationModel |
			aNavigationModel := aButton phlow firstParentCoderNavigationModel.
			BlElement new
				size: 400 @ 400;
				addChild: ((GtCoderNavigationTabsStencil new
						navigationModel: aNavigationModel;
						asElement) background: Color white) ]
]

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtNewMethodDropdownOn: aButton withViewModel: aMethodsCoderViewModel [
	| aNewMethodCoderHolder element aNewMethodCoderViewModel newMethodText aNewMethodCoder aHandler tagElement |
	newMethodText := '' asRopedText
			glamorousCodeFontAndSize;
			attribute: (BrGhostTextAttribute
					for: ('newMethod' asRopedText glamorousCodeFontAndSize foreground: Color lightGray))
					beNotOverwritableByStyler.
	aNewMethodCoder := (GtPharoMethodCoder forNewMethod: self)
			currentSourceText: newMethodText;
			protocol: #accessing;
			yourself.
	aNewMethodCoderViewModel := aNewMethodCoder asCoderViewModel
			withoutHeader;
			expanded: true;
			focused: true;
			moveCursorAtEnd.
	aNewMethodCoderHolder := ValueHolder new contents: aNewMethodCoderViewModel.
	aHandler := GtPharoNewMethodCodeSavedHandler new
			methodsCoderViewModel: aMethodsCoderViewModel;
			element: aButton;
			methodCoderHolder: aNewMethodCoderHolder.
	aNewMethodCoderViewModel weak
		when: GtMethodCoderSaved
		send: #onAnnouncement:
		to: aHandler.
	element := (GtSourceCoderExpandedContentElement new
			coderViewModel: aNewMethodCoderViewModel)
			hExact: 400;
			vFitContentLimited;
			background: Color white;
			addAptitude: BrGlamorousFocusableShadowAptitude new;
			when: GtPhlowObjectToSpawn
				do: [ :aSpawnEvent | 
					aSpawnEvent consumed: true.
					aButton
						fireEvent: (GtPhlowObjectToSpawn new
								previousSpawnEvent: aSpawnEvent;
								tool: aSpawnEvent tool;
								sourceElement: aSpawnEvent currentTarget;
								spawnDestination: aSpawnEvent spawnDestination;
								in: [ :anNewEvent | anNewEvent propertyAt: #spawnContainer put: aSpawnEvent currentTarget ];
								yourself) ].
	tagElement := GtPharoMethodCoderTagsElement new
			pharoMethodCoderViewModel: aNewMethodCoderViewModel;
			constraintsDo: [ :c | 
				c ignoreByLayout.
				c ignored horizontal alignRight.
				c ignored vertical alignBottom.
				c margin: (BlInsets bottom: -2) ].
	element actions addChild: tagElement.
	^ element
]
