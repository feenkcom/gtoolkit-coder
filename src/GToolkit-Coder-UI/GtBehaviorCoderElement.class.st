Class {
	#name : #GtBehaviorCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'behaviorCoderUIModel',
		'container',
		'contentPane',
		'contentTabs'
	],
	#category : #'GToolkit-Coder-UI-Coder - Behavior'
}

{ #category : #callbacks }
GtBehaviorCoderElement >> actOnPackageUpdated: ann [
	self removeContentTabs
]

{ #category : #callbacks }
GtBehaviorCoderElement >> actOnSelectMethod: aMethod [
	| tab selectTabBlock selectMethodBlock |
	tab := contentTabs viewModel tabs
		detect: [ :each | each widget label asString = 'Methods' ]
		ifNone: [ ^ self ].
	tab isSelected
		ifFalse: [ selectTabBlock := [ tab select ].
			self executeTask: selectTabBlock ].
	selectMethodBlock := [ self selectAndScrollToMethod: aMethod ].
	self executeTask: selectMethodBlock
]

{ #category : #accessing }
GtBehaviorCoderElement >> behavior [
	<return: #Behavior>

	^ self coderUIModel coder behavior
]

{ #category : #callbacks }
GtBehaviorCoderElement >> browseClassReferences [
	| classCoder |
	classCoder := behaviorCoderUIModel coder.

	classCoder theClass
		ifNotNil: [ :class | self phlow spawnObject: class gtReferences ]
]

{ #category : #'building ui' }
GtBehaviorCoderElement >> buildClassLabel [
	| classCoder aClassNameEditor aContainer aPreviewButton removeClassButton |
	classCoder := behaviorCoderUIModel coder.

	aContainer := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	
	aClassNameEditor := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
			defaultBackground: Color transparent;
			glamorousCodeFont;
			bold;
			fontSize: 18);
		inputFilter: BrTextEditorClassNameInputFilter new;
		text: (classCoder name);
		margin: (BlInsets all: 0);
		containerName: GtBehaviorCoder behaviorNameEditorName;
		whenKey: BlKeyCombination primaryN
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | aCoderElement browseClassReferences ]
			with: self;
		whenKey: BlKeyCombination primaryB
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | aCoderElement phlow spawnTool: (GtClassCoderTool observedClass: aCoderElement behavior) ]
			with: self;
		whenKey: BlKeyCombination primaryG
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | aCoderElement phlow spawnObject: aCoderElement behavior ]
			with: self;
		whenKey: BlKeyCombination primaryR
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | 
				anEvent currentTarget switchToEditor ]
			with: self;
		whenKey: BlKeyCombination primaryC
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | 
				Clipboard clipboardText: aCoderElement behavior name asString ]
			with: self.
	
	(GtCompletionController
		on: aClassNameEditor
		strategy: (GtClassesCompletionStrategy new)) install.

	aPreviewButton := GtRefactoringsPreviewButton new
		margin: (BlInsets left: 5);
		visibility: BlVisibility gone;
		refactorings: [ { RBRenameClassWithCommentsRefactoring
			model: RBNamespace new
			rename: classCoder theClass
			to: aClassNameEditor text asString } ];
		when: GtRefactoringsAppliedEvent do: [ :anEvent | anEvent currentTarget visibility: BlVisibility hidden ].
		
	aClassNameEditor editor
		when: BrTextEditorModifiedEvent 
		do: [ :anEvent |
			anEvent text asString = classCoder name
				ifTrue: [ aPreviewButton visibility: BlVisibility gone ]
				ifFalse: [  aPreviewButton visibility: BlVisibility visible ] ].

	removeClassButton := GtPreviewChangeButton new
		icon: BrGlamorousVectorIcons remove;
		label: 'Remove';
		changeAction: [ self removeClass ];
		changeStencil: [ self buildRemoveClassLabel ].

	aContainer addChild: aClassNameEditor.
	aContainer addChild: aPreviewButton.
	aContainer addChild: removeClassButton.

	^ aContainer
]

{ #category : #'building ui' }
GtBehaviorCoderElement >> buildContentPane [

	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	contentPane padding: (BlInsets top: 5 left: 6 bottom: 5 right: 6).
	contentPane addChild: self buildClassLabel.
	contentPane addChild: self buildDefinitionElement.
	contentPane addChild: self buildContentTabs.

	^ contentPane
]

{ #category : #'building ui' }
GtBehaviorCoderElement >> buildContentTabs [
	<return: #BrTabGroup>

	contentTabs := GtPhlowCompositeView new
		views: self classViewItems;
		asElementDo: [ :aBrTabGroup | aBrTabGroup ].

	^ contentTabs
]

{ #category : #'building ui' }
GtBehaviorCoderElement >> buildDefinitionElement [

	^ GtBehaviorDefinitionCoderElement new
		coderUIModel: behaviorCoderUIModel definitionCoderUIModel;
		margin: (BlInsets top: 5 left: 5)
]

{ #category : #'building ui' }
GtBehaviorCoderElement >> buildRemoveClassLabel [
	| labelText classCoder |
	
	classCoder := behaviorCoderUIModel coder.
	labelText := (classCoder theClass isReferenced
		ifTrue: [ '<1s> is referenced. Remove anyway?' ]
		ifFalse: [ classCoder theClass subclasses isEmpty
				ifTrue: [ 'Remove class <1s>' ]
				ifFalse: [ '<1s> has subclasses. Remove anyway?' ] ])
		expandMacrosWith: classCoder theClass name.
	^ BrLabel new
		margin: (BlInsets all: 10);
		look: BrGlamorousLabelLook new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #accessing }
GtBehaviorCoderElement >> classCoder [
	^ behaviorCoderUIModel classCoder
]

{ #category : #private }
GtBehaviorCoderElement >> classViewItems [
	| classCoder collector context |
	
	classCoder := behaviorCoderUIModel coder.

	collector := GtPhlowViewsCollector new
		fromObject: classCoder theClass;
		from: classCoder theClass class;
		to: Behavior;
		pragmaName: #gtClassView.

	context := GtPhlowContext new.
	context optionAt: #behaviorCoder put: behaviorCoderUIModel.

	collector context: context.

	^ collector collect
]

{ #category : #accessing }
GtBehaviorCoderElement >> coderUIModel [
	^ behaviorCoderUIModel
]

{ #category : #accessing }
GtBehaviorCoderElement >> coderUIModel: aGtBehaviorCoderUIModel [

	behaviorCoderUIModel := aGtBehaviorCoderUIModel.
	behaviorCoderUIModel coder
		when: GtCoderPackageUpdatedAnnouncement
			do: [ :ann | self actOnPackageUpdated: ann ];
		when: GtClassCoderNavigationAnnouncement
			do: [ :ann | self actOnSelectMethod: ann method ].

	container ifNotNil: #removeFromParent.
	container := self buildContentPane.
	self addChildFirst: container
]

{ #category : #private }
GtBehaviorCoderElement >> executeTask: aBlock [
	BlUseAsyncFeatures
		ifEnabledDo: [ self enqueueTask: (BlTaskAction new action: aBlock) ]
		otherwise: aBlock
]

{ #category : #initialization }
GtBehaviorCoderElement >> initialize [
	super initialize.

	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
		
	self when: BlClickEvent do: [ self requestFocus ]
]

{ #category : #actions }
GtBehaviorCoderElement >> removeClass [
	| aClassCoder coder event |
	
	aClassCoder := behaviorCoderUIModel coder.
	
	coder := aClassCoder packageTag
		ifNotNil: [ :tag | GtPackageTagCoder forPackageTag: tag ]
		ifNil: [ GtPackageCoder forPackage: aClassCoder package ].
	aClassCoder removeClass.
	event := GtCoderToReplace new coder: coder.
	self fireEvent: event
]

{ #category : #'updating ui' }
GtBehaviorCoderElement >> removeContentTabs [
	contentTabs
		ifNotNil: [ contentPane removeChild: contentTabs.
			contentTabs := nil ]
]

{ #category : #'updating ui' }
GtBehaviorCoderElement >> selectAndScrollToMethod: aMethod [

	contentTabs content 
		allChildrenBreadthFirstDetect: [ :eachElement | eachElement isKindOf: GtMethodsCoderElement ] 
		ifFound: [ :theElement | theElement codersUIModel coder selectAndScrollToMethod: aMethod ] 
		ifNone: [ "ignore" ]
]
