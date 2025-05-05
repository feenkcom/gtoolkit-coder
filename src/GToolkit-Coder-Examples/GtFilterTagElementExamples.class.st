Class {
	#name : #GtFilterTagElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #examples }
GtFilterTagElementExamples >> availableFilterDescriptors [
	^ {
		GtFilterDescriptor
			creator: GtSearchNullFilter new
			named: 'Filter with value'
			order: 1.
			
		GtFilterDescriptor new
			creator: GtSearchNullFilter new;
			named: 'Filter without value';
			order: 2;
			valueNotRequired.
			
		GtFilterDescriptor
			creator: GtSearchNullFilter new
			named: 'Filter C'
			order: 3.
			
		GtFilterDescriptor
			creator: GtSearchNullFilter new
			named: 'Filter D'
			order: 4.
	}
]

{ #category : #examples }
GtFilterTagElementExamples >> filterOffersCompletionValues [
	<gtExample>
	<return: #GtFilterDescriptor>
	^ GtFilterDescriptorExamples new filterDescriptorOffersCompletionValues
		named: 'Words'
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagCompletionOffersValues [
	<gtExample>
	<return: #GtFilterTagElement>
	| tagElement filterDescriptor |
	filterDescriptor := self filterOffersCompletionValues.

	tagElement := GtFilterTagElement new
			descriptor: filterDescriptor;
			availableFilterDescriptors: self availableFilterDescriptors.

	self
		assert: (tagElement query // GtFilterTagLabelId) anyOne text asString
		equals: 'Words'.	"there is no editor"	"self assert: (tagElement query // GtFilterTagEditorId) isEmpty.
	
	self assert: tagElement isValid."

	^ tagElement
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueNotRequired [
	<gtExample>
	<return: #GtFilterTagElement>
	| tagElement filterDescriptor |
	filterDescriptor := self filterValueNotRequired.

	tagElement := GtFilterTagElement new
			descriptor: filterDescriptor;
			availableFilterDescriptors: self availableFilterDescriptors.

	self
		assert: (tagElement query // GtFilterTagLabelId) anyOne text asString
		equals: 'Default without value'.	"there is no editor"
	self assert: (tagElement query // GtFilterTagEditorId) isEmpty.

	self assert: tagElement isValid.

	^ tagElement
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueNotRequiredByScripter [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := BlScripter new
			extent: 500 @ 400;
			element: self filterTagValueNotRequired.

	scripter
		assertStep: [ :s | 
			s
				label: 'Does not have focus by default';
				satisfies: [ :anElement | anElement hasFocus not ] ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Click on label to request focus';
				id: GtFilterTagLabelId ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Has focus after clicking on label';
				satisfies: [ :anElement | anElement hasFocus ] ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Click again on the label to open a dropdown';
				id: GtFilterTagLabelId ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Select filter without value';
				onSpaceRoot;
				id: (GtFilterTagPickerItemId indexed: 2) ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that replace wish was fired';
				event: GtFilterTagReplaceWish;
				value: [ :anEvent | anEvent filterDescriptor name ]
					equals: [ 'Default without value' ];
				value: [ :anEvent | anEvent newFilterDescriptor name ]
					equals: [ 'Filter without value' ] ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Tag still has focus';
				satisfies: [ :anElement | anElement hasFocus ] ].

	scripter shortcut
		label: 'Press backspace to remove the tag';
		combination: BlKeyCombination backspace;
		play.

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that remove wish was fired';
				event: GtFilterTagRemoveWish;
				value: [ :anEvent | anEvent filterDescriptor name ]
					equals: [ 'Filter without value' ] ].

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefault [
	<gtExample>
	<return: #GtFilterTagElement>
	| aTagElement |
	aTagElement := GtFilterTagElement new
			descriptor: self filterValueRequiredWithDefault;
			availableFilterDescriptors: self availableFilterDescriptors.

	^ aTagElement
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefaultByScripter [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := BlScripter new
			extent: 500 @ 400;
			element: self filterTagValueRequiredWithDefault.

	scripter assertStep: [ :s | s satisfies: [ :anElement | anElement isValid ] ].

	scripter
		assertStep: [ :s | s satisfies: [ :anElement | anElement hasFocus not ] ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that the default value is set in the editor';
				id: GtFilterTagEditorId;
				value: [ :anEditor | anEditor text asString ] equals: 'Default' ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that name of the filter is correct in the label';
				id: GtFilterTagLabelId;
				value: [ :aLabel | aLabel text asString ] equals: 'Default with value' ].

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefaultByScripterRemoveText [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self filterTagValueRequiredWithDefaultByScripter.

	scripter clickStep: [ :s | s id: GtFilterTagEditorId ].

	scripter shortcut
		id: GtFilterTagEditorId;
		combination: BlKeyCombination primaryA;
		play.

	scripter
		typeStep: [ :s | 
			s
				id: GtFilterTagEditorId;
				text: '' ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that the new value is typed in the editor';
				id: GtFilterTagEditorId;
				value: [ :anEditor | anEditor text asString ] equals: '' ].

	scripter assertStep: [ :s | s satisfies: [ :anEditor | anEditor isValid not ] ].

	scripter shortcut
		label: 'Accept changes with enter shortcut';
		id: GtFilterTagEditorId;
		combination: BlKeyCombination enter;
		play.

	scripter assertStep: [ :s | s eventNotFired: GtFilterTagUpdateWish ].

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefaultByScripterTypeAndAcceptWithClickingAway [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self filterTagValueRequiredWithDefaultByScripter.

	scripter clickStep: [ :s | s id: GtFilterTagEditorId ].

	scripter
		assertStep: [ :s | 
			s
				id: GtFilterTagEditorId;
				satisfies: [ :anEditor | anEditor hasFocus ] ].

	scripter shortcut
		id: GtFilterTagEditorId;
		combination: BlKeyCombination primaryA;
		play.

	scripter
		typeStep: [ :s | 
			s
				id: GtFilterTagEditorId;
				text: ' New value ' ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that the new value is typed in the editor';
				id: GtFilterTagEditorId;
				value: [ :anEditor "intentionally added spaces to test trimming" | anEditor text asString ]
					equals: ' New value ' ].

	scripter
		assertStep: [ :s | 
			s
				id: GtFilterTagEditorId;
				satisfies: [ :anEditor | anEditor hasFocus ] ].

	scripter clickStep: [ :s | s id: GtFilterTagLabelId ].

	scripter
		assertStep: [ :s | 
			s
				id: GtFilterTagEditorId;
				satisfies: [ :anEditor | anEditor hasFocus not ] ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that update wish was fired';
				event: GtFilterTagUpdateWish;
				value: [ :anEvent | anEvent filterDescriptor name ]
					equals: [ 'Default with value' ];
				value: [ :anEvent | anEvent newValue ] equals: [ 'New value' ] ].

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefaultByScripterTypeAndAcceptWithShortcut [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self filterTagValueRequiredWithDefaultByScripter.

	scripter clickStep: [ :s | s id: GtFilterTagEditorId ].

	scripter
		assertStep: [ :s | 
			s
				id: GtFilterTagEditorId;
				satisfies: [ :anEditor | anEditor hasFocus ] ].

	scripter shortcut
		id: GtFilterTagEditorId;
		combination: BlKeyCombination primaryA;
		play.

	scripter
		typeStep: [ :s | 
			s
				id: GtFilterTagEditorId;
				text: ' New value ' ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that the new value is typed in the editor';
				id: GtFilterTagEditorId;
				value: [ :anEditor "intentionally added spaces to test trimming" | anEditor text asString ]
					equals: ' New value ' ].

	scripter shortcut
		label: 'Accept changes with enter shortcut';
		id: GtFilterTagEditorId;
		combination: BlKeyCombination enter;
		play.

	scripter
		assertStep: [ :s | 
			s
				label: 'Check that update wish was fired';
				event: GtFilterTagUpdateWish;
				value: [ :anEvent | anEvent filterDescriptor name ]
					equals: [ 'Default with value' ];
				value: [ :anEvent | anEvent newValue ] equals: [ 'New value' ] ].

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithoutDefault [
	<gtExample>
	<return: #GtFilterTagElement>
	| aTagElement |
	aTagElement := GtFilterTagElement new
			descriptor: self filterValueRequiredWithoutDefault;
			availableFilterDescriptors: self availableFilterDescriptors.

	^ aTagElement
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithoutDefaultByScripter [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := BlScripter new
			extent: 500 @ 400;
			element: self filterTagValueRequiredWithoutDefault.

	scripter assertStep: [ :s | s satisfies: [ :anElement | anElement isValid ] ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Does not have focus by default';
				satisfies: [ :anElement | anElement hasFocus not ] ].

	scripter
		assertStep: [ :s | 
			s
				id: GtFilterTagEditorId;
				satisfies: [ :anEditor | anEditor text isEmpty ] ].

	scripter
		assertStep: [ :s | 
			s
				id: GtFilterTagLabelId;
				value: [ :aLabel | aLabel text asString ] equals: 'Default with value' ].

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterValueNotRequired [
	<gtExample>
	<return: #GtFilterDescriptor>
	^ GtFilterDescriptorExamples new filterDescriptorValueNotRequired
		named: 'Default without value'
]

{ #category : #examples }
GtFilterTagElementExamples >> filterValueRequiredWithDefault [
	<gtExample>
	<return: #GtFilterDescriptor>
	^ GtFilterDescriptorExamples new newFilterDescriptor
		named: 'Default with value';
		emptyDefaultValue: 'Default'
]

{ #category : #examples }
GtFilterTagElementExamples >> filterValueRequiredWithoutDefault [
	<gtExample>
	<return: #GtFilterDescriptor>
	^ GtFilterDescriptorExamples new newFilterDescriptor
		named: 'Default with value'
]
