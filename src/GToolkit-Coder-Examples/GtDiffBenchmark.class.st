"
I benchmark diff models and actual diff elements for removed, added, and changed methods of different source sizes.

Evaluate `GtDiffBenchmark new run` to measure GtDiffBuilder model creation with a fresh Pharo token splitter. By default I use seven batches of 1000 creations after warmup.

Evaluate `GtDiffBenchmark new runRendering` to measure fresh GtDiffElement creation, styling, layout, readiness and first painting to an 800x400 Sparta Form. Models, the Scripter and its container are prepared outside the measured interval. Each case has three warmup renders and seven timed renders. This measures creation through first paint, including Scripter readiness overhead, rather than repainting an existing element. `runRenderingWithIterations:samples:` configures larger batches.

Both runs use #methodFixtures and return source sizes, median microseconds per operation and all batch samples. Model results include a representative model; rendering results also include the final element and Form for inspection. Modified method sources are never installed.
"
Class {
	#name : #GtDiffBenchmark,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #'private - running' }
GtDiffBenchmark >> benchmarkCasesUsing: aBlock [
	^ self methodFixtures
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
						at: #method put: method;
						at: #sourceLines put: source lines size;
						at: #sourceCharacters put: source size;
						at: #case put: each key;
						yourself ] ]
]

{ #category : #'private - measuring' }
GtDiffBenchmark >> measureFrom: previous to: proposed iterations: iterations samples: sampleCount [
	| buildModel samples model |
	buildModel := [ GtDiffBuilder
			computeDifferencesFrom: previous
			to: proposed
			using: GtSmaCCDiffSplitter forPharo ].
	model := buildModel value.
	100 timesRepeat: [ buildModel value ].
	samples := (1 to: sampleCount)
			collect: [ :sample | 
				[ iterations timesRepeat: [ buildModel value ] ] microsecondsToRun
					/ iterations asFloat ].
	^ Dictionary new
		at: #iterationsPerSample put: iterations;
		at: #medianMicrosecondsPerModel
			put: (samples sorted at: samples size // 2 + 1);
		at: #microsecondsPerModelSamples put: samples;
		at: #model put: model;
		yourself
]

{ #category : #'private - measuring' }
GtDiffBenchmark >> measureRenderingFrom: previous to: proposed iterations: iterations samples: sampleCount [
	"Measure a fresh element through its first paint. Model and space creation are outside the timing."

	| model scripter container render samples element form |
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
	samples := (1 to: sampleCount)
			collect: [ :sample | 
				[ iterations timesRepeat: [ render value ] ] microsecondsToRun
					/ iterations asFloat ].
	self assert: form extent = (800 @ 400).
	^ Dictionary new
		at: #iterationsPerSample put: iterations;
		at: #medianMicrosecondsPerElement
			put: (samples sorted at: samples size // 2 + 1);
		at: #microsecondsPerElementSamples put: samples;
		at: #viewportExtent put: 800 @ 400;
		at: #model put: model;
		at: #element put: element;
		at: #form put: form;
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
	<return: #Array>
	^ self runWithIterations: 1000 samples: 7
]

{ #category : #running }
GtDiffBenchmark >> runRendering [
	<gtExample>
	<noTest>
	<return: #Array>
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
