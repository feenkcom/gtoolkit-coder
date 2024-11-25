Class {
	#name : #GtFilterStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #'steps - checks' }
GtFilterStep >> assertFilterModelAtIndex: anIndex itemsCountIs: anItemsCount [
	^ self assert
		label: ('Assert filter model no. {1} has {2} {3}'
				format: {anIndex.
						anItemsCount.
						'item' asPluralBasedOn: anItemsCount});
		referenceSender;
		onParentStepTarget: self;
		value: [ :aFilterItemsElement | (aFilterItemsElement filtersViewModel items at: anIndex) items size ]
			equals: anItemsCount
]

{ #category : #'steps - checks' }
GtFilterStep >> assertFilterModelAtIndex: anIndex itemsCountIsAtLeast: anItemsCount [
	^ self assert
		label: ('Assert filter model no. {1} has at least {2} {3}'
				format: {anIndex.
						anItemsCount.
						'item' asPluralBasedOn: anItemsCount});
		referenceSender;
		onParentStepTarget: self;
		satisfies: [ :aFilterItemsElement | 
				(aFilterItemsElement filtersViewModel items at: anIndex) items size
					>= anItemsCount ]
			description: [ :aFilterItemsElement | 
				'Filter at position {1} must have at least {2} {3}, but have {4}'
					format: {anIndex.
							anItemsCount.
							'item' asPluralBasedOn: anItemsCount.
							(aFilterItemsElement filtersViewModel items at: anIndex) items size} ]
]

{ #category : #'steps - checks' }
GtFilterStep >> assertFilterModelAtIndex: anIndex selectedValueIs: aValue [
	^ self assert
		label: ('Assert filter model no. {1} has selected item: {2}'
				format: {anIndex.
						aValue});
		referenceSender;
		onParentStepTarget: self;
		value: [ :aFilterItemsElement | (aFilterItemsElement filtersViewModel items at: anIndex) selectedValue ]
			equals: aValue
]

{ #category : #'steps - checks' }
GtFilterStep >> assertFilterModelNamed: aFilterName [
	^ self assert
		label: ('Assert filter model with name {1} exists' format: {aFilterName});
		referenceSender;
		onParentStepTarget: self;
		onChildFromBlock: [ :aFilterItemsElement | aFilterItemsElement filtersViewModel items ];
		anySatisfy: [ :aFilterViewModel | aFilterViewModel name = aFilterName ]
			description: [ :someFilterViewModels | 
				'Filter with name {1} is missing: {2}'
					format: {aFilterName.
							someFilterViewModels} ]
]

{ #category : #'steps - checks' }
GtFilterStep >> assertFilterModelNamed: aFilterName selectedValueIs: aValue [
	^ self assert
		label: ('Assert filter model with name {1} has selected item: {2}'
				format: {aFilterName. aValue});
		referenceSender;
		onParentStepTarget: self;
		onChildFromBlock: [ :aFilterItemsElement | aFilterItemsElement filtersViewModel items ];
		anySatisfy: [ :aFilterViewModel | aFilterViewModel name = aFilterName and: [
			aFilterViewModel selectedValue = aValue ] ]
			description: [ :someFilterViewModels | 
				'Filter with name {1} and {2} selected value is missing: {3}.'
					format: {aFilterName. aValue. someFilterViewModels} ]
]

{ #category : #'steps - checks' }
GtFilterStep >> assertFilterModelsCountIs: anItemsCount [
	^ self assert
		label: ('Assert filter models count is {1}' format: {anItemsCount});
		referenceSender;
		onParentStepTarget: self;
		value: [ :aFilterItemsElement | (aFilterItemsElement filtersViewModel items size) ]
			equals: anItemsCount
]

{ #category : #'steps - interactions' }
GtFilterStep >> clickOnAddFilter [
	^ self click
		referenceSender;
		// GtFiltersAddId
]

{ #category : #'steps - interactions' }
GtFilterStep >> clickOnDropdownFilterItem: aFilterItem [
	^ self click
		label: ('Click on dropdown item: {1}' format: { aFilterItem });
		referenceSender;
		onSpaceRoot;
		// BrAnchoredOuterContainer;
		// #scrollable;
		onChildFromBlock: [ :anElement | anElement children detect: [ :each | each viewModel model = aFilterItem ] ]
]

{ #category : #'steps - interactions' }
GtFilterStep >> clickOnDropdownFilterItemAtIndex: anIndex [
	^ self click
		label: ('Click on dropdown item at index {1}' format: { anIndex });
		referenceSender;
		onSpaceRoot;
		// BrAnchoredOuterContainer;
		// (GtFilterItemId indexed: anIndex)
]

{ #category : #'steps - interactions' }
GtFilterStep >> clickOnDropdownFilterItemLabeled: aLabel [
	^ self click
		label: ('Click on dropdown item with label {1}' format: {aLabel});
		referenceSender;
		onSpaceRoot;
		// BrAnchoredOuterContainer;
		// #scrollable;
		onChildFromBlock: [ :anElement | anElement children detect: [ :each | each children last text asString = aLabel ] ]
]

{ #category : #'steps - interactions' }
GtFilterStep >> clickOnFilterSettingsAtIndex: anIndex [
	^ self click
		label: ('Click on filter settings at index {1}' format: { anIndex });
		referenceSender;
		// (GtFilterNameId indexed: anIndex);
		// GtFilterSettingsId
]
