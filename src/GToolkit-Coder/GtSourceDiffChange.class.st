Class {
	#name : #GtSourceDiffChange,
	#superclass : #GtDiffChange,
	#instVars : [
		'startIndex',
		'stopIndex',
		'source'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'instance creation' }
GtSourceDiffChange class >> on: aCollection from: startIndex to: stopIndex [
	^ self new
		source: aCollection;
		startIndex: startIndex;
		stopIndex: stopIndex;
		yourself
]

{ #category : #accessing }
GtSourceDiffChange >> gtLiveFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Source';
		text: [ | stream |
			stream := BlTextStream new.
			stream next putAll: (source copyFrom: 1 to: startIndex - 1) asString.
			stream next
				highlight: self highlightColor;
				putAll: self objects asString.
			stream next putAll: (source copyFrom: stopIndex + 1 to: source size) asString.
			stream contents ]
]

{ #category : #accessing }
GtSourceDiffChange >> gtObjectsText [
	^ self objects asString asRopedText glamorousRegularFont
		highlight: self highlightColor
]

{ #category : #accessing }
GtSourceDiffChange >> highlightColor [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtSourceDiffChange >> objects [
	^ source copyFrom: self startIndex to: self stopIndex
]

{ #category : #accessing }
GtSourceDiffChange >> range [
	^ self startIndex printString , '-' , self stopIndex printString
]

{ #category : #accessing }
GtSourceDiffChange >> source [
	^ source
]

{ #category : #accessing }
GtSourceDiffChange >> source: aCollection [
	source := aCollection
]

{ #category : #accessing }
GtSourceDiffChange >> startIndex [
	^ startIndex
]

{ #category : #accessing }
GtSourceDiffChange >> startIndex: anInteger [
	startIndex := anInteger
]

{ #category : #accessing }
GtSourceDiffChange >> stopIndex [
	^ stopIndex
]

{ #category : #accessing }
GtSourceDiffChange >> stopIndex: anInteger [
	stopIndex := anInteger
]
