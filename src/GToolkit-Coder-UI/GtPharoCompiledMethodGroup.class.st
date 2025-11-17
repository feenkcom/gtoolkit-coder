Class {
	#name : #GtPharoCompiledMethodGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'GToolkit-Coder-UI-Phlow Targets'
}

{ #category : #views }
GtPharoCompiledMethodGroup >> gtItemsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Items';
		items: [ items ];
		withMultipleSelection;
		column: 'Class' text: [ :each | each methodClass name ];
		column: 'Selector' text: [ :each | each selector ];
		column: 'Package' text: [ :each | each package name ];
		dynamicContextItems: [ :anElement :aCollection | 
			aCollection size = 1
				ifTrue: [ GtCoderMethodTarget
						menuItemsForObject: aCollection anyOne
						hostElement: anElement ]
				ifFalse: [ GtCoderMethodsTarget
						menuItemsForObject: (GtPharoCompiledMethodGroup withAll: aCollection)
						hostElement: anElement ] ]
]
