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
	self classCoder navigationModel
		updateSelectionWith: self classCoder theClass.
	self updateContentTabs
]

{ #category : #callbacks }
GtBehaviorCoderElement >> actOnPackageUpdated: ann [
	self classCoder navigationModel 
		updateSelectionWith: ann package.
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
			BlUseAsyncFeatures
				ifEnabledDo: [ self enqueueTask: (BlTaskAction new action: selectTabBlock) ]
				otherwise: selectTabBlock ].
	selectMethodBlock := [ self selectAndScrollToMethod: aMethod ].
	BlUseAsyncFeatures
		ifEnabledDo: [ self enqueueTask: (BlTaskAction new action: selectMethodBlock) ]
		otherwise: selectMethodBlock
]

{ #category : #'building ui' }
GtBehaviorCoderElement >> buildClassLabel [
	| aClassNameEditor |
	
	aClassNameEditor := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
			defaultBackground: Color transparent;
			glamorousCodeFont;
			bold;
			fontSize: 20);
		inputFilter: BrTextEditorAlphaNumericInputFilter new;
		text: (classCoder name);
		margin: (BlInsets all: 0).

	(GtCompletionController
		on: aClassNameEditor
		strategy: (GtClassesCompletionStrategy new)) install.

	^ aClassNameEditor
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
	| tabPragmas |
	tabPragmas := self classViewItems.
	contentTabs := BrTabGroup new.
	contentTabs look: BrGlamorousTabGroupLook new.
	contentTabs constraintsDo: [ :c | c linear weight: 2 ].
	tabPragmas
		do: [ :each | 
			each
				ifItHasContent: [ | tab |
					tab := BrTab new
						look: BrGlamorousTabLook new;
						label: each title;
						stencil: [ each asElementDo: [ :el | el ] ].
					each actions notEmpty
						ifTrue:
							[ tab toolbarStencil: [ each actionsToolbarForElement: tab ] ].
					contentTabs addTab: tab ] ].
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
		when: GtCoderClassUpdatedAnnouncement
			do: [ self actOnClassUpdated ];
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
	collector pragmaNames: #(gtClassView).
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
	(contentTabs content childAt: 1) coders
		selectAndScrollToMethod: aMethod
]

{ #category : #'updating ui' }
GtBehaviorCoderElement >> updateContentTabs [
	| childIndex |
	contentTabs
		ifNil: [ childIndex := contentPane children size + 1 ]
		ifNotNil: [ childIndex := contentPane childIndexOf: contentTabs ].
	self removeContentTabs.
	contentTabs := self buildContentTabs.
	contentPane addChild: contentTabs asElement at: childIndex
]
