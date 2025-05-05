Class {
	#name : #GtFiltersElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #examples }
GtFiltersElementExamples >> emptyFiltersElement [
	<gtExample>
	<return: #GtFiltersElement>
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
	<return: #BlScripter>
	| filtersElement scripter |
	filtersElement := self emptyFiltersElement.
	filtersElement descriptors: self filterDescriptors.

	scripter := BlScripter new element: filtersElement.

	scripter
		assertStep: [ :s | 
			s
				label: 'Check how many default filters there are';
				value: [ :anElement | (anElement query // GtFilterTagElement) all size ]
					equals: 2 ].

	^ scripter
]

{ #category : #examples }
GtFiltersElementExamples >> filtersElementWithDescriptorsBuildFilters [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self filtersElementWithDescriptors.
	scripter element
		when: GtFiltersChangedEvent
		do: [ :anEvent | 
			| aFiltersElement theFilters |
			aFiltersElement := anEvent currentTarget.

			theFilters := aFiltersElement currentFilters.
			aFiltersElement
				buildFilters: [ theFilters
						do: [ :eachFilterAndValue | 
							aFiltersElement
								addFilterForDescriptor: eachFilterAndValue key
								andValue: eachFilterAndValue value ] ] ].

	scripter clickStep: [ :s | s id: GtFiltersAddButtonId ].

	scripter
		assertStep: [ :s | 
			s
				// GtFilterTagElement;
				@ 3;
				satisfies: [ :aTagElement | aTagElement hasFocus ] ].

	scripter assertStep: [ :s | s eventNotFired: GtFiltersChangedEvent ].

	scripter shortcut
		// GtFilterTagElement;
		@ 3;
		// GtFilterTagEditorId;
		combination: BlKeyCombination enter;
		play.

	scripter
		assertStep: [ :s | 
			s
				label: 'Make sure that the filters changed event is fired only once';
				eventFired: GtFiltersChangedEvent times: 1 ].

	^ scripter
]

{ #category : #examples }
GtFiltersElementExamples >> filtersElementWithDescriptorsReplaceFilterWithTheSameFilter [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self filtersElementWithDescriptors.

	scripter
		clickStep: [ :s | 
			s
				// GtFilterTagElement;
				@ 1;
				// GtFilterTagPickerId ].

	scripter
		clickStep: [ :s | 
			s
				onSpaceRoot;
				id: (GtFilterTagPickerItemId indexed: 1) ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Replacing filter with the same filter should not emit anything';
				eventFired: GtFiltersChangedEvent times: 0 ].

	^ scripter
]
