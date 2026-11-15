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
			text: #caseName
			width: 140;
		column: 'Source characters'
			text: #sourceCharacters
			width: 130;
		column: 'Source lines'
			text: #sourceLines
			width: 100;
		column: 'Iterations'
			text: #iterations
			width: 100;
		column: 'Samples'
			text: [ :each | each samples size ]
			width: 80;
		column: 'Time per operation (median)'
			text: #period
			width: 210;
		column: 'Total time (median batch)'
			text: #elapsedTime
			width: 210
]
