Class {
	#name : #GtPharoMethodCoderByScripterExamples,
	#superclass : #GtPharoMethodCoderExamples,
	#traits : 'TCoderByScripterExamples',
	#classTraits : 'TCoderByScripterExamples classTrait',
	#category : #'GToolkit-Coder-Examples-Pharo'
}

{ #category : #'examples - basic' }
GtPharoMethodCoderByScripterExamples >> basicMethodCoder [
	<gtExample>
	| aCoder |
	aCoder := GtPharoMethodCoder new.
	self assert: aCoder selector isNil.
	self assert: aCoder behavior equals: UndefinedObject.
	self assert: aCoder protocol isNil.
	self assert: aCoder currentSourceString isString.
	self assert: aCoder currentSourceString isEmpty.
	^ aCoder
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethod [
	<gtExample>

	^ GtPharoMethodCoderExamples >> #?
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self binaryMethod.
	aCoder := self coderOnMethod: aMethod.
	^ aCoder
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI [
	<gtExample>
	| aScripter |

	aScripter := self scripterForBlock: [ self binaryMethodCoder ].
	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_CollapsedFromUI [
	<gtExample>
	| aScripter |

	aScripter := self binaryMethodCoderUI.
	aScripter substep: 'Collapse and Check Coder' do: [ :aStep |
		aStep click
			label: 'Click on Expander';
			onChildAt: 1.
		
		aStep wait forEmptySpaceTaskQueue.
		
		aStep check
			label: 'Check Coder Editor Text';
			value: [ :label | label text asString ] equals: '?';
			id: GtSourceCoderCollapsedTextId.
		aStep check 
			label: 'Check Coder UI Is Collapsed';
			satisfies: [ :aCoderElement | aCoderElement isExpanded not ] ].

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_Collapsed_BreadcrumbContent [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_CollapsedFromUI.
	aScripter checks: 'Check Breadcrumb' do: [ :aStep | 
		aStep  check 
			label: 'Check Breadcrumb Package Name';
			value: [ :aButton | aButton label asString ] equals: [ GtPharoMethodCoderExamples package name ];
			onBreadthFirstChildOfClass: GtMethodCoderBreadcrumbElement;
			onChildAt: 1.
		aStep  check 
			label: 'Check Breadcrumb Class Name';
			value: [ :aButton | aButton label asString ] equals: [ GtPharoMethodCoderExamples name ];
			onBreadthFirstChildOfClass: GtMethodCoderBreadcrumbElement;
			onChildAt: 3 ].

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_Collapsed_BreadcrumbOnClassNameClick [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_CollapsedFromUI.
	aScripter substeps: 'Click On Breadcrumb' do: [ :aStep |
		aStep click
			label: 'Click On Class Name';
			onChildAt: 2;
			onChildOfClass: GtSourceCoderCollapsedContentElement;
			onChildAt: 1;
			onChildOfClass: GtMethodCoderBreadcrumbElement;
			onChildAt: 3.
		
		aStep wait forEmptySpaceTaskQueue.	
		
		aStep  check 
			label: 'Check Triggered Spawn Object Event';
			satisfies: [ :theScripter | theScripter events reversed 
				detectEventOfClass: GtPhlowObjectToSpawn
				ifFound: [ :theEvent |
					theEvent object = self binaryMethod methodClass and: [ theEvent tool isKindOf: GtClassCoderTool ] ]
				ifNone: [ AssertionFailure signal: GtPhlowObjectToSpawn name, ' event was not found' ]  ];
			onScripter.
		].

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_Collapsed_BreadcrumbOnPackageClick [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_CollapsedFromUI.
	aScripter substeps: 'Click On Breadcrumb' do: [ :aStep |
		aStep click
			label: 'Click On Package Name';
			onChildAt: 2;
			onChildOfClass: GtSourceCoderCollapsedContentElement;
			onChildAt: 1;
			onChildOfClass: GtMethodCoderBreadcrumbElement;
			onChildAt: 1.
		
		aStep wait forEmptySpaceTaskQueue.
		
		aStep  check 
			label: 'Check Triggered Spawn Object Event';
			satisfies: [ :theScripter | theScripter events reversed 
				detectEventOfClass: GtPhlowObjectToSpawn
				ifFound: [ :theEvent | theEvent object class = RPackage and: [ theEvent object name = self class package name ] ]
				ifNone: [ AssertionFailure signal: GtPhlowObjectToSpawn name, ' event was not found' ]  ];
			onScripter.
		].

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_ExpandedFromUI [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_CollapsedFromUI.
	self expandFromUI: aScripter method: self binaryMethod.

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_ExpandedFromUI_CheckActionButtons [
	<gtExample>
	| aScripter |

	aScripter := self binaryMethodCoderUI_ExpandedFromUI.
	self 
		checkFor: aScripter 
		numberOfMainActions: 5
		contextAction: 0.

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_ExpandedFromUI_CodeStyle [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_ExpandedFromUI.
	aScripter checks: 'Check Expanded Source Code Style' do: [ :aStep |
		aStep check
			label: 'Check Method Name Attributes';
			anySatisfies: [ :aTextAttribute | aTextAttribute = BlFontWeightAttribute bold ];
			onChildNamed: #editor;
			onBrTextEditor;
			onBrTextEditorText;
			onTextAttributesAt: 1.
		aStep check
			label: 'Check Comment Attributes';
			anySatisfies: [ :aTextAttribute | aTextAttribute = (BlTextForegroundAttribute new paint: Color gray darker) ];
			onChildNamed: #editor;
			onBrTextEditor;
			onBrTextEditorText;
			onTextAttributesAt: 13.
	].

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_Expanded_BreadcrumbContent [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter checks: 'Check Breadcrumb' do: [ :aStep | 
		aStep  check 
			label: 'Check Breadcrumb Package Name';
			value: [ :aButton | aButton label asString ] equals: [ GtPharoMethodCoderExamples package name ];
			onBreadthFirstChildOfClass: GtMethodCoderBreadcrumbElement;
			onChildAt: 1.
		aStep  check 
			label: 'Check Breadcrumb Class Name';
			value: [ :aButton | aButton label asString ] equals: [ GtPharoMethodCoderExamples name ];
			onBreadthFirstChildOfClass: GtMethodCoderBreadcrumbElement;
			onChildAt: 3 ].

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_Expanded_BreadcrumbOnClassNameClick [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter substeps: 'Click On Breadcrumb' do: [ :aStep |
		aStep click
			label: 'Click On Class Name';
			onChildAt: 2;
			onChildOfClass: GtSourceCoderExpandedContentElement;
			onChildAt: 1;
			onChildOfClass: GtMethodCoderBreadcrumbElement;
			onChildAt: 3.
			
		aStep wait forEmptySpaceTaskQueue.
		
		aStep  check 
			label: 'Check Triggered Spawn Object Event';
			satisfies: [ :theScripter | theScripter events reversed 
				detectEventOfClass: GtPhlowObjectToSpawn
				ifFound: [ :theEvent |
					theEvent object = self binaryMethod methodClass and: [ theEvent tool isKindOf: GtClassCoderTool ] ]
				ifNone: [ AssertionFailure signal: GtPhlowObjectToSpawn name, ' event was not found' ]  ];
			onScripter.
		].
	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_Expanded_BreadcrumbOnPackageClick [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter substeps: 'Click On Breadcrumb' do: [ :aStep |
		aStep click
			label: 'Click On Package Name';
			onChildAt: 2;
			onChildOfClass: GtSourceCoderExpandedContentElement;
			onChildAt: 1;
			onChildOfClass: GtMethodCoderBreadcrumbElement;
			onChildAt: 1.
			
		aStep wait forEmptySpaceTaskQueue.
		
		aStep  check 
			label: 'Check Triggered Spawn Object Event';
			satisfies: [ :theScripter | theScripter events reversed 
				detectEventOfClass: GtPhlowObjectToSpawn
				ifFound: [ :theEvent | theEvent object class = RPackage and: [ theEvent object name = self class package name ] ]
				ifNone: [ AssertionFailure signal: GtPhlowObjectToSpawn name, ' event was not found' ]  ];
			onScripter.
		].

	^ aScripter syncContinue
]

{ #category : #'examples - binary method' }
GtPharoMethodCoderByScripterExamples >> binaryMethodCoderUI_WithoutExampleActions [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_ExpandedFromUI.
	self 
		checkFor: aScripter 
		numberOfMainActions: 5
		contextAction: 0.
	self checkFor: aScripter absenceOfContextActionNamed: 'Play'.

	^ aScripter syncContinue
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripter absenceOfContextActionNamed: anActionName [
	<gtExample>
	
	aScripter check 
		label: 'Check Context Action Existence Named ', anActionName asString;
		nonSatisfies: [ :aContextActions | aContextActions title = anActionName translated
			and: [ aContextActions action method = (GtPharoMethodCoder>>#exampleAstFor:into:) ] ];
		onModel;
		onChildFromMessage: #contextActions.
	
	^ aScripter
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep discardButtonExists: doesExist [
	<gtExample>
	| aCheck |

	aCheck := aScripterOrStep check
		id: GtMethodCoderDiscardChangesActionId.

	doesExist
		ifTrue: [
			aCheck
				exists;
				label: 'Check discard button exists' ]
		ifFalse: [
			aCheck
				notExists;
				label: 'Check discard button does not exist' ].

	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripter existenceOfContextActionNamed: anActionName [
	<gtExample>
	
	aScripter check 
		label: 'Check Context Action Existence Named ', anActionName asString;
		anySatisfies: [ :aContextActions | aContextActions title = anActionName translated
			and: [ aContextActions action method = (GtPharoMethodCoder>>#exampleAstFor:into:) ] ];
		onModel;
		onChildFromMessage: #contextActions.
	
	^ aScripter
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripter numberOfMainActions: aMainActionsCount contextAction: anAddonsActionsCount [
	<gtExample>
	aScripter substeps: 'Check Available Action Buttons' do: [ :aStep |
		aStep wait forEmptySpaceTaskQueue.

		aStep check 
			label: 'Number of main actions';
			childrenCount: aMainActionsCount;
			onBreadthFirstChildOfClass: GtCoderActionsElement;
			onChildAt: 1.

		aStep check 
			label: 'Number of addons actions';
			childrenCount: anAddonsActionsCount;
			onBreadthFirstChildOfClass: GtCoderActionsElement;
			onChildAt: 3 ].

	^ aScripter
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep numberfOfTextAttributes: aNumber OfType: aClass [
	<gtExample>
	aScripterOrStep check
		label: 'Check Editor Text Attributes';
		value: [ :aText | 
			| anIterator aCounter |
			aCounter := 0.
			anIterator := aText iterator.
			[ anIterator hasNext ] whileTrue: [ (anIterator attributes 
				anySatisfy: [ :eachAttribute | eachAttribute class = aClass ]) ifTrue: [ aCounter := aCounter + 1 ].
				anIterator next ].
			aCounter ] equals: aNumber;
		onChildNamed: #editor;
		onBrTextEditor;
		onBrTextEditorText.
	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep refactoringPreviewButtonExists: doesExist [
	<gtExample>
	| aCheck |

	aCheck := aScripterOrStep check
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRefactoringsPreviewButton.

	doesExist
		ifTrue: [
			aCheck
				exists;
				label: 'Check refactoring preview button exists' ]
		ifFalse: [
			aCheck
				notExists;
				label: 'Check refactoring preview button does not exist' ].

	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep renameEditorExists: doesExist [
	<gtExample>
	| aCheck |

	aCheck := aScripterOrStep check
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRenameEditor.

	doesExist
		ifTrue: [
			aCheck
				exists;
				label: 'Check rename editor exists' ]
		ifFalse: [
			aCheck
				notExists;
				label: 'Check rename editor does not exist' ].

	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep saveButtonEnabled: isEnabled [
	<gtExample>
	| aCheck |

	aCheck := aScripterOrStep check
		id: GtMethodCoderSaveActionId.

	isEnabled
		ifTrue: [
			aCheck
				satisfies: [ :aButton | aButton isEnabled ];
				label: 'Check save button is enabled' ]
		ifFalse: [
			aCheck
				satisfies: [ :aButton | aButton isDisabled ];
				label: 'Check save button is disbled' ].

	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep textAttributesAt: anIndex anySatisfies: aBlock [
	<gtExample>
	aScripterOrStep check
		label: 'Check Editor Text Attributes';
		anySatisfies: aBlock;
		onChildNamed: #editor;
		onBrTextEditor;
		onBrTextEditorText;
		onTextAttributesAt: anIndex.
	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep textAttributesAt: anIndex nonSatisfies: aBlock [
	<gtExample>
	aScripterOrStep check
		label: 'Check Editor Text Attributes';
		nonSatisfies: aBlock;
		onChildNamed: #editor;
		onBrTextEditor;
		onBrTextEditorText;
		onTextAttributesAt: anIndex.
	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep textExampleStatusAttributeAt: anIndex [
	<gtExample>
	self 
		checkFor: aScripterOrStep 
		textAttributesAt: anIndex 
		anySatisfies: [ :aTextAttribute | aTextAttribute class = GtCoderExampleStatusAttribute ].
	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> checkFor: aScripterOrStep textExpandAttributeAt: anIndex [
	<gtExample>
	self 
		checkFor: aScripterOrStep 
		textAttributesAt: anIndex 
		anySatisfies: [ :aTextAttribute | aTextAttribute isKindOf: BrGlamorousTrangleExpanderTextAttribute ].
	^ aScripterOrStep
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> coderOnMethod: aMethod [
	<gtExample>
	| aCoder |
	aCoder := self basicMethodCoder.
	aCoder forMethod: aMethod.
	self assert: aCoder selector equals: aMethod selector.
	self assert: aCoder behavior equals: aMethod methodClass.
	self assert: aCoder protocol equals: aMethod protocol.

	"a coder is not displayed and its source text is not initialized"
	self assert: aCoder sourceCode hasSourceText not.
	^ aCoder
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> collapseFromUI: aScripter method: aMethod [
	<gtExample>
	aScripter substep: 'Collapse and Check Coder' do: [ :aStep |
		aStep click
			label: 'Click on Expander';
			onChildAt: 1.
		aStep wait forEmptySpaceTaskQueue.

		aStep check 
			label: 'Check Coder UI is Expanded';
			satisfies: [ :aCoderElement | aCoderElement isExpanded not ].

		aStep check
			label: 'Check Coder Collapsed Label Text';
			value: [ :aLabelElement | aLabelElement text asString ] equals: [ aMethod selector ];
			id: GtSourceCoderCollapsedTextId ].

	^ aScripter
]

{ #category : #'examples - example method' }
GtPharoMethodCoderByScripterExamples >> exampleMethod [
	<gtExample>

	^ GtPharoMethodCoderExamples >> #sumMethod
]

{ #category : #'examples - example method' }
GtPharoMethodCoderByScripterExamples >> exampleMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self exampleMethod.
	aCoder := self coderOnMethod: aMethod.
	^ aCoder
]

{ #category : #'examples - example method' }
GtPharoMethodCoderByScripterExamples >> exampleMethodCoderUI [
	<gtExample>
	| aScripter |
	
	aScripter := self scripterForBlock: [ self exampleMethodCoder ].
	
	^ aScripter syncContinue
]

{ #category : #'examples - example method' }
GtPharoMethodCoderByScripterExamples >> exampleMethodCoderUI_CollapsedFromUI [
	<gtExample>
	| aScripter |
	aScripter := self exampleMethodCoderUI.
	self collapseFromUI: aScripter method: self exampleMethod.

	^ aScripter syncContinue
]

{ #category : #'examples - example method' }
GtPharoMethodCoderByScripterExamples >> exampleMethodCoderUI_ExpandedFromUI [
	<gtExample>
	| aScripter |
	aScripter := self exampleMethodCoderUI_CollapsedFromUI.
	self expandFromUI: aScripter method: self exampleMethod.

	^ aScripter syncContinue
]

{ #category : #'examples - example method' }
GtPharoMethodCoderByScripterExamples >> exampleMethodCoderUI_ExpandedFromUI_CheckActionButtons [
	<gtExample>
	| aScripter |
	aScripter := self exampleMethodCoderUI_ExpandedFromUI.
	self 
		checkFor: aScripter 
		numberOfMainActions: 5
		contextAction: 4.

	self checkFor: aScripter existenceOfContextActionNamed: 'Play Example'.
	self checkFor: aScripter existenceOfContextActionNamed: 'Play and Inspect Example Result'.

	^ aScripter syncContinue
]

{ #category : #'examples - example method' }
GtPharoMethodCoderByScripterExamples >> exampleMethodCoderUI_ExpandedFromUI_PlayAndInspect [
	<gtExample>
	| aScripter |

	aScripter := self exampleMethodCoderUI_ExpandedFromUI_CheckActionButtons.
	
	aScripter click
		label: 'Click play and inspect';
		id: GtMethodCoderPlayAndInspectExampleActionId.

	^ aScripter syncContinue
]

{ #category : #'examples - example method' }
GtPharoMethodCoderByScripterExamples >> exampleMethodCoderUI_ExpandedFromUI_RemovePragma [
	<gtExample>
	| aScripter |
	aScripter := self exampleMethodCoderUI_ExpandedFromUI.

	aScripter substeps: 'Remove Pragma' do: [ :aStep |
		aStep do
			label: 'Delete e character from <gtExample>';
			action: [ :anEditor | anEditor deleter from: 20 to: 21; delete ];
			onChildNamed: #editor;
			onBrTextEditor.
		self 
			checkFor: aStep
			numberOfMainActions: 6
			contextAction: 0.

		self checkFor: aStep absenceOfContextActionNamed: 'Play Example' ].

	^ aScripter syncContinue
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> expandFromUI: aScripter method: aMethod [
	<gtExample>
	aScripter substep: 'Expand and Check Coder' do: [ :aStep |
		aStep click
			label: 'Click on Expander';
			onChildAt: 1.

		aStep wait forEmptySpaceTaskQueue.

		aStep check 
			label: 'Check Coder UI is Expanded';
			satisfies: [ :aCoderElement | aCoderElement isExpanded ].

		aStep check
			label: 'Check Coder Editor Text';
			value: [ :anEditorElement | anEditorElement editor text asString ] equals: [ aMethod sourceCode ];
			onChildNamed: #editor ].

	^ aScripter
]

{ #category : #utilities }
GtPharoMethodCoderByScripterExamples >> extractedUnaryMethodNameFor: aMethodCoder [
	^ 'sub', (aMethodCoder attributeNamed: #fakeMethodName) capitalized
]

{ #category : #'examples - fixit class' }
GtPharoMethodCoderByScripterExamples >> fixitCreateClass_01_setup [
	<gtExample>
	| aScripter |

	aScripter := self scripterForBlock: [ self forUnaryMethodInPackagedClass ].
	aScripter do
		label: 'type in a class that does not exist';
		action: [ :aCoder | aCoder appendString: (String cr, String tab, '{1}ThatDoesNotExist' format: { (aCoder attributeNamed:  #fakeClassName) }) ];
		onModel.
		
	aScripter wait forEmptySpaceTaskQueue.
	^ aScripter syncContinue
]

{ #category : #'examples - fixit class' }
GtPharoMethodCoderByScripterExamples >> fixitCreateClass_02_click_fixit [
	<gtExample>
	| aScripter |

	aScripter := self fixitCreateClass_01_setup.
	
	"there is no context menu before clicking on the fixit button"
	aScripter check
		onSpaceRoot;
		onBreadthFirstChildOfClass: GtCoderContextMenuContent;
		notExists.
	
	aScripter click
		onBreadthFirstChildOfClass: GtFixItButton.

	aScripter wait forEmptySpaceTaskQueue.
	
	"now it appeared"
	aScripter check
		onSpaceRoot;
		onBreadthFirstChildOfClass: GtCoderContextMenuContent;
		exists.

	^ aScripter syncContinue
]

{ #category : #'examples - fixit class' }
GtPharoMethodCoderByScripterExamples >> fixitCreateClass_03_click_define_class [
	<gtExample>
	| aScripter |

	aScripter := self fixitCreateClass_02_click_fixit.
	
	"there is no create behavior element before clicking on the menu"
	aScripter check
		onBreadthFirstChildOfClass: GtCreateBehaviorElement;
		notExists.
	
	aScripter click
		onSpaceRoot;
		id: (GtDefineClassFixItActionElementId indexed: 1).

	aScripter wait forEmptySpaceTaskQueue.
	
	"now it appeared"
	aScripter check
		onBreadthFirstChildOfClass: GtCreateBehaviorElement;
		exists.
	
	"context menu should disappear"
	aScripter check
		onSpaceRoot;
		onBreadthFirstChildOfClass: GtCoderContextMenuContent;
		notExists.

	^ aScripter syncContinue
]

{ #category : #'examples - rename method' }
GtPharoMethodCoderByScripterExamples >> forKeywordRename_01_setup [
	<gtExample>
	| aScripter |

	aScripter := self scripterForBlock: [ self forKeywordMethodInPackagedClass ].
	aScripter click
		label: 'Click on the coder editor to give it focus';
		id: GtSourceCoderEditorId.

	aScripter shortcut
		combination: BlKeyCombination arrowUp;
		id: GtSourceCoderEditorId.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	self checkFor: aScripter saveButtonEnabled: true.
	self checkFor: aScripter discardButtonExists: false.
	
	aScripter check
		label: 'Check editor is focused';
		satisfies: [ :anEditorElement | anEditorElement isFocused ];
		id: GtSourceCoderEditorId.
	
	aScripter check
		label: 'Check cursor position';
		value: [ :anEditorElement | anEditorElement editor cursors positions ] equals: [ #(0) ];
		id: GtSourceCoderEditorId.

	^ aScripter syncContinue
]

{ #category : #'examples - rename method' }
GtPharoMethodCoderByScripterExamples >> forKeywordRename_02_shortcut [
	<gtExample>
	| aScripter |

	aScripter := self forKeywordRename_01_setup.
	
	aScripter shortcut
		combination: BlKeyCombination primaryR;
		id: GtSourceCoderEditorId.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	self checkFor: aScripter saveButtonEnabled: false.
	self checkFor: aScripter renameEditorExists: true.
	self checkFor: aScripter discardButtonExists: false.

	aScripter check
		label: 'Check rename editor all selected';
		value: [ :anEditor | anEditor editor selectedText asString ] equals: [ aScripter model attributeNamed: #fakeMethodName ];
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRenameEditor.

	^ aScripter syncContinue
]

{ #category : #'examples - rename method' }
GtPharoMethodCoderByScripterExamples >> forKeywordRename_03_move_cursor [
	<gtExample>
	| aScripter |

	aScripter := self forKeywordRename_02_shortcut.
	
	"this positions the cursor before `:`"
	aScripter keyClick: BlKeyboardKey arrowLeft.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	self checkFor: aScripter refactoringPreviewButtonExists: false.
	
	aScripter check
		label: 'Check cursor position';
		value: [ :anEditor | anEditor editor cursors positions ] equals: [ { (aScripter model attributeNamed: #fakeMethodName) size - 1 } ];
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRenameEditor.

	aScripter check
		label: 'Check rename editor all selected';
		value: [ :anEditor | anEditor editor selectedText asString ] equals: [ '' ];
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRenameEditor.

	^ aScripter syncContinue
]

{ #category : #'examples - rename method' }
GtPharoMethodCoderByScripterExamples >> forKeywordRename_04_type [
	<gtExample>
	| aScripter |

	aScripter := self forKeywordRename_03_move_cursor.

	aScripter type: 'New'.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	self checkFor: aScripter renameEditorExists: true.
	self checkFor: aScripter refactoringPreviewButtonExists: true.
	self checkFor: aScripter saveButtonEnabled: false.
	self checkFor: aScripter discardButtonExists: false.

	aScripter check
		label: 'Check text';
		value: [ :anEditor | anEditor text asString ] equals: [ (aScripter model attributeNamed: #fakeMethodName) allButLast, 'New:' ];
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRenameEditor.

	^ aScripter syncContinue
]

{ #category : #'examples - rename method' }
GtPharoMethodCoderByScripterExamples >> forKeywordRename_05_click_preview [
	<gtExample>
	| aScripter |

	aScripter := self forKeywordRename_04_type.

	aScripter click
		label: 'Click refactoring preview button';
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRefactoringsPreviewButton.

	aScripter wait forEmptySpaceTaskQueue.

	self checkFor: aScripter discardButtonExists: true.

	aScripter check
		label: 'Check that refactorings preview appeared';
		exists;
		onSpaceRoot;
		id: GtRefactoringsPreviewAcceptId.

	^ aScripter syncContinue
]

{ #category : #'examples - rename method' }
GtPharoMethodCoderByScripterExamples >> forKeywordRename_06_click_apply [
	<gtExample>
	| aScripter |

	aScripter := self forKeywordRename_05_click_preview.

	aScripter click
		label: 'Click refactorings apply button';
		onSpaceRoot;
		id: GtRefactoringsPreviewAcceptId.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	self checkFor: aScripter renameEditorExists: false.
	self checkFor: aScripter refactoringPreviewButtonExists: false.
	self checkFor: aScripter saveButtonEnabled: true.
	self checkFor: aScripter discardButtonExists: false.

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_01_setup [
	<gtExample>
	| aScripter |

	aScripter := self scripterForBlock: [ self forUnaryMethodInPackagedClass ].
	aScripter do
		label: 'type in a method with argument';
		action: [ :aCoder | aCoder appendString:
(': anObject
	{1} := anObject.
	{1} := {1} + 42.' format: { (aCoder attributeNamed:  #fakeInstVarNames) first })
		];
		onModel.

	aScripter do
		label: 'Save a method with argument';
		action: [ :aCoder | aCoder save ];
		onModel.
		
	aScripter wait forEmptySpaceTaskQueue.

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_02_select [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryExtraction_01_setup.
	aScripter do
		label: 'Select part of the method to extract';
		action: [ :aSourceEditor |
			aSourceEditor selecter
				from: 42 to: 67;
				select ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.

	aScripter wait forEmptySpaceTaskQueue.
	
	aScripter check
		label: 'Check selected text';
		value: [ :aSourceEditor | aSourceEditor editor selectedText asString ]
			equals: [ '{1} := {1} + 42' format: { (aScripter model attributeNamed:  #fakeInstVarNames) first } ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_03_context_menu [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryExtraction_02_select.
	aScripter secondaryClick
		label: 'Open context menu';
		onChildNamed: GtPharoSourceCoder sourceEditorName.

	aScripter wait forEmptySpaceTaskQueue.

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_04_hover_extract_method [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryExtraction_03_context_menu.

	aScripter mouseMoveOver
		label: 'Hover extract method';
		onSpaceRoot;
		id: GtMethodCoderExtractMethodContextMenuItemId.

	aScripter wait forEmptySpaceTaskQueue.

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_05_click_extract_method [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryExtraction_04_hover_extract_method.

	aScripter click
		label: 'Click extract method';
		onSpaceRoot;
		onChildNamed: GtMethodCoderExtractMethodContextMenuItemId.

	aScripter wait forEmptySpaceTaskQueue.
	
	aScripter check
		label: 'Check current source in coder model';
		value: [ :aCoder | aCoder currentSourceString ] equals: [ :aCoder |
('{1}: anObject
	{2} := anObject.
	self _' format: {
		aCoder attributeNamed: #fakeMethodName.
		(aCoder attributeNamed:  #fakeInstVarNames) first
	}) ];
		onModel.
		
	aScripter check
		label: 'Check source code modified';
		satisfies: [ :aCoder | aCoder isModified ];
		onModel.
	
	aScripter check
		label: 'Check rename editor attribute';
		value: [ :aCoderEditor |
			aCoderEditor text
				findAttributeSuchThat: [ :eachAttribute | eachAttribute class = GtRenameEditorAttribute ]
				indicesDo: [ :aStart :anEnd | aStart to: anEnd ] ]
			equals: [ 48 to: 48 ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.

	aScripter check
		label: 'Check refactoring changes attribute';
		value: [ :aCoderEditor |
			aCoderEditor text
				findAttributeSuchThat: [ :eachAttribute | eachAttribute class = GtRefactoringChangesAttribute ]
				indicesDo: [ :aStart :anEnd | aStart to: anEnd ] ]
			equals: [ 48 to: 48 ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.
		
	aScripter check
		label: 'Check source editor is not focused';
		satisfies: [ :aCoderEditor | aCoderEditor isFocused not ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.
		
	aScripter check
		label: 'Check source editor has focus';
		satisfies: [ :aCoderEditor | aCoderEditor hasFocus ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.
	
	aScripter check
		label: 'Check method name editor source code';
		value: [ :aNameEditor | aNameEditor text asString ] equals: '_';
		onChildNamed: GtPharoSourceCoder sourceEditorName;
		onBreadthFirstChildOfClass: GtRenameEditor.
		
	aScripter check
		label: 'Check method name editor selected text';
		value: [ :aNameEditor | aNameEditor editor selectedText asString ] equals: '_';
		onChildNamed: GtPharoSourceCoder sourceEditorName;
		onBreadthFirstChildOfClass: GtRenameEditor.

	aScripter check
		label: 'Check method name editor has focus';
		satisfies: [ :aNameEditor | aNameEditor isFocused ];
		onChildNamed: GtPharoSourceCoder sourceEditorName;
		onBreadthFirstChildOfClass: GtRenameEditor.

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_06_type_method_name [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryExtraction_05_click_extract_method.

	aScripter type: 'sub', (aScripter model attributeNamed: #fakeMethodName) capitalized.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	"aScripter check
		label: 'Check refactoring changes attribute';
		value: [ :aCoderEditor |
			aCoderEditor text
				findAttributeSuchThat: [ :eachAttribute | eachAttribute class = GtRefactoringChangesAttribute ]
				indicesDo: [ :aStart :anEnd | aStart to: anEnd ] ]
			equals: [ 48 to: 48 ];
		onChildNamed: GtSourceCoder sourceEditorName."

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_07_01_accept_with_enter [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryExtraction_06_type_method_name.

	aScripter keyClick: BlKeyboardKey return.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	aScripter check
		label: 'Check current source in coder model';
		value: [ :aCoder | aCoder currentSourceString ] equals: [ :aCoder |
('{1}: anObject
	{2} := anObject.
	self {3}' format: {
		aCoder attributeNamed: #fakeMethodName.
		(aCoder attributeNamed:  #fakeInstVarNames) first.
		self extractedUnaryMethodNameFor: aCoder
	}) ];
		onModel.
		
	aScripter check
		label: 'Check source code modified';
		satisfies: [ :aCoder | aCoder isModified ];
		onModel.
	
	aScripter check
		label: 'Check rename editor attribute';
		value: [ :aCoderEditor |
			aCoderEditor text
				hasAttributeSuchThat: [ :eachAttribute | eachAttribute class = GtRenameEditorAttribute ] ]
			equals: false;
		onChildNamed: GtPharoSourceCoder sourceEditorName.

	aScripter check
		label: 'Check refactoring changes attribute';
		value: [ :aCoderEditor |
			aCoderEditor text
				findAttributeSuchThat: [ :eachAttribute | eachAttribute class = GtRefactoringChangesAttribute ]
				indicesDo: [ :aStart :anEnd | aStart to: anEnd ] ]
			equals: [ 57 to: 57 ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.
		
	aScripter check
		label: 'Check source editor is focused';
		satisfies: [ :aCoderEditor | aCoderEditor isFocused ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_08_preview_refactoring [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryExtraction_07_01_accept_with_enter.

	aScripter click
		onBreadthFirstChildOfClass: GtRefactoringsPreviewButton.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	aScripter check
		onSpaceRoot;
		id: GtRefactoringsPreviewAcceptId;
		exists.

	^ aScripter syncContinue
]

{ #category : #'examples - extract method' }
GtPharoMethodCoderByScripterExamples >> forUnaryExtraction_09_apply_refactoring [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryExtraction_08_preview_refactoring.

	aScripter click
		onSpaceRoot;
		id: GtRefactoringsPreviewAcceptId.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	aScripter check
		label: 'Check refactoring changes attribute does not exist';
		value: [ :aCoderEditor |
			aCoderEditor text
				findAttributeSuchThat: [ :eachAttribute | eachAttribute class = GtRefactoringChangesAttribute ]
				indicesDo: [ :aStart :anEnd | aStart to: anEnd ] ]
			equals: [ nil ];
		onChildNamed: GtPharoSourceCoder sourceEditorName.

	aScripter check
		onBreadthFirstChildOfClass: GtRefactoringsPreviewButton;
		notExists.

	^ aScripter syncContinue
]

{ #category : #'examples - rename method' }
GtPharoMethodCoderByScripterExamples >> forUnaryRename_01_setup [
	<gtExample>
	| aScripter |

	aScripter := self scripterForBlock: [ self forUnaryMethodInPackagedClass ].
	aScripter click
		label: 'Click on the coder editor to give it focus';
		id: GtSourceCoderEditorId.

	aScripter shortcut
		combination: BlKeyCombination arrowUp;
		id: GtSourceCoderEditorId.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	aScripter check
		label: 'Check editor is focused';
		satisfies: [ :anEditorElement | anEditorElement isFocused ];
		id: GtSourceCoderEditorId.
	
	aScripter check
		label: 'Check cursor position';
		value: [ :anEditorElement | anEditorElement editor cursors positions ] equals: [ #(0) ];
		id: GtSourceCoderEditorId.

	^ aScripter syncContinue
]

{ #category : #'examples - rename method' }
GtPharoMethodCoderByScripterExamples >> forUnaryRename_02_shortcut [
	<gtExample>
	| aScripter |

	aScripter := self forUnaryRename_01_setup.
	
	aScripter shortcut
		combination: BlKeyCombination primaryR;
		id: GtSourceCoderEditorId.
	
	aScripter wait forEmptySpaceTaskQueue.
	
	aScripter check
		label: 'Check rename editor exists';
		exists;
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRenameEditor.

	aScripter check
		label: 'Check rename editor all selected';
		value: [ :anEditor | anEditor editor selectedText asString ] equals: [ aScripter model attributeNamed: #fakeMethodName ];
		id: GtSourceCoderEditorId;
		onBreadthFirstChildOfClass: GtRenameEditor.

	^ aScripter syncContinue
]

{ #category : #'examples - basic' }
GtPharoMethodCoderByScripterExamples >> methodCoder [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter set model: [ self basicMethodCoder ].
	^ aScripter
]

{ #category : #'examples - pattern highlighter' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterMethod [
	<gtExample>
	^ GtPharoMethodCoderExamples >> #a:a:a:a:
]

{ #category : #'examples - pattern highlighter' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self patternHighlighterMethod.
	aCoder := self coderOnMethod: aMethod.
	aCoder highlighter: (GtPharoImplementorPatternHighlighter forPattern: 'a:').
	^ aCoder
]

{ #category : #'examples - pattern highlighter' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripterForBlock: [ self patternHighlighterMethodCoder ].
	^ aScripter syncContinue
]

{ #category : #'examples - pattern highlighter' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterMethodCoderUI_CheckUndelineAttributes [
	<gtExample>
	| aScripter |
	aScripter := self patternHighlighterMethodCoderUI.
	aScripter checks: 'Check Pattern Highlighter Source Code Style' do: [ :aStep |
		self checkFor: aStep textAttributesAt: 2 anySatisfies: [ :aTextAttribute | aTextAttribute class = BlTextDecorationAttribute ].
		self checkFor: aStep numberfOfTextAttributes: 8 OfType: BlTextDecorationAttribute.
	].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - pattern highlither - print' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterPrintMethod [
	<gtExample>

	^ GtPharoMethodCoderExamples >> #printStringReference
]

{ #category : #'examples - pattern highlither - print' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterPrintMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self patternHighlighterPrintMethod.
	aCoder := self coderOnMethod: aMethod.
	aCoder highlighter: (GtPharoImplementorPatternHighlighter forPattern: 'print').
	^ aCoder
]

{ #category : #'examples - pattern highlither - print' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterPrintMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripterForBlock: [ self patternHighlighterPrintMethodCoder ].
	^ aScripter syncContinue
]

{ #category : #'examples - pattern highlither - print' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterPrintMethodCoderUI_CheckUndelineAttributes [
	<gtExample>
	| aScripter |
	aScripter := self patternHighlighterPrintMethodCoderUI.
	aScripter checks: 'Check Pattern Highlighter Source Code Style' do: [ :aStep |
		self checkFor: aStep textAttributesAt: 1 anySatisfies: [ :aTextAttribute | aTextAttribute class = BlTextDecorationAttribute ].
		self checkFor: aStep numberfOfTextAttributes: 5 OfType: BlTextDecorationAttribute.
		self checkFor: aStep textAttributesAt: 30 nonSatisfies: [ :aTextAttribute | aTextAttribute class = BlTextDecorationAttribute ].
	].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - reference highlighter' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterPrintStringMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self patternHighlighterPrintMethod.
	aCoder := self coderOnMethod: aMethod.
	aCoder highlighter: (GtPharoSelectorReferenceAndLiteralHighlighter forSelector: #printString).
	^ aCoder
]

{ #category : #'examples - reference highlighter' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterPrintStringMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripterForBlock: [ self patternHighlighterPrintStringMethodCoder ].
	^ aScripter syncContinue
]

{ #category : #'examples - reference highlighter' }
GtPharoMethodCoderByScripterExamples >> patternHighlighterPrintStringMethodCoderUI_CheckUndelineAttributes [
	<gtExample>
	| aScripter |
	aScripter := self patternHighlighterPrintStringMethodCoderUI.
	aScripter checks: 'Check Pattern Highlighter Source Code Style' do: [ :aStep |
		self checkFor: aStep textAttributesAt: 1 nonSatisfies: [ :aTextAttribute | aTextAttribute class = BlTextDecorationAttribute ].
		self checkFor: aStep textAttributesAt: 30 anySatisfies: [ :aTextAttribute | aTextAttribute class = BlTextDecorationAttribute ].
		self checkFor: aStep numberfOfTextAttributes: 11 OfType: BlTextDecorationAttribute.
	].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - referenced example' }
GtPharoMethodCoderByScripterExamples >> referencedExampleMethod [
	<gtExample>
	^ GtPharoMethodCoderExamples >> #b
]

{ #category : #'examples - referenced example' }
GtPharoMethodCoderByScripterExamples >> referencedExampleMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self referencedExampleMethod.
	aCoder := self coderOnMethod: aMethod.
	^ aCoder
]

{ #category : #'examples - referenced example' }
GtPharoMethodCoderByScripterExamples >> referencedExampleMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripterForBlock: [ self referencedExampleMethodCoder ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - referenced example' }
GtPharoMethodCoderByScripterExamples >> referencedExampleMethodCoderUI_CheckExampleAttribute [
	<gtExample>
	| aScripter |
	aScripter := self referencedExampleMethodCoderUI.
	aScripter checks: 'Check Example Status' do: [ :aStep | 
		self checkFor: aStep textExampleStatusAttributeAt: 1 ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - referenced example' }
GtPharoMethodCoderByScripterExamples >> referencedExampleMethodCoderUI_CheckExampleExpandAttribute [
	<gtExample>
	| aScripter |
	aScripter := self referencedExampleMethodCoderUI.
	aScripter checks: 'Check Example Status and Expand Attribute' do: [ :aStep | 
		self checkFor: aStep textExpandAttributeAt: 24.
		self checkFor: aStep textExampleStatusAttributeAt: 1 ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - referenced example' }
GtPharoMethodCoderByScripterExamples >> referencedExampleMethodCoderUI_NoExampleStatusAfterPragmaDeletion [
	<gtExample>
	| aScripter |
	aScripter := self referencedExampleMethodCoderUI.
	aScripter substeps: 'Remove Pragma' do: [ :aStep |
		aStep do
			label: 'Delete e character from <gtExample>';
			action: [ :anEditor | anEditor deleter from: 12 to: 13; delete ];
			onChildNamed: #editor;
			onBrTextEditor.
		self 
			checkFor: aStep
			numberOfMainActions: 6
			contextAction: 0.
		self checkFor: aStep absenceOfContextActionNamed: 'Play Example' ].
	aScripter checks: 'Check Example Status Is Not Present' do: [ :aStep | 
		self checkFor: aStep textExpandAttributeAt: 23.
		self 
			checkFor: aStep 
			textAttributesAt: 1 
			nonSatisfies: [ :aTextAttribute | aTextAttribute class = GtCoderExampleStatusAttribute ] ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - referenced example' }
GtPharoMethodCoderByScripterExamples >> referencedExampleMethodCoderUI_NoExampleStatusAfterPragmaDeletion_WriteExamplePragma [
	<gtExample>
	| aScripter |
	aScripter := self referencedExampleMethodCoderUI_NoExampleStatusAfterPragmaDeletion.
	aScripter substeps: 'Insert Pragma' do: [ :aStep |
		aStep do
			label: 'Insert e character in <gtExample>';
			action: [ :anEditor | anEditor inserter at: 12; string: 'e'; insert ];
			onChildNamed: #editor;
			onBrTextEditor.
		aStep wait forEmptySpaceTaskQueue.
		self 
			checkFor: aStep
			numberOfMainActions: 5
			contextAction: 4.
		self checkFor: aStep existenceOfContextActionNamed: 'Play Example' ].
	aScripter checks: 'Check Example Status Is Present' do: [ :aStep | 
		self checkFor: aStep textExpandAttributeAt: 24.
		self checkFor: aStep textExampleStatusAttributeAt: 1. ].
	aScripter syncContinue.
	^ aScripter
]
