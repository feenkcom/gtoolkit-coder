Class {
	#name : #GtBaselineDescription,
	#superclass : #Object,
	#instVars : [
		'baseline'
	],
	#category : #'GToolkit-Coder-UI-Forms - Models'
}

{ #category : #'instance creation' }
GtBaselineDescription class >> forBaseline: aBaseline [
	^ self new forBaseline: aBaseline
]

{ #category : #accessing }
GtBaselineDescription >> baseline [

	^ baseline
]

{ #category : #accessing }
GtBaselineDescription >> baseline: anObject [

	baseline := anObject
]

{ #category : #magritte }
GtBaselineDescription >> baselineDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Baseline';
		priority: 1;
		accessor: #baseline;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: (Smalltalk allClasses collect: #name)) ];
		addCondition: [ :aValue | (Smalltalk classNamed: aValue trim) isNil ]
			labelled: 'Baseline name is already taken';
		addCondition: [ :aValue | aValue first isUppercase ]
			labelled: 'First character must be uppercase';
		addCondition: [ :aValue | aValue isAllAlphaNumerics ]
			labelled: 'Class name must be alphanumeric'
]

{ #category : #'instance creation' }
GtBaselineDescription >> forBaseline: aBaseline [
	self baseline: aBaseline name
]
