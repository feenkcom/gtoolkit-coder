Class {
	#name : #GtDiffSplitterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #'null splitter' }
GtDiffSplitterExamples >> characterSplitterExample [
	<gtExample>
	^ self compareNullSplits: '1234'
]

{ #category : #'null splitter' }
GtDiffSplitterExamples >> compareNullSplits: aCollection [
	| splits values |
	values := aCollection , aCollection reversed.
	splits := GtNullDiffSplitter new split: values.
	self assert: values size = splits size.
	1
		to: splits size
		do: [ :i | 
			self assert: (splits at: i) equals: (splits at: splits size - i + 1).
			self
				assert: (splits at: i) hash
				equals: (splits at: splits size - i + 1) hash.
			self assert: (splits at: i) object = (values at: i) ].
	^ splits
]

{ #category : #lines }
GtDiffSplitterExamples >> lineWithEOLSplitterExample [
	<gtExample>
	| splitter splits string |
	string := '1' , String crlf , '2' , String cr , '3' , String lf , '4'.
	splitter := GtLineDiffSplitter new
			includeEOLChars: true;
			yourself.
	splits := splitter split: string.
	self assert: splits size = 4.
	self assert: splits first object equals: '1' , String crlf.
	self assert: splits second object equals: '2' , String cr.
	self assert: splits third object equals: '3' , String lf.
	self assert: splits fourth object equals: '4'.
	^ splits
]

{ #category : #lines }
GtDiffSplitterExamples >> lineWithoutEOLSplitterExample [
	<gtExample>
	| splitter splits string |
	string := '1' , String crlf , '1' , String cr , '1' , String lf , '1'.
	splitter := GtLineDiffSplitter new
			includeEOLChars: false;
			yourself.
	splits := splitter split: string.
	self assert: splits size = 4.
	self assert: splits asSet size equals: 1.
	self assert: splits first object equals: '1'.
	^ splits
]

{ #category : #'null splitter' }
GtDiffSplitterExamples >> objectSplitterExample [
	<gtExample>
	^ self
		compareNullSplits: {1.
				'foo'.
				Object new.
				#(1 2 3).
				1.2}
]
