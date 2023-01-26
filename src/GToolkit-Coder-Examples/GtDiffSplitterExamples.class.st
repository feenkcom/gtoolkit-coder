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

{ #category : #'token splitter' }
GtDiffSplitterExamples >> javascriptDiffSplitter [
	<gtExample>
	| splits scannerClass splitter |
	scannerClass := self class environment at: #JSScanner ifAbsent: [ ^ nil ].
	splitter := GtSmaCCDiffSplitter new scannerClass: scannerClass.
	splits := splitter split: '/*1*/for(i=0; i<10; i++/*2*/) console.log(i);//3'.
	#('/*1*/' 'for' '(' 'i' '=' '0' ';' 'i' '<' '10' ';' 'i' '++' '/*2*/' ')' 'console' '.' 'log' '(' 'i' ')' ';' '//3')
		doWithIndex: [ :each :i | self assert: (splits at: i) object equals: each ].
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
	self assert: (splits at: 1) object equals: '1' , String crlf.
	self assert: (splits at: 2) object equals: '2' , String cr.
	self assert: (splits at: 3) object equals: '3' , String lf.
	self assert: (splits at: 4) object equals: '4'.
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
	self assert: splits splits asSet size equals: 1.
	self assert: (splits at: 1) object equals: '1'.
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

{ #category : #'character groups' }
GtDiffSplitterExamples >> wordIgnoreWhitespaceSplitter [
	<gtExample>
	| splits words |
	words := #('This ' 'is ' 'a ' 'test' '.
	' '123' ',' '45').
	splits := GtCharacterGroupDiffSplitter words ignoreWhitespace
			split: ('' join: words).
	self assert: splits size equals: words size.
	1
		to: words size
		do: [ :i | self assert: (splits at: i) object equals: (words at: i) trim ].
	^ splits
]

{ #category : #'character groups' }
GtDiffSplitterExamples >> wordSplitter [
	<gtExample>
	| splits words |
	words := #('This' 'is' 'a' 'test').
	splits := GtCharacterGroupDiffSplitter words split: ('	' join: words).
	self assert: splits size equals: words size * 2 - 1.
	1
		to: words size
		do: [ :i | self assert: (splits at: i * 2 - 1) object equals: (words at: i) trim ].
	1
		to: words size - 1
		do: [ :i | self assert: (splits at: i * 2) object equals: '	' ].
	^ splits
]
