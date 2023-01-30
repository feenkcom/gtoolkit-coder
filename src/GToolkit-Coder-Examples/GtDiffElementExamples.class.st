Class {
	#name : #GtDiffElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #examples }
GtDiffElementExamples >> changeElementExample [
	<gtExample>

	^ GtDiffElement onChange: self exampleChange
]

{ #category : #examples }
GtDiffElementExamples >> changeExampleFlat [
	<gtExample>
	^ self changeElementExample aptitude: GtDiffFlatAptitude
]

{ #category : #examples }
GtDiffElementExamples >> changeExampleShadow [
	<gtExample>
	^ self changeElementExample aptitude: GtDiffShadowAptitude
]

{ #category : #examples }
GtDiffElementExamples >> exampleChange [
	<gtExample>
	^ GtDiffBuilder
		computeDifferencesFrom: self originalString
		to: self newString
		using: GtCharacterGroupDiffSplitter words ignoreWhitespace
]

{ #category : #examples }
GtDiffElementExamples >> exampleTextDiff [
	<gtExample>
	^ TextDiffBuilder from: self originalString to: self newString
]

{ #category : #examples }
GtDiffElementExamples >> newString [
	<gtExample>
	^ String
		streamContents: [ :str | 
			1 to: 1000 by: 6 do: [ :i | 
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
	^ String
		streamContents: [ :str | 
			1 to: 1000 by: 5 do: [ :i | 
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

	^ GtDiffElement onDiff: self exampleTextDiff
]

{ #category : #examples }
GtDiffElementExamples >> textDiffExampleFlat [
	<gtExample>
	^ self textDiffElementExample aptitude: GtDiffFlatAptitude
]

{ #category : #examples }
GtDiffElementExamples >> textDiffExampleShadow [
	<gtExample>
	^ self textDiffElementExample aptitude: GtDiffShadowAptitude
]
