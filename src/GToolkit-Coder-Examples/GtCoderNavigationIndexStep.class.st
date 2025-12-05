Class {
	#name : #GtCoderNavigationIndexStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-Coder-Examples-Scripter'
}

{ #category : #'steps - interactions' }
GtCoderNavigationIndexStep >> assertSelectedMethod: aCompiledMethod [
	^ self assert
		label: ('Assert selected method: {1}' format: {aCompiledMethod selector});
		satisfies: [ :aLabel | aLabel states isSelected ];
		onParentStepTarget: self;
		onThisOrBreadthFirstChildOfKind: GtCoderMethodsGroupedListElement;
		// BrLabel;
		@ [ :eachLabel | eachLabel text asString = aCompiledMethod selector ]
]

{ #category : #accessing }
GtCoderNavigationIndexStep >> defaultLabel [
	^ 'Coder navigation'
]

{ #category : #'steps - interactions' }
GtCoderNavigationIndexStep >> selectMethods: someCompiledMethods [
	^ someCompiledMethods size = 1
		ifTrue: [ self click
				label: ('Select method: {1}' format: {someCompiledMethods first selector});
				onParentStepTarget: self;
				onThisOrBreadthFirstChildOfKind: GtCoderMethodsGroupedListElement;
				// BrLabel;
				@ [ :eachLabel | eachLabel text asString = someCompiledMethods first selector ] ]
		ifFalse: [ self
				substeps2: ('Select {2} methods' format: {someCompiledMethods size})
				do: [ :aStep | 
					self click
						label: ('Select the first method: {1}' format: {someCompiledMethods first selector});
						onParentStepTarget: aStep;
						onThisOrBreadthFirstChildOfKind: GtCoderMethodsGroupedListElement;
						// BrLabel;
						@ [ :eachLabel | eachLabel text asString = someCompiledMethods first selector ].

					aStep click
						label: 'Select the other methods';
						modifiers: (BlKeyModifiers primary shift: true);
						onParentStepTarget: aStep;
						onThisOrBreadthFirstChildOfKind: GtCoderMethodsGroupedListElement;
						// BrLabel;
						@ [ :each | each text asString = someCompiledMethods last selector ].

					aStep assert
						label: 'Assert list selection';
						value: [ :aList | aList selectedItems asArray ]
							equals: someCompiledMethods asArray;
						onParentStepTarget: aStep;
						onThisOrBreadthFirstChildOfKind: GtCoderMethodsGroupedListElement ] ]
]
