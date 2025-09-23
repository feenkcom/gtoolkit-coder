Class {
	#name : #GtDiffElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #examples }
GtDiffElementExamples >> changeElementExample [
	<gtExample>
	<return: #GtDiffElement>
	^ (GtDiffElement onChange: self exampleChange) showButtons
]

{ #category : #examples }
GtDiffElementExamples >> changeElementScrollsToFirstDiff [
	<gtExample>
	<return: #GtDiffElement>
	| scripter |
	scripter := BlScripter new.
	scripter extent: 800 @ 800.
	scripter
		element: ((GtDiffElement onChange: self exampleChange)
				matchParent;
				showButtons;
				yourself).
	scripter
		checkStep: [ :s | 
			s
				label: 'Check has scrolled';
				// GtDiffButtonsId;
				// #label;
				do: [ :each | self assert: (each text asString beginsWith: '1/') ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'Can scroll text up';
				// GtDiffOldTextId;
				do: [ :each | self assert: each canScrollUp ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> changeElementWithoutScroll [
	<gtExample>
	<return: #GtDiffElement>
	| scripter |
	scripter := BlScripter new.
	scripter extent: 800 @ 800.
	scripter
		element: ((GtDiffElement onChangeWithoutScrolling: self exampleChange)
				matchParent;
				showButtons;
				yourself).
	scripter
		checkStep: [ :s | 
			s
				label: 'Check has scrolled';
				// GtDiffButtonsId;
				// #label;
				do: [ :each | self assert: (each text asString beginsWith: '0/') ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'Can scroll text up';
				// GtDiffOldTextId;
				do: [ :each | self assert: each canScrollUp not ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> changeExampleFlat [
	<gtExample>
	<return: #GtDiffElement>
	^ self changeElementExample aptitude: GtDiffFlatAptitude
]

{ #category : #examples }
GtDiffElementExamples >> changeExampleShadow [
	<gtExample>
	<return: #GtDiffElement>
	^ self changeElementExample aptitude: GtDiffShadowAptitude
]

{ #category : #examples }
GtDiffElementExamples >> exampleChange [
	<gtExample>
	<return: #GtCompositeDiffChange>
	^ GtDiffBuilder
		computeDifferencesFrom: self originalString
		to: self newString
		using: GtCharacterGroupDiffSplitter words ignoreWhitespace
]

{ #category : #examples }
GtDiffElementExamples >> exampleTextDiff [
	<gtExample>
	<return: #TextDiffBuilder>
	^ TextDiffBuilder from: self originalString to: self newString
]

{ #category : #examples }
GtDiffElementExamples >> newString [
	<gtExample>
	<return: #ByteString>
	^ String
		streamContents: [ :str | 
			1
				to: 1000
				by: 6
				do: [ :i | 
					str
						print: i;
						cr;
						print: i + 1;
						cr;
						print: i + 2;
						cr ] ]
]

{ #category : #examples }
GtDiffElementExamples >> originalString [
	<gtExample>
	<return: #ByteString>
	^ String
		streamContents: [ :str | 
			1
				to: 1000
				by: 5
				do: [ :i | 
					str
						print: i;
						cr;
						print: i + 1;
						cr;
						print: i + 2;
						cr ] ]
]

{ #category : #examples }
GtDiffElementExamples >> textDiffElementExample [
	<gtExample>
	<return: #GtDiffElement>
	^ (GtDiffElement onDiff: self exampleTextDiff) showButtons
]

{ #category : #examples }
GtDiffElementExamples >> textDiffExampleFlat [
	<gtExample>
	<return: #GtDiffElement>
	^ self textDiffElementExample aptitude: GtDiffFlatAptitude
]

{ #category : #examples }
GtDiffElementExamples >> textDiffExampleShadow [
	<gtExample>
	<return: #GtDiffElement>
	^ self textDiffElementExample aptitude: GtDiffShadowAptitude
]
