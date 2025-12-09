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
		// GtCoderNavigationCompiledMethodElement;
		@ [ :each | each compiledMethod = aCompiledMethod ]
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
				substeps2: ('Select {1} methods' format: {someCompiledMethods size})
				do: [ :aStep | 
					aStep click
						label: ('Select the first method: {1}' format: {someCompiledMethods first selector});
						onParentStepTarget: aStep;
						onThisOrBreadthFirstChildOfKind: GtCoderMethodsGroupedListElement;
						// GtCoderNavigationCompiledMethodElement;
						@ [ :eachLabel | eachLabel compiledMethod = someCompiledMethods first ].

					aStep click
						label: 'Select the other methods';
						modifiers: (BlKeyModifiers primary shift: true);
						onParentStepTarget: aStep;
						onThisOrBreadthFirstChildOfKind: GtCoderMethodsGroupedListElement;
						// GtCoderNavigationCompiledMethodElement;
						@ [ :each | each compiledMethod = someCompiledMethods last ].

					aStep assert
						label: 'Assert list selection';
						value: [ :aList | aList selectedItems asArray ]
							equals: someCompiledMethods asArray;
						onParentStepTarget: aStep;
						onThisOrBreadthFirstChildOfKind: GtCoderMethodsGroupedListElement ] ]
]
