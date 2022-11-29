Class {
	#name : #GtFiltersElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #examples }
GtFiltersElementExamples >> emptyFiltersElement [
	<gtExample>
	| aFiltersElement |
	
	aFiltersElement := GtFiltersElement new.

	self assert: (aFiltersElement query // GtFiltersAddButtonId) isNotEmpty.

	^ aFiltersElement
]

{ #category : #examples }
GtFiltersElementExamples >> filterDescriptors [
	^ {
		GtFilterDescriptor new
			creator: GtSearchNullFilter new;
			named: 'Filter with value';
			order: 1;
			emptyDefaultValue: 'value'.

		GtFilterDescriptor new
			creator: GtSearchNullFilter new;
			named: 'Filter without value';
			order: 2;
			valueNotRequired.
			
		GtFilterDescriptor new
			creator: GtSearchNullFilter new;
			named: 'Filter with empty default value';
			order: 3.
			
		GtFilterDescriptor
			creator: GtSearchNullFilter new
			named: 'Filter D'
			order: 4.
	}
]

{ #category : #examples }
GtFiltersElementExamples >> filtersElementWithDescriptors [
	<gtExample>
	| filtersElement scripter |
	
	filtersElement := self emptyFiltersElement.
	filtersElement descriptors: self filterDescriptors.

	scripter := BlScripter new
		element: filtersElement.

	scripter assert
		label: 'Check how many default filters there are';
		value: [ :anElement | (anElement query // GtFilterTagElement) all size  ] equals: 2;
		play.

	^ scripter
]

{ #category : #examples }
GtFiltersElementExamples >> filtersElementWithDescriptorsBuildFilters [
	<gtExample>
	| scripter |

	scripter := self filtersElementWithDescriptors.
	scripter element
		when: GtFiltersChangedEvent
		do: [ :anEvent |
			| aFiltersElement theFilters |
			
			aFiltersElement := anEvent currentTarget.
			
			theFilters := aFiltersElement currentFilters.
			aFiltersElement buildFilters: [
				theFilters do: [ :eachFilterAndValue |
					aFiltersElement
						addFilterForDescriptor: eachFilterAndValue key
						andValue: eachFilterAndValue value ] ] ].

	scripter click
		id: GtFiltersAddButtonId;
		play.

	scripter assert
		// GtFilterTagElement;
		@ 3;
		satisfies: [ :aTagElement | aTagElement hasFocus ];
		play.

	scripter assert
		eventNotFired: GtFiltersChangedEvent;
		play.

	scripter shortcut
		// GtFilterTagElement;
		@ 3;
		// GtFilterTagEditorId;
		combination: BlKeyCombination enter;
		play.

	scripter assert
		label: 'Make sure that the filters changed event is fired only once';
		eventFired: GtFiltersChangedEvent times: 1;
		play.

	^ scripter
]

{ #category : #examples }
GtFiltersElementExamples >> filtersElementWithDescriptorsReplaceFilterWithTheSameFilter [
	<gtExample>
	| scripter |

	scripter := self filtersElementWithDescriptors.

	scripter click
		// GtFilterTagElement;
		@ 1;
		// GtFilterTagPickerId;
		play.

	scripter click
		onSpaceRoot;
		id: (GtFilterTagPickerItemId indexed: 1);
		play.

	scripter assert
		label: 'Replacing filter with the same filter should not emit anything';
		eventFired: GtFiltersChangedEvent times: 0;
		play.

	^ scripter
]
