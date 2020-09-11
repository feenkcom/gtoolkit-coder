Class {
	#name : #GtMethodCommentFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #examples }
GtMethodCommentFilterExamples >> sampleCaseInsensitiveWordFilter [
	<gtExample>
	| filter locations positions |
	filter := GtSearchCommentsFilter new.
	filter caseSensitive: false.
	filter text: 'Object'.
	locations := self sampleMethodWithComments.
	positions := (locations first , locations last) asSortedCollection
		readStream.
	self validateFilter: filter returnsPositions: positions.
	^ filter
]

{ #category : #samples }
GtMethodCommentFilterExamples >> sampleMethodWithComments [
	"Object anObject (Object>>printString) {class:Object} ObjectClass"

	| positions |
	positions := Array new: 3.	"object Object"
	positions at: 1 put: #(28 45 73 146).
	positions at: 2 put: #(37 81).
	positions at: 3 put: #(139).
	^ positions
]

{ #category : #accessing }
GtMethodCommentFilterExamples >> sampleSubstringCommentFilter [
	<gtExample>
	| filter locations positions |
	filter := GtSearchCommentsFilter new.
	filter wholeWord: false.
	filter text: 'Object'.
	locations := self sampleMethodWithComments.
	positions := (locations first , locations second) asSortedCollection
		readStream.
	self validateFilter: filter returnsPositions: positions.
	^ filter
]

{ #category : #examples }
GtMethodCommentFilterExamples >> sampleWordFilter [
	<gtExample>
	| filter positions |
	filter := GtSearchCommentsFilter new.
	filter text: 'Object'.
	positions := self sampleMethodWithComments first readStream.
	self validateFilter: filter returnsPositions: positions.
	^ filter
]

{ #category : #accessing }
GtMethodCommentFilterExamples >> validateFilter: filter returnsPositions: positions [
	| method |
	method := self class >> #sampleMethodWithComments.
	self assert: (filter matches: method).
	self assert: (filter matches: self class >> #sampleWordFilter) not.
	filter
		matchingIntervalsInMethod: method
		do: [ :interval | 
			self assert: interval first = positions next.
			self assert: interval size = 'Object' size ].
	self assert: positions atEnd
]
