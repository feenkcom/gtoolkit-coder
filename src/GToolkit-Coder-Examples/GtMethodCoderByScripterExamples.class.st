Class {
	#name : #GtMethodCoderByScripterExamples,
	#superclass : #GtCoderExamples,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'sample methods' }
GtMethodCoderByScripterExamples >> ? anObject [
	"Test binary method"
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
	aCoder := self basicMethodCoder.
	aCoder forMethod: aMethod.
	self assert: aCoder selector equals: '?'.
	self assert: aCoder classOrMetaClass equals: self class.
	self assert: aCoder category equals: aMethod protocol.
	self assert: aCoder source isString.
	self assert: aCoder expanded not.
	"Source code is empty as Coder is not displayed yet."
	self assert: aCoder isBuilt not.
	self assert: aCoder source isEmpty.
	self assert: aCoder collapsedSource isEmpty.
	^ aCoder
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter substep: 'Initialize Model and UI' do: [ :aStep | 
		aStep set 
			label: 'Initialize Coder';
			model: [ self binaryMethodCoder ].
		aStep set 
			label: 'Initialize Coder UI';
			element: [ :aCoder | aCoder asElement ];
			onModel ].
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
	aScripter substep: 'Expand and Check Coder' do: [ :aStep |
		aStep click
			label: 'Click on Expander';
			onChildAt: 1.
		aStep check 
			label: 'Check Coder UI is Expanded';
			satisfies: [ :aCoderElement | aCoderElement isExpanded ].
		aStep check
			label: 'Check Coder Editor Text';
			satisfies: [ :anEditorElement | anEditorElement editor text asString = self binaryMethod sourceCode ];
			onChildNamed: #editor.
		aStep wait forEmptySpaceTaskQueue ].
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

{ #category : #'examples - basic' }
GtMethodCoderByScripterExamples >> methodCoder [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter set model: [ self basicMethodCoder ].
	^ aScripter
]
