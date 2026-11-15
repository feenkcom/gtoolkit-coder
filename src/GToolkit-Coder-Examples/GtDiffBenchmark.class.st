"
I benchmark diff models and actual diff elements for removed, added, and changed methods of different source sizes.

Evaluate `GtDiffBenchmark new run` to measure GtDiffBuilder model creation with a fresh Pharo token splitter. By default I use seven batches of 1000 creations after warmup.

Evaluate `GtDiffBenchmark new runRendering` to measure fresh GtDiffElement creation, styling, layout, readiness and first painting to an 800x400 Sparta Form. Models, the Scripter and its container are prepared outside the measured interval. Each case has three warmup renders and seven timed renders. This measures creation through first paint, including Scripter readiness overhead, rather than repainting an existing element. `runRenderingWithIterations:samples:` configures larger batches.

Both runs use #methodFixtures and return a GtDiffBenchmarkResultGroup of GtDiffBenchmarkResult instances, a subclass of BenchmarkResult. Each result represents the median batch: #iterations is the batch iteration count, #elapsedTime is its total duration, and #period is the median time per operation. #samples retains every batch as a BenchmarkResult. Results also expose #method, #caseName, source sizes and a representative #model; rendering results retain the final #element, #form and #viewportExtent. Modified method sources are never installed.
"
Class {
	#name : #GtDiffBenchmark,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #'private - running' }
GtDiffBenchmark >> benchmarkCasesUsing: aBlock [
	^ GtDiffBenchmarkResultGroup
		withAll: (self methodFixtures
				flatCollect: [ :fixture | 
					| method source cases |
					method := fixture key.
					source := method sourceCode.
					self assert: source ~= fixture value.
					cases := {'Removed method'
								-> {source.
										''}.
							'Added method'
								-> {''.
										source}.
							'Changed method'
								-> {source.
										fixture value}}.
					cases
						collect: [ :each | 
							(aBlock value: each value first value: each value second)
								method: method;
								caseName: each key;
								yourself ] ])
]

{ #category : #'private - measuring' }
GtDiffBenchmark >> measureBlock: aBlock iterations: iterations samples: sampleCount [
	^ GtDiffBenchmarkResult new
		samples: ((1 to: sampleCount)
				collect: [ :sample | 
					BenchmarkResult new
						iterations: iterations;
						elapsedTime: (Duration microSeconds: [ iterations timesRepeat: aBlock ] microsecondsToRun);
						yourself ]);
		yourself
]

{ #category : #'private - measuring' }
GtDiffBenchmark >> measureFrom: previous to: proposed iterations: iterations samples: sampleCount [
	| buildModel model |
	buildModel := [ GtDiffBuilder
			computeDifferencesFrom: previous
			to: proposed
			using: GtSmaCCDiffSplitter forPharo ].
	model := buildModel value.
	100 timesRepeat: [ buildModel value ].
	^ (self
		measureBlock: buildModel
		iterations: iterations
		samples: sampleCount)
		model: model;
		yourself
]

{ #category : #'private - measuring' }
GtDiffBenchmark >> measureRenderingFrom: previous to: proposed iterations: iterations samples: sampleCount [
	"Measure a fresh element through its first paint. Model and space creation are outside the timing."

	| model scripter container render result element form |
	model := GtDiffBuilder
			computeDifferencesFrom: previous
			to: proposed
			using: GtSmaCCDiffSplitter forPharo.
	scripter := BlScripter new.
	scripter extent: 800 @ 400.
	container := BrFrame new matchParent.
	scripter element: container.
	render := [ container removeChildren.
		element := self newElementFor: model.
		container addChild: element.
		scripter pulseUntilReady.
		form := scripter space asSpartaForm ].
	3 timesRepeat: [ render value ].
	result := self
			measureBlock: render
			iterations: iterations
			samples: sampleCount.
	self assert: form extent = (800 @ 400).
	^ result
		model: model;
		element: element;
		form: form;
		yourself
]

{ #category : #fixtures }
GtDiffBenchmark >> methodFixtures [
	"Each association pairs a real method with a modified version of its source."

	| small medium large veryLarge |
	small := GtDiffBuilder >> #splitter.
	medium := GtDiffBuilder >> #computeLCSElementsBetween:and:.
	large := GtDiffBuilder >> #lcsFor:and:.
	veryLarge := BlGridLayoutImpl >> #layout:in:context:.
	^ {small
			-> (small sourceCode copyReplaceAll: '^ splitter' with: '^ splitter copy').
		medium
			-> (medium sourceCode
					copyReplaceAll: 'Dictionary new'
					with: 'IdentityDictionary new').
		large -> (large sourceCode copyReplaceAll: 'put: 0' with: 'put: 1').
		veryLarge
			-> (veryLarge sourceCode copyReplaceAll: 'paddingLeft' with: 'leftPadding')}
]

{ #category : #'private - measuring' }
GtDiffBenchmark >> newElementFor: aDiffModel [
	^ (GtDiffElement onChange: aDiffModel)
		aptitude: GtDiffFlatAptitude;
		matchParent;
		beSmallSize;
		fromLabel: 'Previous';
		toLabel: 'Proposed';
		moveButtonsToBottom;
		yourself
]

{ #category : #running }
GtDiffBenchmark >> run [
	<gtExample>
	<noTest>
	<return: #GtDiffBenchmarkResultGroup>
	^ self runWithIterations: 1000 samples: 7
]

{ #category : #running }
GtDiffBenchmark >> runRendering [
	<gtExample>
	<noTest>
	<return: #GtDiffBenchmarkResultGroup>
	^ self runRenderingWithIterations: 1 samples: 7
]

{ #category : #running }
GtDiffBenchmark >> runRenderingWithIterations: iterations samples: sampleCount [
	self assert: (iterations isInteger and: [ iterations > 0 ]).
	self
		assert: (sampleCount isInteger and: [ sampleCount > 0 and: [ sampleCount odd ] ]).
	^ self
		benchmarkCasesUsing: [ :previous :proposed | 
			self
				measureRenderingFrom: previous
				to: proposed
				iterations: iterations
				samples: sampleCount ]
]

{ #category : #running }
GtDiffBenchmark >> runWithIterations: iterations samples: sampleCount [
	self assert: (iterations isInteger and: [ iterations > 0 ]).
	self
		assert: (sampleCount isInteger and: [ sampleCount > 0 and: [ sampleCount odd ] ]).
	^ self
		benchmarkCasesUsing: [ :previous :proposed | 
			self
				measureFrom: previous
				to: proposed
				iterations: iterations
				samples: sampleCount ]
]
