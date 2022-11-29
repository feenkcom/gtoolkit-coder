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
GtFilterTagElementExamples >> filterTagValueNotRequired [
	<gtExample>
	| tagElement filterDescriptor |
	
	filterDescriptor := self filterValueNotRequired.
	
	tagElement := GtFilterTagElement new
		descriptor: filterDescriptor;
		availableFilterDescriptors: self availableFilterDescriptors.

	self
		assert: (tagElement query // GtFilterTagLabelId) anyOne text asString
		equals: 'Default without value'.

	"there is no editor"
	self assert: (tagElement query // GtFilterTagEditorId) isEmpty.
	
	self assert: tagElement isValid.

	^ tagElement
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueNotRequiredByScripter [
	<gtExample>
	| scripter |
	
	scripter := BlScripter new
		extent: 500@400;
		element: self filterTagValueNotRequired.

	scripter assert
		label: 'Does not have focus by default';
		satisfies: [ :anElement | anElement hasFocus not ];
		play.

	scripter click
		label: 'Click on label to request focus';
		id: GtFilterTagLabelId;
		play.

	scripter assert
		label: 'Has focus after clicking on label';
		satisfies: [ :anElement | anElement hasFocus ];
		play.

	scripter click
		label: 'Click again on the label to open a dropdown';
		id: GtFilterTagLabelId;
		play.
		
	scripter click
		label: 'Select filter without value';
		onSpaceRoot;
		id: (GtFilterTagPickerItemId indexed: 2);
		play.
	
	scripter assert
		label: 'Check that replace wish was fired';
		event: GtFilterTagReplaceWish;
		value: [ :anEvent | anEvent filterDescriptor name ]
			equals: [ 'Default without value' ];
		value: [ :anEvent | anEvent newFilterDescriptor name ]
			equals: [ 'Filter without value' ];
		play.

	scripter assert
		label: 'Tag still has focus';
		satisfies: [ :anElement | anElement hasFocus ];
		play.

	scripter shortcut
		label: 'Press backspace to remove the tag';
		combination: BlKeyCombination backspace;
		play.

	scripter assert
		label: 'Check that remove wish was fired';
		event: GtFilterTagRemoveWish;
		value: [ :anEvent | anEvent filterDescriptor name ]
			equals: [ 'Filter without value' ];
		play.

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefault [
	<gtExample>
	| aTagElement |

	aTagElement := GtFilterTagElement new
		descriptor: self filterValueRequiredWithDefault;
		availableFilterDescriptors: self availableFilterDescriptors.

	^ aTagElement
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefaultByScripter [
	<gtExample>
	| scripter |

	scripter := BlScripter new
		extent: 500@400;
		element: self filterTagValueRequiredWithDefault.

	scripter assert
		satisfies: [ :anElement | anElement isValid ];
		play.

	scripter assert
		satisfies: [ :anElement | anElement hasFocus not ];
		play.

	scripter assert
		label: 'Check that the default value is set in the editor';
		id: GtFilterTagEditorId;
		value: [ :anEditor | anEditor text asString ]
			equals: 'Default';
		play.

	scripter assert
		label: 'Check that name of the filter is correct in the label';
		id: GtFilterTagLabelId;
		value: [ :aLabel | aLabel text asString ]
			equals: 'Default with value';
		play.

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefaultByScripterRemoveText [
	<gtExample>
	| scripter |

	scripter := self filterTagValueRequiredWithDefaultByScripter.
		
	scripter click
		id: GtFilterTagEditorId;
		play.
		
	scripter shortcut
		id: GtFilterTagEditorId;
		combination: BlKeyCombination primaryA;
		play.
		
	scripter type
		id: GtFilterTagEditorId;
		text: '';
		play.
		
	scripter assert
		label: 'Check that the new value is typed in the editor';
		id: GtFilterTagEditorId;
		value: [ :anEditor | anEditor text asString ]
			equals: '';
		play.

	scripter assert
		satisfies: [ :anEditor | anEditor isValid not ];
		play.
		
	scripter shortcut
		label: 'Accept changes with enter shortcut';
		id: GtFilterTagEditorId;
		combination: BlKeyCombination enter;
		play.
		
	scripter assert
		eventNotFired: GtFilterTagUpdateWish;
		play.

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefaultByScripterTypeAndAcceptWithClickingAway [
	<gtExample>
	| scripter |

	scripter := self filterTagValueRequiredWithDefaultByScripter.
		
	scripter click
		id: GtFilterTagEditorId;
		play.
		
	scripter assert
		id: GtFilterTagEditorId;
		satisfies: [ :anEditor | anEditor hasFocus ];
		play.
		
	scripter shortcut
		id: GtFilterTagEditorId;
		combination: BlKeyCombination primaryA;
		play.
		
	scripter type
		id: GtFilterTagEditorId;
		text: ' New value ';
		play.
		
	scripter assert
		label: 'Check that the new value is typed in the editor';
		id: GtFilterTagEditorId;
		value: [ :anEditor | anEditor text asString ]
			"intentionally added spaces to test trimming"
			equals: ' New value ';
		play.

	scripter assert
		id: GtFilterTagEditorId;
		satisfies: [ :anEditor | anEditor hasFocus ];
		play.

	scripter click
		id: GtFilterTagLabelId;
		play.

	scripter assert
		id: GtFilterTagEditorId;
		satisfies: [ :anEditor | anEditor hasFocus not ];
		play.

	scripter assert
		label: 'Check that update wish was fired';
		event: GtFilterTagUpdateWish;
		value: [ :anEvent | anEvent filterDescriptor name ]
			equals: [ 'Default with value' ];
		value: [ :anEvent | anEvent newValue ]
			equals: [ 'New value' ];
		play.

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithDefaultByScripterTypeAndAcceptWithShortcut [
	<gtExample>
	| scripter |

	scripter := self filterTagValueRequiredWithDefaultByScripter.
		
	scripter click
		id: GtFilterTagEditorId;
		play.
		
	scripter assert
		id: GtFilterTagEditorId;
		satisfies: [ :anEditor | anEditor hasFocus ];
		play.
		
	scripter shortcut
		id: GtFilterTagEditorId;
		combination: BlKeyCombination primaryA;
		play.
		
	scripter type
		id: GtFilterTagEditorId;
		text: ' New value ';
		play.
		
	scripter assert
		label: 'Check that the new value is typed in the editor';
		id: GtFilterTagEditorId;
		value: [ :anEditor | anEditor text asString ]
			"intentionally added spaces to test trimming"
			equals: ' New value ';
		play.

	scripter shortcut
		label: 'Accept changes with enter shortcut';
		id: GtFilterTagEditorId;
		combination: BlKeyCombination enter;
		play.
		
	scripter assert
		label: 'Check that update wish was fired';
		event: GtFilterTagUpdateWish;
		value: [ :anEvent | anEvent filterDescriptor name ]
			equals: [ 'Default with value' ];
		value: [ :anEvent | anEvent newValue ]
			equals: [ 'New value' ];
		play.

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithoutDefault [
	<gtExample>
	| aTagElement |

	aTagElement := GtFilterTagElement new
		descriptor: self filterValueRequiredWithoutDefault;
		availableFilterDescriptors: self availableFilterDescriptors.

	^ aTagElement
]

{ #category : #examples }
GtFilterTagElementExamples >> filterTagValueRequiredWithoutDefaultByScripter [
	<gtExample>
	| scripter |

	scripter := BlScripter new
		extent: 500@400;
		element: self filterTagValueRequiredWithoutDefault.

	scripter assert
		satisfies: [ :anElement | anElement isValid ];
		play.
		
	scripter assert
		label: 'Does not have focus by default';
		satisfies: [ :anElement | anElement hasFocus not ];
		play.

	scripter assert
		id: GtFilterTagEditorId;
		satisfies: [ :anEditor | anEditor text isEmpty ];
		play.

	scripter assert
		id: GtFilterTagLabelId;
		value: [ :aLabel | aLabel text asString ] equals: 'Default with value';
		play.

	^ scripter
]

{ #category : #examples }
GtFilterTagElementExamples >> filterValueNotRequired [
	<gtExample>
	^ GtFilterDescriptorExamples new filterDescriptorValueNotRequired
		named: 'Default without value'
]

{ #category : #examples }
GtFilterTagElementExamples >> filterValueRequiredWithDefault [
	<gtExample>

	^ (GtFilterDescriptorExamples new
		newFilterDescriptor)
			named: 'Default with value';
			emptyDefaultValue: 'Default'
]

{ #category : #examples }
GtFilterTagElementExamples >> filterValueRequiredWithoutDefault [
	<gtExample>

	^ (GtFilterDescriptorExamples new
		newFilterDescriptor)
			named: 'Default with value'
]
