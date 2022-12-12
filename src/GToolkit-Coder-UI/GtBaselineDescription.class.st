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

{ #category : #accessing }
GtBaselineDescription >> baselineDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Baseline';
		priority: 1;
		accessor: #baseline;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: RPackageOrganizer default packageNames) ];
		addCondition: [ :aValue | (RPackageOrganizer default packageNamed: aValue ifAbsent: [ nil ]) isNil ]
			labelled: 'Baseline or package exists'
]

{ #category : #accessing }
GtBaselineDescription >> forBaseline: aBaseline [
	self baseline: aBaseline name
]
