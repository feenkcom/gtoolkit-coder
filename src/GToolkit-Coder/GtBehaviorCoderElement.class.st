Class {
	#name : #GtBehaviorCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'classCoder',
		'container',
		'contentPane',
		'contentTabs'
	],
	#category : #'GToolkit-Coder-Behavior - UI'
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

{ #category : #callbacks }
GtBehaviorCoderElement >> browseClassReferences [
	classCoder theClass
		ifNotNil: [ :class | self phlow spawnObject: class gtReferences ]
]

{ #category : #'building ui' }
GtBehaviorCoderElement >> buildClassLabel [
	| aClassNameEditor aContainer aPreviewButton removeClassButton |
		
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
		inputFilter: BrTextEditorAlphaNumericInputFilter new;
		text: (classCoder name);
		margin: (BlInsets all: 0);
		whenKey: BlKeyCombination primaryN
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | aCoderElement browseClassReferences ]
			with: self;
		whenKey: BlKeyCombination primaryB
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | aCoderElement phlow spawnTool: (GtClassCoderTool observedClass: aCoderElement classCoder theClass) ]
			with: self;
		whenKey: BlKeyCombination primaryG
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | aCoderElement phlow spawnObject: aCoderElement classCoder theClass ]
			with: self;
		whenKey: BlKeyCombination primaryR
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | 
				anEvent currentTarget switchToEditor ]
			with: self;
		whenKey: BlKeyCombination primaryC
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderElement | 
				Clipboard clipboardText: aCoderElement classCoder theClass name asString ]
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
	contentPane addChild: self buildHeader.
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
GtBehaviorCoderElement >> buildHeader [
	^ GtBehaviorCoderHeaderElement new
		classCoder: classCoder;
		margin: (BlInsets top: 5 left: 5)
]

{ #category : #'building ui' }
GtBehaviorCoderElement >> buildRemoveClassLabel [
	| labelText |
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
	^ classCoder
]

{ #category : #accessing }
GtBehaviorCoderElement >> classCoder: aCoder [
	classCoder := aCoder.
	classCoder
		when: GtCoderPackageUpdatedAnnouncement
			do: [ :ann | self actOnPackageUpdated: ann ];
		when: GtClassCoderNavigationAnnouncement
			do: [ :ann | self actOnSelectMethod: ann method ].
	container ifNotNil: #removeFromParent.
	container := self buildContentPane.
	self addChildFirst: container
]

{ #category : #private }
GtBehaviorCoderElement >> classViewItems [
	| collector context |
	collector := GtPhlowViewsCollector new.
	collector fromObject: classCoder theClass.
	collector from: classCoder theClass class.
	collector to: Behavior.
	collector pragmaName: #gtClassView.
	context := Dictionary new.
	context at: #classCoder put: classCoder.
	collector context: context.
	^ collector collect
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
	| coder event |
	coder := classCoder packageTag
		ifNotNil: [ :tag | GtPackageTagCoder forPackageTag: tag ]
		ifNil: [ GtPackageCoder forPackage: classCoder package ].
	classCoder removeClass.
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
		ifFound: [ :theElement | theElement coders selectAndScrollToMethod: aMethod ] 
		ifNone: [ "ignore" ]
]
