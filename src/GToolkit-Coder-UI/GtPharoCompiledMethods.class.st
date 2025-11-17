Class {
	#name : #GtPharoCompiledMethods,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'GToolkit-Coder-UI-Phlow Targets'
}

{ #category : #'as yet unclassified' }
GtPharoCompiledMethods >> gtCompareMethodsAsFilterFor: anAction [
	<gtAction>
	self size = 2 ifFalse: [ ^ anAction noAction ].
	^ anAction button
		priority: 2;
		target: GtCoderMethodsTarget;
		icon: BrGlamorousVectorIcons empty;
		label: 'Compare methods';
		menuItemPreview: ('{1} methods' format: {self size});
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :b | b phlow spawnObject: (GtRGMethodDefinitionWithComparisonGroup withAll: self) ]
]

{ #category : #'as yet unclassified' }
GtPharoCompiledMethods >> gtInspectMethodsAsFilterFor: anAction [
	<gtAction>
	^ anAction button
		priority: 2;
		target: GtCoderMethodsTarget;
		icon: BrGlamorousVectorIcons empty;
		label: 'Inspect methods as filter';
		menuItemPreview: ('{1} methods' format: {self size});
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :b | b phlow spawnObject: (GtSearchFixedMethodsFilter new methods: self) ]
]

{ #category : #views }
GtPharoCompiledMethods >> gtItemsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Items';
		items: [ items ];
		withMultipleSelection;
		column: 'Class' text: [ :each | each methodClass name ];
		column: 'Selector' text: [ :each | each selector ];
		column: 'Package' text: [ :each | each package name ];
		dynamicContextItems: [ :aCollection | 
			(GtCoderMethodsTarget uniqueInstance
				menuItemsForObject: (GtPharoCompiledMethods withAll: aCollection)
				hostElement: BlElement new) items ]
]

{ #category : #'as yet unclassified' }
GtPharoCompiledMethods >> gtRemoveMethodsFor: anAction [
	"<gtAction>"
	^ anAction dropdown
		priority: 100;
		target: GtCoderMethodsTarget;
		icon: BrGlamorousVectorIcons bin;
		label: 'Remove methods';
		menuItemPreview: ('{1} methods' format: {self size});
		menuItemGroup: BrMenuItemGroupConfiguration removal;
		menuItemPinSubmenu;
		content: [ :aButton :aTargetElement :anExplicitMenu | 
			self removeSeveralMethodsSubmenuFor: self ]
]

{ #category : #'as yet unclassified' }
GtPharoCompiledMethods >> removeSeveralMethodsSubmenuFor: aCollection [
	| element changes change button |
			element := BrVerticalPane new fitContent.
			element
				addChild: (BrLabel new
						margin: (BlInsets
								top: 10
								bottom: 0
								left: 10
								right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
						text: ('Remove {1} methods' format: {aCollection size}) asRopedText).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane references |
							pane := BrVerticalPane new.
							pane fitContent.
							references := aCollection
									inject: 0
									into: [ :sum :method1 | sum + (GtPharoIndex current sendersOf: method1 selector) size ].
							references > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (references printString , ' reference'
														, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
							pane ]).
			changes := aCollection
					collect: [ :eachMethod | RBRemoveMethodChange remove: eachMethod selector from: eachMethod methodClass ].
			change := RBCompositeRefactoryChange new
					name: ('Remove {1} methods' format: {aCollection size});
					changes: changes;
					yourself.
			button := BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					beSmallSize;
					margin: (BlInsets
							top: 10
							bottom: 10
							left: 10
							right: 10);
					icon: BrGlamorousVectorIcons remove;
					label: 'Remove';
					action: [ "submenu hideAll."
						change execute ].
			element addChild: button as: #removeButton.
			^ element
]
