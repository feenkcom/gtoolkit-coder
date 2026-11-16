"
I group diff benchmark results. My overview relates source text length in characters and lines to the timings for each method and diff case.
"
Class {
	#name : #GtDiffBenchmarkResultGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #'gt - views' }
GtDiffBenchmarkResultGroup >> gtOverviewFor: aView [
	"How does source text length affect the timings of each method and diff case?"

	<gtView>
	^ aView columnedList
		title: 'Overview';
		priority: 1;
		items: [ self items ];
		column: 'Method' text: #method;
		column: 'Case'
			text: #caseName;
		column: 'Source characters'
			text: #sourceCharacters;
		column: 'Source lines'
			text: #sourceLines;
		column: 'Iterations'
			text: #iterations;
		column: 'Samples'
			text: [ :each | each samples size ];
		column: 'Total time (median batch)'
			text: [:each | each elapsedTime gtShortPrintString]
]
