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
GtBehaviorCoderElement >> actOnClassUpdated [
	self updateContentTabs
]

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
	| aClassNameEditor aContainer aPreviewButton |
		
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
		whenKey: BlKeyCombination primaryN labelDo: [ :anEvent  | self browseClassReferences ].
	
	
	(GtCompletionController
		on: aClassNameEditor
		strategy: (GtClassesCompletionStrategy new)) install.

	aPreviewButton := GtRefactoringsPreviewButton new
		margin: (BlInsets left: 5);
		visibility: BlVisibility hidden;
		refactorings: [ { RBRenameClassRefactoring
			model: RBNamespace new
			rename: classCoder theClass
			to: aClassNameEditor text asString } ];
		when: GtRefactoringsAppliedEvent do: [ :anEvent | anEvent currentTarget visibility: BlVisibility hidden ].
		
	aClassNameEditor editor
		when: BrTextEditorModifiedEvent 
		do: [ :anEvent |
			anEvent text asString = classCoder name
				ifTrue: [ aPreviewButton visibility: BlVisibility hidden ]
				ifFalse: [  aPreviewButton visibility: BlVisibility visible ] ].

	aContainer addChild: aClassNameEditor.
	aContainer addChild: aPreviewButton.

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

{ #category : #subscriptions }
GtBehaviorCoderElement >> definitionChanged: anAnnouncement [
	anAnnouncement classAffected == classCoder theClass
		ifFalse: [ ^ self ].
	self updateContentTabs
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
	SystemAnnouncer uniqueInstance weak
		when:
			ClassModificationApplied , ClassModifiedClassDefinition
				, ClassParentRenamed , ClassRenamed
		send: #definitionChanged:
		to: self.
		
	self when: BlClickEvent do: [ self requestFocus ]
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
		allChildrenBreadthFirstDetect: [ :eachElement | eachElement isKindOf: GtCodersElement ] 
		ifFound: [ :theElement | theElement coders selectAndScrollToMethod: aMethod ] 
		ifNone: [ "ignore" ]
]

{ #category : #'updating ui' }
GtBehaviorCoderElement >> updateContentTabs [
	| childIndex |
	contentTabs
		ifNil: [ childIndex := contentPane children size + 1 ]
		ifNotNil: [ childIndex := contentPane childIndexOf: contentTabs ].
	self removeContentTabs.
	contentPane addChild: self buildContentTabs at: childIndex
]
