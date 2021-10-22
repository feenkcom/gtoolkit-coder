Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowse [
	^ (GtCoder forClass: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowseFrom: anElement [
	^ ((GtCoder forClass: self) 
		openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
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
				stencil: [ methodsCoder asElement ];
				actionButtonIcon: BrGlamorousIcons browse 
					tooltip: 'Browse ', aClass name 
					action: [ :aButton | 
						aButton phlow spawnTool: (GtClassCoderTool forClass: aClass) ] ]
		ifAbsent: [ aView empty ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtCoderMethodsFor: aView context: aPhlowContext [
	<gtClassView>
	| aMethodsCoderUIModel aMethodsCoder |

	aMethodsCoderUIModel := self methodsCoderFromContext: aPhlowContext.
	aMethodsCoder := aMethodsCoderUIModel coder.

	^ aView explicit
		priority: 10;
		title: 'Methods';
		disableAsync;
		actionDropdownButtonIcon: BrGlamorousVectorIcons filter
			tooltip: 'Filter'
			content: [ :element | aMethodsCoder filterDropDown: element ];
		actionButtonDo: [ :aButtonAction |
			aButtonAction
				icon: BrGlamorousVectorIcons add;
				tooltip: 'Add new method';
				action: [ aMethodsCoderUIModel addNewCoder ];
				name: GtPharoBehaviorCoder addNewMethodButtonName ];
		actionDropdownButtonIcon: BrGlamorousVectorIcons robot
			tooltip: 'Generate'
			content: [ :element | aMethodsCoder codeGeneratorsDropDown: element for: aMethodsCoderUIModel ];
		actionStencil:
				[ self runAllExamplesButtonForMethodsCoder: aMethodsCoder ];
		actionStencil: 
				[ self newTestSuiteButtonForMethodsCoder: aMethodsCoder ];
		stencil: [ aMethodsCoderUIModel asElement ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> methodsCoderFromContext: aPhlowContext [
	<return: #GtPharoMethodsCoderViewModel>

	^ aPhlowContext
		optionAt: #behaviorCoder
		ifPresent: [ :aBehaviorCoderUIModel | aBehaviorCoderUIModel methodsCoderUIModel ]
		ifAbsentPut: [ (GtClassMethodsCoder forClass: self) asCoderUIModel ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> newTestSuiteButtonForMethodsCoder: aMethodsCoder [

	^ GtCoderUIUtility newTestSuiteButtonForMethodsCoder:
		  aMethodsCoder
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> runAllExamplesButtonForMethodsCoder: aMethodsCoder [

	^ GtCoderUIUtility newExamplesButtonForMethodsCoder: aMethodsCoder
]
