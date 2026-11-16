"
I am a BenchmarkResult for one diff benchmark case. My iterations and elapsedTime describe the median batch, so period is the median time per operation. I retain every batch as a BenchmarkResult and the method, diff model, and optional rendering artifacts for inspection.
"
Class {
	#name : #GtDiffBenchmarkResult,
	#superclass : #BenchmarkResult,
	#instVars : [
		'method',
		'caseName',
		'samples',
		'model',
		'element',
		'form'
	],
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #accessing }
GtDiffBenchmarkResult >> caseName [
	^ caseName
]

{ #category : #accessing }
GtDiffBenchmarkResult >> caseName: anObject [
	caseName := anObject
]

{ #category : #accessing }
GtDiffBenchmarkResult >> element [
	^ element
]

{ #category : #accessing }
GtDiffBenchmarkResult >> element: anObject [
	element := anObject
]

{ #category : #accessing }
GtDiffBenchmarkResult >> form [
	^ form
]

{ #category : #accessing }
GtDiffBenchmarkResult >> form: anObject [
	form := anObject
]

{ #category : #'gt - views' }
GtDiffBenchmarkResult >> gtCaseFor: aView [
	"Which method and diff case produced this result, and what artifacts are available?"

	<gtView>
	^ aView columnedList
		title: 'Case';
		priority: 5;
		items: [ {'Case' -> caseName.
				'Method' -> method.
				'Source lines' -> self sourceLines.
				'Source characters' -> self sourceCharacters.
				'Time per operation (median batch)' -> self period.
				'Model' -> model.
				'Element' -> element.
				'Form' -> form} ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #'gt - views' }
GtDiffBenchmarkResult >> gtSamplesFor: aView [
	"How do the batch timings compare with the median?"

	<gtView>
	^ aView columnedList
		title: 'Samples';
		priority: 10;
		items: [ samples ];
		column: 'Batch' text: [ :each :index | index ];
		column: 'Iterations' text: #iterations;
		column: 'Elapsed time' text: #elapsedTime;
		column: 'Time per operation' text: #period
]

{ #category : #accessing }
GtDiffBenchmarkResult >> method [
	^ method
]

{ #category : #accessing }
GtDiffBenchmarkResult >> method: anObject [
	method := anObject
]

{ #category : #accessing }
GtDiffBenchmarkResult >> model [
	^ model
]

{ #category : #accessing }
GtDiffBenchmarkResult >> model: anObject [
	model := anObject
]

{ #category : #printing }
GtDiffBenchmarkResult >> printOn: aStream [
	caseName
		ifNotNil: [ aStream
				nextPutAll: caseName;
				nextPutAll: ' - ' ].
	method
		ifNotNil: [ aStream
				print: method;
				nextPutAll: ' - ' ].
	super printOn: aStream
]

{ #category : #accessing }
GtDiffBenchmarkResult >> samples [
	^ samples
]

{ #category : #accessing }
GtDiffBenchmarkResult >> samples: aCollection [
	| median |
	self assert: aCollection notEmpty.
	self assert: aCollection size odd.
	samples := aCollection asArray copy.
	median := (samples sorted: [ :a :b | a period < b period ])
			at: samples size // 2 + 1.
	self iterations: median iterations.
	self elapsedTime: median elapsedTime
]

{ #category : #accessing }
GtDiffBenchmarkResult >> sourceCharacters [
	^ method sourceCode size
]

{ #category : #accessing }
GtDiffBenchmarkResult >> sourceLines [
	^ method sourceCode lines size
]

{ #category : #accessing }
GtDiffBenchmarkResult >> viewportExtent [
	^ form ifNotNil: [ form extent ]
]
