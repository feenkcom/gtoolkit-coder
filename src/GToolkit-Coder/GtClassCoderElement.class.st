Class {
	#name : #GtClassCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'classCoder',
		'container',
		'contentPane',
		'contentTabs',
		'breadcrumb',
		'navigationElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #callbacks }
GtClassCoderElement >> actOnClassUpdated [
	self classCoder navigationModel 
		updateSelectionWith: self classCoder theClass.
	self
		updateContentTabs;
		updateBreadcrumb
]

{ #category : #callbacks }
GtClassCoderElement >> actOnPackageUpdated: ann [
	self classCoder navigationModel 
		updateSelectionWith: ann package.
	self removeContentTabs.
	breadcrumb removeAllItems.
]

{ #category : #'building ui' }
GtClassCoderElement >> buildBreadcrumb [
	^ BrBreadcrumb new
		look:
			(BrGlamorousBreadcrumbLook new
				separator: [ BrLabel new
						look:
							(BrGlamorousLabelLook new thin
								foreground: BrGlamorousColors defaultButtonTextColor);
						text: '>';
						margin: (BlInsets left: 3 right: 3) ]);
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildBreadcrumbToggleForClass: aClass [
	^ BrToggle new
		margin: (BlInsets all: 2);
		activated: (classCoder methodsCoder filteredClass: aClass);
		label: aClass name asRopedText glamorousRegularFontAndSize;
		look: GtClassBreadcrumbToggleLook;
		when: BrToggleActivatedEvent
			do: [ :anEvent | 
			classCoder methodsCoder addMethodsForClass: aClass.
			classCoder definitionsCoder addDefinitionsForClass: aClass.
			classCoder commentsCoder addCommentForClass: aClass ];
		when: BrToggleDeactivatedEvent
			do: [ :anEvent | 
			classCoder methodsCoder removeMethodsForClass: aClass.
			classCoder definitionsCoder removeDefinitionsForClass: aClass.
			classCoder commentsCoder removeCommentForClass: aClass.
			classCoder methodsCoder hasFilter
				ifFalse: [ aClass == classCoder theClass
						ifTrue: [ anEvent consumed: true ].
					(breadcrumb itemAt: 1) widgetDo: #activate ] ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContainer [
	| tab tabGroup |
	tab := BrTab new
		look: BrGlamorousTabWithoutBarLook;
		label: '';
		stencil: [ contentPane := self buildContentPane ];
		padding:
			(BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 10);
		addChild:
			((breadcrumb := self buildBreadcrumb) asScrollableElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself);
		yourself.
	tabGroup := BrTabGroup new
		look:
			(BrGlamorousTabGroupLook new headerBackground: BrGlamorousColors defaultHeaderBackgroundColor);
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: (Color fromHexString: 'a0d911');
				yourself);
		yourself.
	^ tabGroup
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentPane [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		in: [ :e | 
			classCoder theClass
				ifNil: [ contentTabs := nil ]
				ifNotNil: [ e addChild: (contentTabs := self buildContentTabs) ] ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentTabs [
	| tabPragmas tabGroup |
	tabPragmas := self classViewPragmas.
	tabGroup := BrTabGroup new.
	tabGroup look: BrGlamorousTabGroupLook new.
	tabGroup constraintsDo: [ :c | c linear weight: 2 ].
	tabPragmas
		do: [ :each | 
			classCoder theClass
				perform: each method selector
				with: tabGroup
				with: classCoder ].
	^ tabGroup
]

{ #category : #'building ui' }
GtClassCoderElement >> buildNavigationElement [
	^ classCoder navigationModel asElement
		constraintsDo: [ :c | c linear weight: 0.7 ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildPackagesTreeButton [
	^ BrToggle new
		look: BrGlamorousButtonWithIconLook + BrGlamorousToggleBackgroundLook;
		icon: BrGlamorousIcons tree asElement;
		when: BrToggleActivatedEvent
			do: [ contentPane addChildFirst: navigationElement ];
		when: BrToggleDeactivatedEvent
			do: [ navigationElement removeFromParent ];
		yourself
]

{ #category : #accessing }
GtClassCoderElement >> classCoder [
	^ classCoder
]

{ #category : #accessing }
GtClassCoderElement >> classCoder: aCoder [
	classCoder := aCoder.
	classCoder
		when: GtCoderClassUpdatedAnnouncement
			do: [ self actOnClassUpdated ];
		when: GtCoderPackageUpdatedAnnouncement
			do: [ :ann | self actOnPackageUpdated: ann ].
	container ifNotNil: #removeFromParent.
	container := self buildContainer.
	self
		addChildFirst: container;
		updateBreadcrumb
]

{ #category : #private }
GtClassCoderElement >> classViewPragmas [
	| pragmas |
	pragmas := Pragma
		allNamed: #gtClassView:
		from: classCoder theClass class
		to: Behavior.
	^ pragmas
		asSortedCollection: [ :a :b | a arguments first < b arguments first ]
]

{ #category : #subscriptions }
GtClassCoderElement >> definitionChanged: anAnnouncement [
	anAnnouncement classAffected == classCoder theClass
		ifFalse: [ ^ self ].
	self
		updateContentTabs;
		updateBreadcrumb
]

{ #category : #initialization }
GtClassCoderElement >> initialize [
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
		to: self
]

{ #category : #'updating ui' }
GtClassCoderElement >> removeContentTabs [
	contentTabs
		ifNotNil: [ contentPane removeChild: contentTabs.
			contentTabs := nil ]
]

{ #category : #'updating ui' }
GtClassCoderElement >> showNavigation: aSymbol [
	navigationElement isAttachedToSceneGraph
		ifFalse: [ contentPane addChildFirst: navigationElement ].
	navigationElement selectTab: aSymbol
]

{ #category : #private }
GtClassCoderElement >> updateBreadcrumb [
	breadcrumb removeAllItems.
	classCoder theClass
		ifNotNil: [ :c | 
			c
				withAllSuperclassesDo:
					[ :each | breadcrumb addItem: (self buildBreadcrumbToggleForClass: each) ] ]
]

{ #category : #'updating ui' }
GtClassCoderElement >> updateContentTabs [
	| childIndex |
	contentTabs
		ifNil: [ childIndex := contentPane children size + 1 ]
		ifNotNil: [ childIndex := contentPane childIndexOf: contentTabs ].
	self removeContentTabs.
	contentTabs := self buildContentTabs.
	contentPane addChild: contentTabs asElement at: childIndex
]
