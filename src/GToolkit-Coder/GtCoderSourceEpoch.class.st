Class {
	#name : #GtCoderSourceEpoch,
	#superclass : #Object,
	#instVars : [
		'timestamp'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #accessing }
GtCoderSourceEpoch >> age [
	^ DateAndTime now - timestamp
]

{ #category : #initialization }
GtCoderSourceEpoch >> initialize [
	super initialize.
	
	timestamp := DateAndTime now
]

{ #category : #accessing }
GtCoderSourceEpoch >> nextEpoch [
	^ self class new
]
