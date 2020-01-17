Class {
	#name : #GtMethodCoderByScripterExamples,
	#superclass : #GtCoderExamples,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'sample methods' }
GtMethodCoderByScripterExamples >> ? anObject [
	"Test binary method"
]

{ #category : #'sample methods' }
GtMethodCoderByScripterExamples >> a: arg1 a: arg2 a: arg3 a: arg4 [
	"test method for highlighting implementors"
]

{ #category : #'examples - basic' }
GtMethodCoderByScripterExamples >> basicMethodCoder [
	<gtExample>
	| aCoder |
	aCoder := GtMethodCoder new.
	self assert: aCoder selector isNil.
	self assert: aCoder classOrMetaClass equals: UndefinedObject.
	self assert: aCoder category isNil.
	self assert: aCoder source isString.
	self assert: aCoder source isEmpty.
	^ aCoder
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethod [
	<gtExample>
	^ self class >> #?
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self binaryMethod.
	aCoder := self coderOnMethod: aMethod.
	^ aCoder
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripterForBlock: [ self binaryMethodCoder ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_CollapsedByDefault [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter checks: 'Check Sources' do: [ :aStep |
		aStep check
			label: 'Check Expanded Source';
			satisfies: [ :aCoder | aCoder source = self binaryMethod sourceCode ];
			onModel.
		aStep check
			label: 'Check Collapsed Source';
			satisfies: [ :aCoder | aCoder collapsedSource = '? anObject' ];
			onModel.
		aStep check
			label: 'Check Coder Editor Text';
			satisfies: [ :anEditorElement | anEditorElement editor text asString = '? anObject' ];
			onChildNamed: #editor.
		aStep check 
			label: 'Check Coder UI is Collapsed';
			satisfies: [ :aCoderElement | aCoderElement isExpanded not ] 
		].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_CollapsedByDefault_BreadcrumbContent [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter checks: 'Check Breadcrumb' do: [ :aStep | 
		aStep  check 
			label: 'Check Breadcrumb Package Name';
			satisfies: [ :aButton | aButton label asString = self class package name ];
			onChildAt: 2;
			onChildOfClass: GtCoderContentElement;
			onChildAt: 1;
			onChildOfClass: BrBreadcrumb;
			onChildAt: 1.
		aStep  check 
			label: 'Check Breadcrumb Class Name';
			satisfies: [ :aButton | aButton label asString = self className ];
			onChildAt: 2;
			onChildOfClass: GtCoderContentElement;
			onChildAt: 1;
			onChildOfClass: BrBreadcrumb;
			onChildAt: 3.
		].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_CollapsedByDefault_BreadcrumbOnClassNameClick [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter substeps: 'Click On Breadcrumb' do: [ :aStep |
		aStep click
			label: 'Click On Class Name';
			onChildAt: 2;
			onChildOfClass: GtCoderContentElement;
			onChildAt: 1;
			onChildOfClass: BrBreadcrumb;
			onChildAt: 3.
		aStep  check 
			label: 'Check Triggered Spawn Object Event';
			satisfies: [ :theScripter | theScripter events reversed 
				detectEventOfClass: GtPhlowObjectToSpawn
				ifFound: [ :theEvent | theEvent object class = GtClassCoder and: [ theEvent object theClass = self class ] ]
				ifNone: [ AssertionFailure signal: GtPhlowObjectToSpawn name, ' event was not found' ]  ];
			onScripter.
		].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_CollapsedByDefault_BreadcrumbOnPackageClick [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter substeps: 'Click On Breadcrumb' do: [ :aStep |
		aStep click
			label: 'Click On Package Name';
			onChildAt: 2;
			onChildOfClass: GtCoderContentElement;
			onChildAt: 1;
			onChildOfClass: BrBreadcrumb;
			onChildAt: 1.
		aStep  check 
			label: 'Check Triggered Spawn Object Event';
			satisfies: [ :theScripter | theScripter events reversed 
				detectEventOfClass: GtPhlowObjectToSpawn
				ifFound: [ :theEvent | theEvent object class = RPackage and: [ theEvent object name = self class package name ] ]
				ifNone: [ AssertionFailure signal: GtPhlowObjectToSpawn name, ' event was not found' ]  ];
			onScripter.
		].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_CollapsedFromUI [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_ExpandedFromUI.
	aScripter substep: 'Collapse and Check Coder' do: [ :aStep |
		aStep click
			label: 'Click on Expander';
			onChildAt: 1.
		aStep check
			label: 'Check Coder Editor Text';
			satisfies: [ :anEditorElement | anEditorElement editor text asString = '? anObject' ];
			onChildNamed: #editor.
		aStep check 
			label: 'Check Coder UI Is Collapsed';
			satisfies: [ :aCoderElement | aCoderElement isExpanded not ] ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_ExpandedFromModel [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter substep: 'Expand and Check Coder' do: [ :aStep |
		aStep do
			label: 'Expand Coder';
			action: [ :aCoder | aCoder expanded: true ];
			onModel.
		aStep check
			label: 'Check Coder Editor Text';
			satisfies: [ :anEditorElement | anEditorElement editor text asString = self binaryMethod sourceCode ];
			onChildNamed: #editor.
		aStep wait forEmptySpaceTaskQueue ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_ExpandedFromUI [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	self expandFromUI: aScripter method: self binaryMethod.
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_ExpandedFromUI_CheckActionButtons [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_ExpandedFromUI.
	self 
		checkFor: aScripter 
		numberOfMainActions: 2 
		contextAction: 0.
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_ExpandedFromUI_CodeStyle [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_ExpandedFromUI.
	aScripter checks: 'Check Expanded Source Code Style' do: [ :aStep |
		aStep check
			label: 'Check Method Name Attributes';
			anySatisfies: [ :aTextAttribute | aTextAttribute = BlFontGenericFamilyAttribute monospace ];
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
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_WithoutExampleActions [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI_ExpandedFromModel.
	self 
		checkFor: aScripter 
		numberOfMainActions: 2
		contextAction: 0.
	self checkFor: aScripter absenceOfContextActionNamed: 'Play'.
	aScripter syncContinue.
	^ aScripter
]

{ #category : #utilities }
GtMethodCoderByScripterExamples >> checkFor: aScripter absenceOfContextActionNamed: anActionName [
	<gtExample>
	aScripter check 
			label: 'Check Context Action Existence Named ', anActionName asString;
			nonSatisfies: [ :aContextActions | aContextActions title = anActionName translated
				and: [ aContextActions action method = (GtMethodCoder>>#exampleAstFor:into:) ] ];
			onModel;
			onChildFromMessage: #contextActions.
	^ aScripter
]

{ #category : #utilities }
GtMethodCoderByScripterExamples >> checkFor: aScripter existenceOfContextActionNamed: anActionName [
	<gtExample>
	aScripter check 
			label: 'Check Context Action Existence Named ', anActionName asString;
			anySatisfies: [ :aContextActions | aContextActions title = anActionName translated
				and: [ aContextActions action method = (GtMethodCoder>>#exampleAstFor:into:) ] ];
			onModel;
			onChildFromMessage: #contextActions.
	^ aScripter
]

{ #category : #utilities }
GtMethodCoderByScripterExamples >> checkFor: aScripter numberOfMainActions: aMainActionsCount contextAction: anAddonsActionsCount [
	<gtExample>
	aScripter substeps: 'Check Available Action Buttons' do: [ :aStep |
		aStep wait forEmptySpaceTaskQueue.
		aStep check 
			label: 'Number of main actions';
			childrenCount: aMainActionsCount;
			onChildAt: 2;
			onChildOfClass: GtCoderContentElement;
			onChildOfClass: GtCoderActionsElement;
			onChildAt: 1.
		aStep check 
			label: 'Number of addons actions';
			childrenCount: anAddonsActionsCount;
			onChildAt: 2;
			onChildOfClass: GtCoderContentElement;
			onChildOfClass: GtCoderActionsElement;
			onChildAt: 3.
		].
	^ aScripter
]

{ #category : #utilities }
GtMethodCoderByScripterExamples >> checkFor: aScripterOrStep numberfOfTextAttributes: aNumber OfType: aClass [
	<gtExample>
	aScripterOrStep check
		label: 'Check Editor Text Attributes';
		satisfies: [ :aText | 
			| anIterator aCounter |
			aCounter := 0.
			anIterator := aText iterator.
			[ anIterator hasNext ] whileTrue: [ (anIterator attributes 
				anySatisfy: [ :eachAttribute | eachAttribute class = aClass ]) ifTrue: [ aCounter := aCounter + 1 ].
				anIterator next ].
			aCounter = aNumber ];
		onChildNamed: #editor;
		onBrTextEditor;
		onBrTextEditorText.
	^ aScripterOrStep
]

{ #category : #utilities }
GtMethodCoderByScripterExamples >> checkFor: aScripterOrStep textAttributes: anIndex anySatisfies: aBlock [
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
GtMethodCoderByScripterExamples >> coderOnMethod: aMethod [
	<gtExample>
	| aCoder |
	aCoder := self basicMethodCoder.
	aCoder forMethod: aMethod.
	self assert: aCoder selector equals: aMethod selector.
	self assert: aCoder classOrMetaClass equals: aMethod methodClass.
	self assert: aCoder category equals: aMethod protocol.
	self assert: aCoder source isString.
	self assert: aCoder expanded not.
	"Source code is empty as Coder is not displayed yet."
	self assert: aCoder isBuilt not.
	self assert: aCoder source isEmpty.
	self assert: aCoder collapsedSource isEmpty.
	^ aCoder
]

{ #category : #'examples - examle method' }
GtMethodCoderByScripterExamples >> exampleMethod [
	<gtExample>
	^ self class >> #sumMethod
]

{ #category : #'examples - examle method' }
GtMethodCoderByScripterExamples >> exampleMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self exampleMethod.
	aCoder := self coderOnMethod: aMethod.
	^ aCoder
]

{ #category : #'examples - examle method' }
GtMethodCoderByScripterExamples >> exampleMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripterForBlock: [ self exampleMethodCoder ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - examle method' }
GtMethodCoderByScripterExamples >> exampleMethodCoderUI_ExpandedFromUI [
	<gtExample>
	| aScripter |
	aScripter := self exampleMethodCoderUI.
	self expandFromUI: aScripter method: self exampleMethod.
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - examle method' }
GtMethodCoderByScripterExamples >> exampleMethodCoderUI_ExpandedFromUI_CheckActionButtons [
	<gtExample>
	| aScripter |
	aScripter := self exampleMethodCoderUI_ExpandedFromUI.
	self 
		checkFor: aScripter 
		numberOfMainActions: 2 
		contextAction: 3.
	self checkFor: aScripter existenceOfContextActionNamed: 'Play'.
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - examle method' }
GtMethodCoderByScripterExamples >> exampleMethodCoderUI_ExpandedFromUI_RemovePragma [
	<gtExample>
	<noTest>
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
			numberOfMainActions: 3
			contextAction: 0.
		self checkFor: aStep absenceOfContextActionNamed: 'Play' ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #utilities }
GtMethodCoderByScripterExamples >> expandFromUI: aScripter method: aMethod [
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
			satisfies: [ :anEditorElement | anEditorElement editor text asString = aMethod sourceCode ];
			onChildNamed: #editor.
		aStep wait forEmptySpaceTaskQueue ].
	^ aScripter
]

{ #category : #'examples - basic' }
GtMethodCoderByScripterExamples >> methodCoder [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter set model: [ self basicMethodCoder ].
	^ aScripter
]

{ #category : #'examples - pattern highlighter' }
GtMethodCoderByScripterExamples >> patternHighlighterMethod [
	<gtExample>
	^ self class >> #a:a:a:a:
]

{ #category : #'examples - pattern highlighter' }
GtMethodCoderByScripterExamples >> patternHighlighterMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self patternHighlighterMethod.
	aCoder := self coderOnMethod: aMethod.
	aCoder highlighter: (GtImplementorPatternHighlighter forPattern: ':a:').
	^ aCoder
]

{ #category : #'examples - pattern highlighter' }
GtMethodCoderByScripterExamples >> patternHighlighterMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripterForBlock: [ self patternHighlighterMethodCoder ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - pattern highlighter' }
GtMethodCoderByScripterExamples >> patternHighlighterMethodCoderUI_Expanded [
	<gtExample>
	| aScripter |
	aScripter := self patternHighlighterMethodCoderUI.
	self expandFromUI: aScripter method: self patternHighlighterMethod.
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - pattern highlighter' }
GtMethodCoderByScripterExamples >> patternHighlighterMethodCoderUI_Expanded_CheckUndelineAttributes [
	<gtExample>
	| aScripter |
	aScripter := self patternHighlighterMethodCoderUI_Expanded.
	aScripter checks: 'Check Pattern Highlighter Source Code Style' do: [ :aStep |
		self checkFor: aStep textAttributes: 2 anySatisfies: [ :aTextAttribute | aTextAttribute class = BlTextUnderlineAttribute ].
		self checkFor: aStep numberfOfTextAttributes: 6 OfType: BlTextUnderlineAttribute.
	].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #utilities }
GtMethodCoderByScripterExamples >> scripterForBlock: aBlock [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter substep: 'Initialize Coder Model and UI' do: [ :aStep | 
		aStep set 
			label: 'Initialize Coder Model';
			model: aBlock.
		aStep set 
			label: 'Initialize Coder UI';
			element: [ :aCoder | aCoder asElement ];
			onModel ].
	^ aScripter
]

{ #category : #'sample methods' }
GtMethodCoderByScripterExamples >> sumMethod [
	<gtExample>
	"sum two numbers"
	self assert: 21 + 21 equals: 42.
	^ 42
]
